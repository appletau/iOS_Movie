//
//  PhotosCell.swift
//  HelloRxSwift
//
//  Created by ST_Ben.Huang 黃韋韜 on 2020/3/30.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import UIKit

class PhotosCell: UITableViewCell,CellConfigurable {
    
    static let identifier = String(describing: PhotosCell.self)
    
    @IBOutlet var collectionView: UICollectionView!
    
    var photos:Array<Photo> = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: PhotosCollectionViewCell.identifier, bundle: nil),
                                forCellWithReuseIdentifier: PhotosCollectionViewCell.identifier)
    }


    func setup(model: Codable) {
        guard let model = model as? Subject else {return}
        photos = model.photos
        collectionView.reloadData()
    }
}

extension PhotosCell:UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionViewCell.identifier,for: indexPath)
        if let cell = cell as? PhotosCollectionViewCell {cell.setup(photo:photos[indexPath.row])}
        return cell
    }
    
}

extension PhotosCell:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }
}
