//
//  CelebrityCollectionViewCell.swift
//  HelloRxSwift
//
//  Created by tautau on 2020/3/31.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import UIKit

class CelebrityCollectionViewCell: UICollectionViewCell {
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    static let identifier = String(describing: CelebrityCollectionViewCell.self)
    
    func setup(celebrity:Celebrity) {
        self.nameLabel.text = celebrity.name
        self.photoImageView.kf.setImage(with: celebrity.avatars?["small"])
    }
    
    func setup(viewModel:CelebrityCollectionCellViewModel) {
        viewModel.output.name.drive(nameLabel.rx.text).disposed(by: viewModel.bag)
        viewModel.output.avatarURL.drive(onNext: { (url) in
            self.photoImageView.kf.setImage(with: url)
        }).disposed(by: viewModel.bag)
    }

}
