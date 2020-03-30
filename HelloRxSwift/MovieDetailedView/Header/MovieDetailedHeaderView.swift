//
//  MovieDetailedHeaderView.swift
//  HelloRxSwift
//
//  Created by ST_Ben.Huang 黃韋韜 on 2020/3/30.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import UIKit

class MovieDetailedHeaderView: UITableViewHeaderFooterView {
    
    static let identifier = String(describing: self)
    
    private lazy var headerName:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AmericanTypewriter-Condensed", size: 17)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        return label
    }()
    
    private lazy var highlightLine:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 2
        view.backgroundColor = .purple
        self.addSubview(view)
        return view
    }()
    

    override func draw(_ rect: CGRect) {
        setupUI()
        setupConstrants()
    }

    func setHeaderName(_ text: String) {
        self.headerName.text = text
    }
    
    private func setupUI() {
        //self.backgroundView!.backgroundColor = .black//UIColor(red: 240/255, green: 243/255, blue:248/255 , alpha: 1)
    }
    
    private func setupConstrants() {
        NSLayoutConstraint.activate([
            highlightLine.widthAnchor.constraint(equalToConstant: 5),
            highlightLine.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            highlightLine.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            highlightLine.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
            headerName.leadingAnchor.constraint(equalTo: highlightLine.trailingAnchor, constant: 8),
            headerName.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor),
            headerName.topAnchor.constraint(equalTo: self.topAnchor),
            headerName.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
}
