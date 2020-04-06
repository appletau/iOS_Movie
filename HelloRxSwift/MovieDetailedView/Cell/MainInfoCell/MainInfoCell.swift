//
//  MainInfoCell.swift
//  HelloRxSwift
//
//  Created by ST_Ben.Huang 黃韋韜 on 2020/3/30.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

class MainInfoCell: UITableViewCell,CellConfigurable {
    @IBOutlet private weak var directorsLabel: UILabel!
    @IBOutlet private weak var castsLabel: UILabel!
    @IBOutlet private weak var CategoryLabel: UILabel!
    @IBOutlet private weak var publishDateLabel: UILabel!
    @IBOutlet private weak var contriesLabel: UILabel!
    @IBOutlet private weak var movieImageView: UIImageView!
    
    static let identifier = String(describing: MainInfoCell.self)
    private var bag = DisposeBag()
    
    func setup(viewModel: CellViewModel) {
        guard let vm = viewModel as? MainInfoCellViewModel else {return}
        vm.output.directorNames.drive(directorsLabel.rx.text).disposed(by: bag)
        vm.output.castNames.drive(castsLabel.rx.text).disposed(by: bag)
        vm.output.category.drive(CategoryLabel.rx.text).disposed(by: bag)
        vm.output.publishDate.drive(publishDateLabel.rx.text).disposed(by: bag)
        vm.output.countries.drive(contriesLabel.rx.text).disposed(by: bag)
        vm.output.imageURL.drive(onNext: { [weak self] (url) in
            self?.movieImageView.kf.setImage(with: url)
        }).disposed(by: bag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
        self.castsLabel.text! = ""
        self.directorsLabel.text! = ""
        self.CategoryLabel.text! = ""
        self.publishDateLabel.text! = ""
        self.contriesLabel.text! = ""
    }
}
