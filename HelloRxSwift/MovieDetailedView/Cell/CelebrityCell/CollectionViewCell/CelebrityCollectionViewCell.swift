//
//  CelebrityCollectionViewCell.swift
//  HelloRxSwift
//
//  Created by tautau on 2020/3/31.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import UIKit

class CelebrityCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var photoImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    
    static let identifier = String(describing: CelebrityCollectionViewCell.self)
    
    func setup(viewModel:CelebrityCollectionCellViewModel) {
        viewModel.output.name.drive(nameLabel.rx.text).disposed(by: viewModel.bag)
        viewModel.output.avatarURL.drive(onNext: { (url) in
            self.photoImageView.kf.setImage(with: url)
        }).disposed(by: viewModel.bag)
    }
    
    func showSkeleton() {
        [photoImageView,nameLabel].forEach {$0?.showSkeleton()}
    }
    
    func hideSkeleton() {
        [photoImageView,nameLabel].forEach {$0?.hideSkeleton()}
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = UIImage(systemName: "person.3.fill")
        nameLabel.text = "NaN"
    }
}
