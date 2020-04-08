//
//  PhotosCollectionViewCell.swift
//  HelloRxSwift
//
//  Created by tautau on 2020/3/31.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import UIKit
import RxSwift

class PhotosCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var photoImageView: UIImageView!
    
    static let identifier = String(describing: PhotosCollectionViewCell.self)
    
    func setup(photo:Photo) {
        photoImageView.kf.setImage(with: photo.image)
    }
    
    func setup(viewModel:PhotosCollectionCellViewModel) {
        viewModel.output.photoURL.drive(onNext: { (url) in
            self.photoImageView.kf.setImage(with: url)
        }).disposed(by: viewModel.bag)
    }

}
