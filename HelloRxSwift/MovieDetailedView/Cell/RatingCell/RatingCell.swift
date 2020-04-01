//
//  RatingCell.swift
//  HelloRxSwift
//
//  Created by ST_Ben.Huang 黃韋韜 on 2020/3/30.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import UIKit

class RatingCell: UITableViewCell,CellConfigurable {
    static let identifier = String(describing: RatingCell.self)
    
    @IBOutlet weak var ratingStarView: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ratingStarView.settings.updateOnTouch = false
        ratingStarView.settings.starSize = 50
        ratingStarView.settings.starMargin = 10
    }
    
    func setup(model: Codable) {
        guard let model = model as? Subject else {return}
        guard let rating = model.rating else {fatalError("No Rating Value")}
        ratingStarView.rating = Double(rating.average/2)
    }

}
