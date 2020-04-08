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

class SummaryCell: UITableViewCell,CellConfigurable,CellExpandable {
    @IBOutlet private weak var summaryLabel: UILabel!
    @IBOutlet weak var expandBtn: UIButton!
    
    static let identifier = String(describing: SummaryCell.self)
    var maxNumberOfLine = 3
    var bag = DisposeBag()
    
    func setup(viewModel: CellViewModel) {
        guard let vm = viewModel as? SummaryCellViewModel else {return}
        vm.output.summary.drive(summaryLabel.rx.text).disposed(by: bag)
        expandBtn.rx.tap.bind(to: vm.input.expandBtnPressed).disposed(by: bag)
        vm.output.isCellExpanded.subscribe(onNext: { [weak self] (isExpended) in
            self?.switchLinesOfContentLabel(isExpended)
        }).disposed(by: bag)
        summaryLabel.rx.observe(Bool.self, "text").subscribe(onNext: {[weak self] (v) in
            guard let self = self else {return}
            self.expandBtn.isHidden = !self.summaryLabel.isLabelTruncated(maxNumberOfLine: self.maxNumberOfLine)
        }).disposed(by: bag)
    }
    
    func switchLinesOfContentLabel(_ isExpanded:Bool) {
        if isExpanded {
            summaryLabel.numberOfLines = 0
            expandBtn.setTitle("收縮", for: .normal)
        } else {
            summaryLabel.numberOfLines = maxNumberOfLine
            expandBtn.setTitle("展開", for: .normal)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
}
