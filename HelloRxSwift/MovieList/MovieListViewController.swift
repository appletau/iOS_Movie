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
        let data = MovieListType.allCases.map {ScrollableTabData(title: $0.chineseTitle)}
        observer.onNext(data)
        observer.onCompleted()
        return Disposables.create()
    }
    
    private let ViewModel = MovieListViewModel()
    private let bag = DisposeBag()
    
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
        tabData.bind(to: tabView.dataArray).disposed(by: bag)
        
        tabView.didTapItem.compactMap {($0?.title)}.bind(to: ViewModel.input.MovieListName).disposed(by: bag)
        
        ViewModel.output.movieListSearchResult.bind(to: tableView.rx.items(cellIdentifier: String(describing: MovieListCell.self), cellType: MovieListCell.self)) { (row, element, cell) in
            cell.setup(model: element)
        }.disposed(by: bag)
        
        ViewModel.output.loadingMovieListIsFinished.subscribe(onNext: { (_) in
            self.tableView.scrollToTop()
        }).disposed(by: bag)
    }
}
