//
//  SummaryCell.swift
//  HelloRxSwift
//
//  Created by ST_Ben.Huang 黃韋韜 on 2020/3/30.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SummaryCell: UITableViewCell,CellConfigurable,ExpandContent {
    
    static let identifier = String(describing: SummaryCell.self)
    var bag = DisposeBag()
    
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var expandBtn: UIButton!
    
    func setup(model: Codable) {
        guard let model = model as? Subject else {return}
        
        summaryLabel.text = model.summary
    }
    
    func switchLinesOfContentLabel(isExpand:Bool) {
        if isExpand {
            summaryLabel.numberOfLines = 0
            expandBtn.setTitle("收縮", for: .normal)
        } else {
            summaryLabel.numberOfLines = 3
            expandBtn.setTitle("展開", for: .normal)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
}
