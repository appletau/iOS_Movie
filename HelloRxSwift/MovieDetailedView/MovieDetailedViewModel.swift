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
    case mainInfo
    case rating
    case summary
    case celebrity
    case photos
    case popularComment
    
    func getHeaderName(withString string:String = "") ->String {
        switch self {
        case .mainInfo:
            return "" + string
        case .rating:
            return "評分：" + string
        case .summary:
            return "劇情簡介：" + string
        case .celebrity:
            return "演職員" + string
        case .photos:
            return "劇照：" + string
        case .popularComment:
            return "熱評：" + string
        }
    }
}

class MovieDetailedViewModel:ViewModelType {
    
    struct Input {
    }
    
    struct Output {
        let sections:BehaviorRelay<[Section]>
        let movieTitle:BehaviorRelay<String>
        let loadingMovieIsFinished:Driver<Bool>
        let errorOccurred:Driver<Bool>
    }
    
    let input: Input
    let output: Output
    
    private let sectionsRelay = BehaviorRelay<[Section]>(value: [])
    private let movieTitleRelay = BehaviorRelay<String>(value:"")
    private let loadingMovieIsFinishedRelay = BehaviorRelay(value: false)
    private let errorOccurredRelay = BehaviorRelay<Bool>(value: false)
    private let endRefreshSub = PublishSubject<Void>()
    private let bag = DisposeBag()
    private var movieID:String = "" {
        didSet {
            self.searchMovie(id: movieID)
        }
    }
    
    init() {
        self.input = Input()
        self.output = Output(sections: sectionsRelay, movieTitle: movieTitleRelay,
                             loadingMovieIsFinished: loadingMovieIsFinishedRelay.asDriver(),
                             errorOccurred: errorOccurredRelay.asDriver())
    }
}

extension MovieDetailedViewModel {
    
    func setMovieID(_ id:String) {
        self.movieID = id 
    }
    
    private func searchMovie(id:String) {
        //clear
        sectionsRelay.accept([])
        self.errorOccurredRelay.accept(false)
        //get
        APIService.shared.request(Movie.GetMovie(id: id, parameters: ["apikey":apiKey])).subscribe(onSuccess: {[weak self] (movieSubject) in
            guard let self = self else {return}
            self.endRefreshSub.onNext(())
            self.loadingMovieIsFinishedRelay.accept(true)
            self.movieTitleRelay.accept(movieSubject.title)
            self.sectionsRelay.accept(self.convertToSction(withMovieSubject: movieSubject))
            }, onError: { _ in
                self.endRefreshSub.onNext(())
                self.errorOccurredRelay.accept(true)
                self.loadingMovieIsFinishedRelay.accept(true)
        }).disposed(by: bag)
    }
    
    private func convertToSction(withMovieSubject sub:NormalSubject) -> [Section] {
        var sections:[Section] = []
        for type in MovieDetailedCellContent.allCases {
            let headerName = type == .rating ? type.getHeaderName(withString: "\(sub.rating?.average ?? 0)") : type.getHeaderName()
            let cellVMs = createCellVMs(type: type, withMovieSubject: sub)
            let section = Section(headerName: headerName, cellViewModels: cellVMs)
            sections.append(section)
        }
        return sections
    }
    
    private func createCellVMs(type:MovieDetailedCellContent, withMovieSubject sub:NormalSubject) -> [CellViewModel]{
        let movieSub = Observable.just(sub)
        switch type {
        case .mainInfo:
            let mainCellVM = MainInfoCellViewModel()
            movieSub.bind(to: mainCellVM.input.movieSubject).disposed(by: mainCellVM.bag)
            return [mainCellVM]
        case .rating:
            let ratingCellVM = RatingCellViewModel()
            movieSub.bind(to: ratingCellVM.input.movieSubject).disposed(by: ratingCellVM.bag)
            return [ratingCellVM]
        case .summary:
            let summaryCellVM = SummaryCellViewModel()
            movieSub.bind(to: summaryCellVM.input.movieSubject).disposed(by: summaryCellVM.bag)
            return [summaryCellVM]
        case .celebrity:
            let celebrityCellVM = CelebrityCellViewModel()
            movieSub.bind(to: celebrityCellVM.input.movieSubject).disposed(by: celebrityCellVM.bag)
            return [celebrityCellVM]
        case .photos:
            let photosCellVM = PhotoCellViewModel()
            movieSub.bind(to: photosCellVM.input.movieSubject).disposed(by: photosCellVM.bag)
            return [photosCellVM]
        case .popularComment:
            let commentCellVMs = sub.popular_comments.map { (comment) -> CommentCellViewModel in
                let commentCellVM = CommentCellViewModel()
                Observable.just(comment).bind(to: commentCellVM.input.comment).disposed(by: commentCellVM.bag)
                return commentCellVM
            }
            return commentCellVMs
        }
    }
}

extension MovieDetailedViewModel:Refreshable {
    func refreshData() {
        searchMovie(id: movieID)
    }
    
    var endRefresh: PublishSubject<Void> {
        return endRefreshSub
    }
}
