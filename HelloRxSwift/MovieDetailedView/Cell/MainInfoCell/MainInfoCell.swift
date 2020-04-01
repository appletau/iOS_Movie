//
//  MainInfoCell.swift
//  HelloRxSwift
//
//  Created by ST_Ben.Huang 黃韋韜 on 2020/3/30.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import UIKit
import Kingfisher

class MainInfoCell: UITableViewCell,CellConfigurable {
    @IBOutlet private weak var directorsLabel: UILabel!
    @IBOutlet private weak var castsLabel: UILabel!
    @IBOutlet private weak var CategoryLabel: UILabel!
    @IBOutlet private weak var publishDateLabel: UILabel!
    @IBOutlet private weak var contriesLabel: UILabel!
    @IBOutlet private weak var movieImageView: UIImageView!

    static let identifier = String(describing: MainInfoCell.self)
    
    func setup(model: Codable) {
        guard let model = model as? Subject else {return}
        self.movieImageView.kf.setImage(with: model.images["small"])
        self.castsLabel.text! += appendName(model.casts.map {$0.name})
        self.directorsLabel.text! += appendName(model.directors.map {$0.name})
        self.CategoryLabel.text! += appendName(model.genres)
        self.publishDateLabel.text! += String(model.pubdates.first?.prefix(10) ?? "")
        self.contriesLabel.text! += appendName(model.countries)
    }
    
    private func appendName(_ names:[String?]) -> String{
        var text = ""
        for (i,name) in names.enumerated() {
            if i == 0 {
                text += name ?? ""
            } else {
                text += "/\(name ?? "")"
            }
        }
        return text
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.castsLabel.text! = "演員："
        self.directorsLabel.text! = "導演："
        self.CategoryLabel.text! = "類型："
        self.publishDateLabel.text! = "上映日期："
        self.contriesLabel.text! = "製片國家/地區："
    }
}
