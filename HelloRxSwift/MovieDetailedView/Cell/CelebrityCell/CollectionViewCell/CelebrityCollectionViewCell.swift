//
//  CelebrityCollectionViewCell.swift
//  HelloRxSwift
//
//  Created by tautau on 2020/3/31.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import UIKit

class CelebrityCollectionViewCell: UICollectionViewCell {

    static let identifier = String(describing: CelebrityCollectionViewCell.self)
    
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    func setup(celebrity:Celebrity) {
        self.nameLabel.text = celebrity.name
        self.photoImageView.kf.setImage(with: celebrity.avatars?["small"])
    }

}
