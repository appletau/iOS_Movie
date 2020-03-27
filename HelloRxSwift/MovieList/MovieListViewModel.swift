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
        let MovieListName:AnyObserver<String>
    }
    
    struct Output {
        let movieListSearchResult:PublishRelay<[MovieSubject]>
        let loadingMovieListIsFinished:Observable<()>
    }
    
    let input: Input
    let output: Output
    
    private let movieListNameSub = PublishSubject<String>()
    private let movieListResultSub = PublishRelay<[MovieSubject]>()
    
    private let bag = DisposeBag()
    
    init() {
        let isFinishedLoadingList = self.movieListResultSub.map {_ in ()}
        
        self.output = Output(movieListSearchResult: movieListResultSub, loadingMovieListIsFinished: isFinishedLoadingList)
        self.input = Input(MovieListName: movieListNameSub.asObserver())
        
        movieListNameSub.subscribe(onNext: {[weak self] (name) in
            self?.selectMovieListType(title: name)
        }).disposed(by: bag)
    }
}

extension MovieListViewModel {
    
    private func selectMovieListType(title:String) {
        switch title {
        case "Top250":
            self.searchMovieList(type: TopMovie.self)
        case "口碑榜":
            self.searchMovieList(type: WeeklyBox.self)
        case "北美票房榜":
            self.searchMovieList(type: USBox.self)
        case "新片榜":
            self.searchMovieList(type: NewMovie.self)
        case "即將上映":
            self.searchMovieList(type: ComingSoon.self)
        case "正在熱映":
            self.searchMovieList(type: InTheaters.self)
        default:
            return
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
