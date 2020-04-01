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
        let movieListSearchResult:PublishRelay<[MovieSubject]>
        let loadingMovieListIsFinished:Observable<()>
    }
    
    let input: Input
    let output: Output
    
    private let movieListTypeSub = PublishSubject<MovieListType>()
    private let movieListResultSub = PublishRelay<[MovieSubject]>()
    private let bag = DisposeBag()
    
    init() {
        let isFinishedLoadingList = self.movieListResultSub.map {_ in ()}
        self.output = Output(movieListSearchResult: movieListResultSub, loadingMovieListIsFinished: isFinishedLoadingList)
        self.input = Input(MovieListType: movieListTypeSub.asObserver())
        
        movieListTypeSub.subscribe(onNext: {[weak self] (type) in
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
        APIService.shared.request(Movie.GetMovieList(type: type, parameters: ["apikey":apiKey]))
            .subscribe(onSuccess: {[weak self] (model) in
                self?.movieListResultSub.accept(model.subjects)
            }, onError: { (e) in
                if let e = e as? MoyaError, let errorMessage = try? e.response?.mapJSON() {
                    print(errorMessage)
                }
            })
            .disposed(by: bag)
    }
}
