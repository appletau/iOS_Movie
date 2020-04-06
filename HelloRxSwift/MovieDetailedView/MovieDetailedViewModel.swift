//
//  MovieDetailedViewModel.swift
//  HelloRxSwift
//
//  Created by ST_Ben.Huang 黃韋韜 on 2020/3/30.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import RxDataSources

enum MovieDetailedCellContent:Int ,CaseIterable {
    case main_info
    case rating
    case summary
    case celebrity
    case photos
    case popular_comment
}

class MovieDetailedViewModel:ViewModelType {
    
    struct Input {
        let subjectID:AnyObserver<String>
    }
    
    struct Output {
        let sections:BehaviorRelay<[Section]>
        let movieTitle:BehaviorRelay<String>
    }
    
    let input: Input
    let output: Output
    
    private let idSub = PublishSubject<String>()
    private let sectionsRelay = BehaviorRelay<[Section]>(value: [])
    private let movieTitleRelay = BehaviorRelay<String>(value:"")
    private let bag = DisposeBag()
    
    init() {
        self.input = Input(subjectID: idSub.asObserver())
        self.output = Output(sections: sectionsRelay, movieTitle: movieTitleRelay)
        
        idSub.subscribe(onNext: { (id) in
            self.searchMovie(id: id)
            }).disposed(by: bag)
    }
    
    private func searchMovie(id:String) {
        APIService.shared.request(Movie.GetMovie(id: id, parameters: ["apikey":apiKey]))
            .subscribe(onSuccess: {[weak self] (movieSubject) in
                guard let self = self else {return}
                self.movieTitleRelay.accept(movieSubject.title)
                self.sectionsRelay.accept(self.convertToSction(withMovieSubject: movieSubject))
                }, onError: { (e) in
                    if let e = e as? MoyaError, let errorMessage = try? e.response?.mapJSON() {
                        print(errorMessage)
                    }
            })
            .disposed(by: bag)
    }
    
    private func convertToSction(withMovieSubject sub:NormalSubject) -> [Section] {
        let movieSub = Observable.just(sub)
        let mainCellVM = MainInfoCellViewModel()
        let ratingCellVM = RatingCellViewModel()
        let summaryCellVM = SummaryCellViewModel()
        let celebrityCellVM = CelebrityCellViewModel()
        let photosCellVM = PhotoCellViewModel()
        movieSub.bind(to: mainCellVM.input.movieSubject).disposed(by: mainCellVM.bag)
        movieSub.bind(to: ratingCellVM.input.movieSubject).disposed(by: ratingCellVM.bag)
        movieSub.bind(to: summaryCellVM.input.movieSubject).disposed(by: summaryCellVM.bag)
        movieSub.bind(to: celebrityCellVM.input.movieSubject).disposed(by: celebrityCellVM.bag)
        movieSub.bind(to: photosCellVM.input.movieSubject).disposed(by: photosCellVM.bag)
        let commentCellVMs = sub.popular_comments.map { (comment) -> CommentCellViewModel in
            let commentCellVM = CommentCellViewModel()
            Observable.just(comment).bind(to: commentCellVM.input.comment).disposed(by: commentCellVM.bag)
            return commentCellVM
        }
        let sections:Array<Section> = [Section(headerName: "", cellViewModels: [mainCellVM]),
                                       Section(headerName: "評分：\(sub.rating?.average ?? 0)", cellViewModels: [ratingCellVM]),
                                       Section(headerName: "劇情簡介：", cellViewModels: [summaryCellVM]),
                                       Section(headerName: "演職員：", cellViewModels: [celebrityCellVM]),
                                       Section(headerName: "劇照：", cellViewModels: [photosCellVM]),
                                       Section(headerName: "熱評：", cellViewModels: commentCellVMs),]
        return sections
    }
}
