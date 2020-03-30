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

class MovieDetailedViewController: UITableViewController {
    let a = ["a","b","c"]
    override func viewDidLoad() {
        super.viewDidLoad()
        registCell()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier:  MovieDetailedHeaderView.identifier)as! MovieDetailedHeaderView
        header.setHeaderName("Hi")
        return header
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return a.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = a[indexPath.row]
        return cell
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
        tableView.register(UINib(nibName: PopularReviewCell.identifier, bundle: nil),
                           forCellReuseIdentifier: PopularReviewCell.identifier)
    }
}
