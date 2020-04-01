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
import RxDataSources

class MovieDetailedViewController: UITableViewController {
    private let viewModel = MovieDetailedViewModel()
    private let bag = DisposeBag()
    var expandedIndexSet : IndexSet = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registCell()
        let test:Observable<String> = Observable.create { (observer) -> Disposable in
            observer.onNext("1292052")
            observer.onCompleted()
            return Disposables.create()
        }
        test.bind(to: viewModel.input.subjectID).disposed(by: bag)
        viewModel.output.subjectResultRelay.subscribe(onNext: { [weak self] (subject) in
            guard let _ = subject else {return}
            self?.tableView.reloadData()
        }).disposed(by: bag)

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch MovieDetailedCellContent(rawValue:section) {
        case .popular_review:
            guard let model = viewModel.output.subjectResultRelay.value  else {return 1}
            return model.popular_comments.count
        default:
            return 1
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return MovieDetailedCellContent.allCases.count
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { return CGFloat.leastNormalMagnitude }
        return 30
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
         return getHeaderView(for: section)
     }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: getCellIdentifier(for: indexPath.section), for: indexPath)
        guard let model = viewModel.output.subjectResultRelay.value  else {return cell}
        if let cell = cell as? CellConfigurable {
            switch MovieDetailedCellContent(rawValue:indexPath.section) {
            case .popular_review:
                cell.setup(model: model.popular_comments[indexPath.row])
            default:
                cell.setup(model: model)
            }
        }
        return setupCellBinding(cell, indexPath: indexPath)
    }
}

extension MovieDetailedViewController {
    
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
        tableView.register(UINib(nibName: ReviewTableViewCell.identifier, bundle: nil),
                           forCellReuseIdentifier: ReviewTableViewCell.identifier)
    }
    
    private func getHeaderView(for sectionIndex:Int) ->UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier:  MovieDetailedHeaderView.identifier)as! MovieDetailedHeaderView
        switch MovieDetailedCellContent(rawValue:sectionIndex) {
          case .main_info:
              return nil
          case .rating:
            let rating = viewModel.output.subjectResultRelay.value?.rating?.average
            header.setHeaderName("評分：\(rating ?? 0)")
          case .summary:
              header.setHeaderName("劇情簡介：")
          case .celebrity:
              header.setHeaderName("演職員：")
          case .photos:
              header.setHeaderName("劇照：")
          case .popular_review:
              header.setHeaderName("熱評：")
          case .none:
              fatalError("Out Of Case")
          }
        return header
    }
    
    private func getCellIdentifier(for sectionIndex:Int) -> String {
        switch MovieDetailedCellContent(rawValue:sectionIndex) {
        case .main_info:
            return MainInfoCell.identifier
        case .rating:
            return RatingCell.identifier
        case .summary:
            return SummaryCell.identifier
        case .celebrity:
            return CelebrityCell.identifier
        case .photos:
            return PhotosCell.identifier
        case .popular_review:
            return ReviewTableViewCell.identifier
        case .none:
            fatalError("Out Of Case")
        }
    }
    
    private func setupCellBinding(_ cell:UITableViewCell, indexPath:IndexPath) -> UITableViewCell {
        guard let c = cell as? ExpandContent else {return cell}
        c.expandBtn.rx.tap.subscribe { [weak self] _ in
            guard let self = self else {return}
            if(self.expandedIndexSet.contains(indexPath.row)){
                self.expandedIndexSet.remove(indexPath.row)
            } else {
                self.expandedIndexSet.insert(indexPath.row)
            }
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }.disposed(by: c.bag)
        c.switchLinesOfContentLabel(isExpand: expandedIndexSet.contains(indexPath.row))
        return c
        
    }

}
