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
        let MovieListType:BehaviorRelay<MovieListType?>
    }
    
    struct Output {
        let movieListCellVMsRelay:BehaviorRelay<[MovieListCellViewModel]>
        let loadingMovieListIsFinished:Driver<Bool>
    }
    
    let input: Input
    let output: Output
    
    private let movieListTypeRelay = BehaviorRelay<MovieListType?>(value: nil)
    private let movieListCellVMsRelay = BehaviorRelay<[MovieListCellViewModel]>(value: [])
    private let endRefreshSub = PublishSubject<Void>()
    private let bag = DisposeBag()
    
    init() {
        let isFinishedLoadingList = self.movieListCellVMsRelay.asDriver().map {$0.count > 0 ? true : false}
        self.output = Output(movieListCellVMsRelay: movieListCellVMsRelay,
                             loadingMovieListIsFinished: isFinishedLoadingList)
        self.input = Input(MovieListType: movieListTypeRelay)
        movieListTypeRelay.subscribe(onNext: {[weak self] (type) in
            guard let type = type else {return}
            self?.selectMovieList(type: type)
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
        APIService.shared.request(Movie.GetMovieList(type: type, parameters: ["apikey":apiKey])).map({ [weak self] (list) -> [MovieListCellViewModel] in
            guard let self = self else {return []}
            self.endRefreshSub.onNext(())
            let subList = self.getMovieSubjects(list: list)
            let cellViewModels = self.convertToCellVMs(withSubjectList: subList)
            return cellViewModels
        }).asObservable().bind(to: self.movieListCellVMsRelay).disposed(by: bag)
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
        selectMovieList(type: movieListTypeRelay.value!)
    }

    var endRefresh: PublishSubject<Void> {
        return self.endRefreshSub
    }


}
