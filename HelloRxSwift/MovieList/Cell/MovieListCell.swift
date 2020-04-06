//
//  MovieListCell.swift
//  HelloRxSwift
//
//  Created by ST_Ben.Huang 黃韋韜 on 2020/3/26.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

class MovieListCell: UITableViewCell {
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var publishDateLabel: UILabel!
    @IBOutlet weak var movieDurationLabel: UILabel!
    @IBOutlet weak var cornerView: UIView!
    @IBOutlet weak var shadowView: UIView!
    
    private var bag = DisposeBag()
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.3
        shadowView.layer.shadowRadius = 10
        shadowView.layer.shadowOffset = .zero
        shadowView.backgroundColor = .none
        cornerView.layer.cornerRadius = 15
        cornerView.clipsToBounds = true
        }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
        self.titleLabel.text = ""
        self.categoryLabel.text? = ""
        self.publishDateLabel.text? = ""
        self.movieDurationLabel.text? = ""
    }
    
    func setup(viewModel:MovieListCellViewModel) {
        viewModel.output.title.drive(self.titleLabel.rx.text).disposed(by: bag)
        viewModel.output.category.drive(self.categoryLabel.rx.text).disposed(by: bag)
        viewModel.output.publishDate.drive(self.publishDateLabel.rx.text).disposed(by: bag)
        viewModel.output.duration.drive(self.movieDurationLabel.rx.text).disposed(by: bag)
        viewModel.output.imageURL.drive(onNext: { [weak self] (url) in
            self?.movieImageView.kf.setImage(with: url)
            }).disposed(by: bag)
    }
    
}
