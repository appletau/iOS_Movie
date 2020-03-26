//
//  MovieListViewController.swift
//  HelloRxSwift
//
//  Created by ST_Ben.Huang 黃韋韜 on 2020/3/25.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya

class MovieListViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var functionListBtn: UIButton!
    @IBOutlet weak var tabView: ScrollableTabView!
    @IBOutlet weak var tableView: UITableView!
    
    struct ScrollableTabData:ScrollableTabViewData {
        var title: String
        
        var id: Int?
        init(title:String, id:Int = -1) {
            self.title = title
            self.id = id
        }
    }
    
    let tabData:Observable<[ScrollableTabViewData]> = Observable.create { (observer) -> Disposable in
        let data = ["Top250","口碑榜","北美票房榜","新片榜","即將上映","正在熱映"].map {ScrollableTabData(title: $0)}
        observer.onNext(data)
        observer.onCompleted()
        return Disposables.create()
    }
    
    let movies = PublishRelay<[MovieSubject]>()
    
    
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        self.binding()
    }
    

}

extension MovieListViewController {
    
    private func registerCell() {
        tableView.register(UINib(nibName: String(describing: MovieListCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MovieListCell.self))
    }
    
    private func binding() {
        movies.bind(to: tableView.rx.items(cellIdentifier: String(describing: MovieListCell.self), cellType: MovieListCell.self)) { (row, element, cell) in
            cell.setup(model: element)
        }
        .disposed(by: bag)

        tabData.bind(to: tabView.dataArray).disposed(by: bag)
        
        tabView.didTapItem.subscribe(onNext: { (tabData) in
            guard let title = tabData?.title else {return}
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
        }).disposed(by: bag)
    }
    
    private func searchMovieList<T:MovieList>(type:T.Type) {
        APIService.shared.request(Movie.GetMovieList(type: type, parameters: ["apikey":apiKey]))
          .subscribe(onSuccess: { (model) in
            self.movies.accept(model.subjects)
            self.tableView.scrollToTop()
          }, onError: { (e) in
            if let e = e as? MoyaError, let errorMessage = try? e.response?.mapJSON() {
              print(errorMessage)
            }
          })
          .disposed(by: bag)
    }
    
}
