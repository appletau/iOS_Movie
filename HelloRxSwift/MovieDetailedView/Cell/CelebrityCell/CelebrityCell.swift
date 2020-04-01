//
//  CelebrityCell.swift
//  HelloRxSwift
//
//  Created by ST_Ben.Huang 黃韋韜 on 2020/3/30.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import UIKit
import Kingfisher

class CelebrityCell: UITableViewCell,CellConfigurable {
    static let identifier = String(describing: CelebrityCell.self)
    
    var celebrities:Array<Celebrity> = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: CelebrityCollectionViewCell.identifier, bundle: nil),
                                forCellWithReuseIdentifier: CelebrityCollectionViewCell.identifier)
    }
   
    func setup(model: Codable) {
        guard let model = model as? Subject else {return}
        celebrities = model.directors + model.casts
        collectionView.reloadData()
    }
}

extension CelebrityCell:UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return celebrities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CelebrityCollectionViewCell.identifier,for: indexPath)
        if let cell = cell as? CelebrityCollectionViewCell {cell.setup(celebrity: celebrities[indexPath.row])}
        return cell
    }
    
}

extension CelebrityCell:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 130, height: 200)
    }
}
