//
//  RatingCell.swift
//  HelloRxSwift
//
//  Created by ST_Ben.Huang 黃韋韜 on 2020/3/30.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RatingCell: UITableViewCell,CellConfigurable {
    @IBOutlet weak var ratingStarView: CosmosView!
    
    static let identifier = String(describing: RatingCell.self)
    private var bag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ratingStarView.settings.updateOnTouch = false
        ratingStarView.settings.starSize = 50
        ratingStarView.settings.starMargin = 10
        ratingStarView.settings.filledColor = .red
    }
    
    func setup(viewModel: CellViewModel) {
        guard let vm = viewModel as? RatingCellViewModel else {return}
        vm.output.ratingAverage.drive(onNext: { [weak self] (value) in
            self?.ratingStarView.rating = Double(value/2)
        }).disposed(by: bag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }

}
