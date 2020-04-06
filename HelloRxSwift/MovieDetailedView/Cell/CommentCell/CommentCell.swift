//
//  CommentCell.swift
//  HelloRxSwift
//
//  Created by ST_Ben.Huang 黃韋韜 on 2020/4/1.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher

class CommentCell: UITableViewCell,CellConfigurable,ExpandContent {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var usefulCountLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var expandBtn: UIButton!
    
    static let identifier = String(describing: CommentCell.self)
    var bag = DisposeBag()
    
    func setup(viewModel: CellViewModel) {
        guard let vm = viewModel as? CommentCellViewModel else {return}
        vm.output.comment.drive(commentLabel.rx.text).disposed(by: bag)
        vm.output.publishDate.drive(dateLabel.rx.text).disposed(by: bag)
        vm.output.usefulCount.drive(usefulCountLabel.rx.text).disposed(by: bag)
        expandBtn.rx.tap.bind(to: vm.input.expandBtnPressed).disposed(by: bag)
        vm.output.avatarURL.drive(onNext: { [weak self] (url) in
            
            self?.photoImageView.kf.setImage(with: url)
        }).disposed(by: bag)
        vm.output.isCellExpanded.subscribe(onNext: { [weak self] (isExpended) in
            self?.switchLinesOfContentLabel( isExpended)
        }).disposed(by: bag)
    }
    
    func switchLinesOfContentLabel(_ isExpanded:Bool) {
        if isExpanded {
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
