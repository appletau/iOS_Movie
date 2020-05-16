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
import SkeletonView

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
        tableView.dataSource = self
        setupUI()
        registerCell()
        binding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

extension MovieListViewController: SkeletonTableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.output.movieListCellVMsRelay.value.count
        return count > 0 ? count : 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieListCell.identifier, for: indexPath) as! MovieListCell
        if viewModel.output.movieListCellVMsRelay.value.count > 0 {
            cell.hideSkeleton()
            cell.setup(viewModel: viewModel.output.movieListCellVMsRelay.value[indexPath.row])
        } else {
            cell.showSkeleton()
        }
        return cell
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
       return MovieListCell.identifier
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
        tableView.register(UINib(nibName: MovieListCell.identifier, bundle: nil), forCellReuseIdentifier: MovieListCell.identifier)
    }
    
    private func binding() {
        tabData.bind(to: tabView.dataArray).disposed(by: bag)
        
        tabView.didTapItem.compactMap {($0?.title)}.compactMap{MovieListType(rawValue: $0)}.bind(to: viewModel.input.MovieListType).disposed(by: bag)
        
        tableView.rx.itemSelected.subscribe(onNext: {[weak self] (indexPath) in
            guard let self = self, let movieID = self.viewModel.output.movieListCellVMsRelay.value[indexPath.row].input.movieSubject.value?.id else {return}
            let vc = self.setupMovieDetailedVC(id: movieID)
            self.navigationController?.pushViewController(vc, animated: false)
        }).disposed(by: bag)
        
        viewModel.output.movieListCellVMsRelay.subscribe(onNext: { [weak self] (_) in
            self?.tableView.reloadData()
            }).disposed(by: bag)
        
        viewModel.output.errorOccurred.map {!$0}.drive(technicalProblemView.rx.isHidden).disposed(by: bag)
    }
    
    private func setupMovieDetailedVC(id:String) -> MovieDetailedViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: String(describing: MovieDetailedViewController.self)) as! MovieDetailedViewController
        vc.setMovieID(id)
        return vc
    }
}
