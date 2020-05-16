//
//  MovieDetailedViewController.swift
//  HelloRxSwift
//
//  Created by ST_Ben.Huang 黃韋韜 on 2020/3/30.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya
import SkeletonView

class MovieDetailedViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private weak var loadingIndicatorView: LoadingIndicatorView!
    @IBOutlet private weak var technicalProblemView: TechnicalProblemView!
    
    private var viewModel: MovieDetailedViewModel!
    private let bag = DisposeBag()
    
    lazy var refreshControl: RxRefreshControl = {
        return RxRefreshControl(viewModel)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registCell()
        initBinding()
    }
}

extension MovieDetailedViewController:SkeletonTableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.output.sections.value[section].cellViewModels.count
        return count > 0 ? count : 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.output.sections.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: getCellIdentifier(for: indexPath.section), for: indexPath)
        if let cell = cell as? CellConfigurable {
            let cellVMs = viewModel.output.sections.value[indexPath.section].cellViewModels
            guard cellVMs.count > 0 else {
                cell.showSkeleton()
                return cell as! UITableViewCell
            }
            cell.hideSkeleton()
            cell.setup(viewModel: cellVMs[indexPath.row])
        }
        return setupCellBinding(cell, indexPath: indexPath)
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
       return getCellIdentifier(for: indexPath.section)
    }
}

extension MovieDetailedViewController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { return CGFloat.leastNormalMagnitude }
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {return nil}
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier:  MovieDetailedHeaderView.identifier)as! MovieDetailedHeaderView
        header.setHeaderName(viewModel.output.sections.value[section].headerName)
        return header
    }
}

extension MovieDetailedViewController {
    
    func setMovieID(_ id:String) {
        self.viewModel = MovieDetailedViewModel(withID: id)
    }
    
    private func setupUI() {
        tableView.refreshControl = refreshControl
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_arrow"),
                                                           style: .done,
                                                           target: self,
                                                           action: nil)
        navigationItem.leftBarButtonItem?.tintColor = .white
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    private func registCell() {
        tableView.register(MovieDetailedHeaderView.self,
                           forHeaderFooterViewReuseIdentifier: MovieDetailedHeaderView.identifier)
        tableView.register(UINib(nibName: MainInfoCell.identifier, bundle: nil),
                           forCellReuseIdentifier: MainInfoCell.identifier)
        tableView.register(UINib(nibName: RatingCell.identifier, bundle: nil),
                           forCellReuseIdentifier: RatingCell.identifier)
        tableView.register(UINib(nibName: SummaryCell.identifier, bundle: nil),
                           forCellReuseIdentifier: SummaryCell.identifier)
        tableView.register(UINib(nibName: CelebrityCell.identifier, bundle: nil),
                           forCellReuseIdentifier: CelebrityCell.identifier)
        tableView.register(UINib(nibName: PhotosCell.identifier, bundle: nil),
                           forCellReuseIdentifier: PhotosCell.identifier)
        tableView.register(UINib(nibName: CommentCell.identifier, bundle: nil),
                           forCellReuseIdentifier: CommentCell.identifier)
    }
    
    private func initBinding() {
        viewModel.output.sections.subscribe(onNext: { [weak self] (sections) in
            self?.tableView.reloadData()
        }).disposed(by: bag)
        
        viewModel.output.movieTitle.bind(to: self.rx.title).disposed(by: bag)
        
        viewModel.output.errorOccurred.map {!$0}.drive(technicalProblemView.rx.isHidden).disposed(by: bag)
        
        navigationItem.leftBarButtonItem?.rx.tap.subscribe(onNext: {[weak self] (_) in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: bag)
    }
    
    private func getCellIdentifier(for sectionIndex:Int) -> String {
        switch MovieDetailedCellContent(rawValue:sectionIndex) {
        case .mainInfo:
            return MainInfoCell.identifier
        case .rating:
            return RatingCell.identifier
        case .summary:
            return SummaryCell.identifier
        case .celebrity:
            return CelebrityCell.identifier
        case .photos:
            return PhotosCell.identifier
        case .popularComment:
            return CommentCell.identifier
        case .none:
            fatalError("Out Of Case")
        }
    }
    
    private func setupCellBinding(_ cell:UITableViewCell, indexPath:IndexPath) -> UITableViewCell {
        guard let c = cell as? CellExpandable else {return cell}
        c.expandBtn.rx.tap.subscribe { [weak self] _ in
            self?.tableView.reloadRows(at: [indexPath], with: .fade)
        }.disposed(by: c.bag)
        return c
    }
    
}
