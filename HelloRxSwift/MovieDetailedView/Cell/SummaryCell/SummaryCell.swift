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
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var expandBtn: UIButton!
    
    static let identifier = String(describing: SummaryCell.self)
    var bag = DisposeBag()
    
    func setup(viewModel: CellViewModel) {
        guard let vm = viewModel as? SummaryCellViewModel else {return}
        vm.output.summary.drive(summaryLabel.rx.text).disposed(by: bag)
        expandBtn.rx.tap.bind(to: vm.input.expandBtnPressed).disposed(by: bag)
        vm.output.isCellExpanded.subscribe(onNext: { [weak self] (isExpended) in
            self?.switchLinesOfContentLabel(isExpended)
            }).disposed(by: bag)
    }
    
    func switchLinesOfContentLabel(_ isExpanded:Bool) {
        if isExpanded {
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
