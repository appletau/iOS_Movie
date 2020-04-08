//
//  MovieListViewModel.swift
//  HelloRxSwift
//
//  Created by ST_Ben.Huang 黃韋韜 on 2020/3/26.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

class MovieListViewModel:ViewModelType {
    
    struct Input {
        let MovieListType:AnyObserver<MovieListType>
    }
    
    struct Output {
        let movieListCellVMsRelay:BehaviorRelay<[MovieListCellViewModel]>
        let loadingMovieListIsFinished:Driver<Bool>
        let errorOccurred:Driver<Bool>
    }
    
    let input: Input
    let output: Output
    
    private let movieListTypeSub = PublishSubject<MovieListType>()
    private let movieListCellVMsRelay = BehaviorRelay<[MovieListCellViewModel]>(value: [])
    private let endRefreshSub = PublishSubject<Void>()
    private let isFinishedLoadingListRelay = BehaviorRelay<Bool>(value: false)
    private let errorOccurredRelay = BehaviorRelay<Bool>(value: false)
    private let bag = DisposeBag()
    private var movieListType = MovieListType.top250
    
    init() {
        self.input = Input(MovieListType: movieListTypeSub.asObserver())
        self.output = Output(movieListCellVMsRelay: movieListCellVMsRelay,
                             loadingMovieListIsFinished: isFinishedLoadingListRelay.asDriver(),
                             errorOccurred: errorOccurredRelay.asDriver())
        movieListTypeSub.subscribe(onNext: {[weak self] (type) in
            guard let self = self else {return}
            self.movieListType = type
            self.errorOccurredRelay.accept(false)
            self.isFinishedLoadingListRelay.accept(false)
            self.selectMovieList(type: type)
        }).disposed(by: bag)
    }
}

extension MovieListViewModel {
    private func selectMovieList(type:MovieListType) {
        switch type {
        case .top250:
            self.searchMovieList(type: TopMovie.self)
        case .us_box:
            self.searchMovieList(type: USBox.self)
        case .weekly:
            self.searchMovieList(type: WeeklyBox.self)
        case .new_movies:
            self.searchMovieList(type: NewMovie.self)
        case .in_theaters:
            self.searchMovieList(type: InTheaters.self)
        case .coming_soon:
            self.searchMovieList(type: ComingSoon.self)
        }
    }
    
    private func searchMovieList<T:MovieList>(type:T.Type) {
        // clear
        movieListCellVMsRelay.accept([])
        // get
        APIService.shared.request(Movie.GetMovieList(type: type, parameters: ["apikey":apiKey])).subscribe(onSuccess: { [weak self] (list) in
            guard let self = self else {return}
            let subList = self.getMovieSubjects(list: list)
            let cellViewModels = self.convertToCellVMs(withSubjectList: subList)
            self.movieListCellVMsRelay.accept(cellViewModels)
            self.endRefreshSub.onNext(())
            self.isFinishedLoadingListRelay.accept(true)
            }, onError: { _ in
                self.endRefreshSub.onNext(())
                self.errorOccurredRelay.accept(true)
                self.isFinishedLoadingListRelay.accept(true)
        }).disposed(by: bag)
    }
    
    private func getMovieSubjects<T:MovieList>(list:T) -> [NormalSubject] {
        if let subjects = list.subjects as? [WeeklySubject] {
            return subjects.map { $0.subject }
        } else if let subjects = list.subjects as? [BoxSubject] {
            return subjects.map { $0.subject }
        }else if let subjects = list.subjects as? [NormalSubject] {
            return subjects
        }
        return []
    }
    
    private func convertToCellVMs(withSubjectList subList:[NormalSubject]) -> [MovieListCellViewModel] {
        return subList.map { (sub) -> MovieListCellViewModel in
            let vm = MovieListCellViewModel()
            Observable.just(sub).bind(to: vm.input.movieSubject).disposed(by: vm.bag)
            return vm
        }
    }
}

extension MovieListViewModel:Refreshable {
    func refreshData() {
        selectMovieList(type: self.movieListType)
    }
    
    var endRefresh: PublishSubject<Void> {
        return endRefreshSub
    }
    
    
}
