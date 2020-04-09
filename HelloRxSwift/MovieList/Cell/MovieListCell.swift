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
    @IBOutlet private weak var movieImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var publishDateLabel: UILabel!
    @IBOutlet private weak var movieDurationLabel: UILabel!
    @IBOutlet private weak var cornerView: UIView!
    @IBOutlet private weak var shadowView: UIView!
    
    static let identifier = String(describing: MovieListCell.self)
    private var bag = DisposeBag()
    
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
    
    func showSkeleton() {
        self.isUserInteractionEnabled = false
        [movieImageView,titleLabel,categoryLabel,publishDateLabel,movieDurationLabel].forEach {$0?.showSkeleton()}
    }
    
    func hideSkeleton() {
        self.isUserInteractionEnabled = true
        [movieImageView,titleLabel,categoryLabel,publishDateLabel,movieDurationLabel].forEach {$0?.hideSkeleton()}
    }
}
