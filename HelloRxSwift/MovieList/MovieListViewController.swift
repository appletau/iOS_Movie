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
    
    private let viewModel = MovieListViewModel()
    private let bag = DisposeBag()
    let tabData:Observable<[ScrollableTabViewData]> = Observable.just(MovieListType.allCases.map {ScrollableTabData(title: $0.rawValue)})
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registerCell()
        binding()
    }
}

extension MovieListViewController {
    
    private func setupUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
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
            self?.performSegue(withIdentifier: String(describing: MovieDetailedViewController.self) , sender: self)
            }).disposed(by: bag)
        
        viewModel.output.movieListCellVMsRelay.bind(to: tableView.rx.items(cellIdentifier: String(describing: MovieListCell.self), cellType: MovieListCell.self)) { (row, element, cell) in
            cell.setup(viewModel: element)
        }.disposed(by: bag)
        
        viewModel.output.loadingMovieListIsFinished.subscribe(onNext: { (isLoaded) in
            if isLoaded {self.tableView.scrollToTop()}
        }).disposed(by: bag)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? MovieDetailedViewController, let row = tableView.indexPathForSelectedRow?.row else {return}
        viewModel.output.movieListCellVMsRelay.compactMap {$0[row].input.movieSubject.value?.id}.bind(to: vc.viewModel.input.subjectID).disposed(by: bag)
    }
}
