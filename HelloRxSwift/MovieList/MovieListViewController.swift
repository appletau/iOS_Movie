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
    
    struct ScrollableTabData:ScrollableTabViewData {
        var title: String
        var id: Int?
        
        init(title:String, id:Int = -1) {
            self.title = title
            self.id = id
        }
    }
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var functionListBtn: UIButton!
    @IBOutlet private weak var tabView: ScrollableTabView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var loadingIndicatorView: LoadingIndicatorView!
    @IBOutlet private weak var technicalProblemView: TechnicalProblemView!
    
    let tabData:Observable<[ScrollableTabViewData]> = Observable.just(MovieListType.allCases.map {ScrollableTabData(title: $0.rawValue)})
    private let viewModel = MovieListViewModel()
    private let bag = DisposeBag()
    
    lazy var refreshControl: RxRefreshControl = {
        return RxRefreshControl(viewModel)
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registerCell()
        binding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

extension MovieListViewController {
    
    private func setupUI() {
        tableView.refreshControl = refreshControl
        searchBar.searchTextField.backgroundColor = .white
        searchBar.barTintColor = UIColor(red: 38/255, green: 171/255, blue: 82/255, alpha: 1)
        functionListBtn.backgroundColor = UIColor(red: 38/255, green: 171/255, blue: 82/255, alpha: 1)
    }
    
    private func registerCell() {
        tableView.register(UINib(nibName: String(describing: MovieListCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MovieListCell.self))
    }
    
    private func binding() {
        tabData.bind(to: tabView.dataArray).disposed(by: bag)
        
        tabView.didTapItem.compactMap {($0?.title)}.compactMap{MovieListType(rawValue: $0)}.bind(to: viewModel.input.MovieListType).disposed(by: bag)
        
        tableView.rx.itemSelected.subscribe(onNext: {[weak self] (indexPath) in
            guard let self = self, let movieID = self.viewModel.output.movieListCellVMsRelay.value[indexPath.row].input.movieSubject.value?.id else {return}
            let vc = self.setupMovieDetailedVC(id: movieID)
            self.navigationController?.pushViewController(vc, animated: false)
        }).disposed(by: bag)
        
        viewModel.output.movieListCellVMsRelay.bind(to: tableView.rx.items(cellIdentifier: MovieListCell.identifier, cellType: MovieListCell.self)) { (row, element, cell) in
            cell.setup(viewModel: element)
        }.disposed(by: bag)
        
        viewModel.output.loadingMovieListIsFinished.drive(onNext: { [weak self] (isLoaded) in
            guard let self = self else {return}
            isLoaded ? self.loadingIndicatorView.stopAnimating() : self.loadingIndicatorView.startAnimating()
        }).disposed(by: bag)
        
        viewModel.output.errorOccurred.map {!$0}.drive(technicalProblemView.rx.isHidden).disposed(by: bag)
    }
    
    private func setupMovieDetailedVC(id:String) -> MovieDetailedViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: String(describing: MovieDetailedViewController.self)) as! MovieDetailedViewController
        vc.setMovieID(id)
        return vc
    }
}
