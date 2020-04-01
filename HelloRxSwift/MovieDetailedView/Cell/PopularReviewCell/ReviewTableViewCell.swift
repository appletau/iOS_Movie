//
//  ReviewTableViewCell.swift
//  HelloRxSwift
//
//  Created by ST_Ben.Huang 黃韋韜 on 2020/4/1.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher

class ReviewTableViewCell: UITableViewCell,CellConfigurable,ExpandContent {

    static let identifier = String(describing: ReviewTableViewCell.self)
    var bag = DisposeBag()
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var usefulCountLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var expandBtn: UIButton!

    func setup(model: Codable) {
        guard let model = model as? Comment else {return}
        photoImageView.kf.setImage(with: model.author.avatar)
        nameLabel.text = model.author.name
        dateLabel.text = model.created_at
        usefulCountLabel.text = "\(model.useful_count)有用"
        commentLabel.text = model.content
    }
    
    func switchLinesOfContentLabel(isExpand:Bool) {
        if isExpand {
            commentLabel.numberOfLines = 0
            expandBtn.setTitle("收縮", for: .normal)
        } else {
            commentLabel.numberOfLines = 3
            expandBtn.setTitle("展開", for: .normal)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
}
