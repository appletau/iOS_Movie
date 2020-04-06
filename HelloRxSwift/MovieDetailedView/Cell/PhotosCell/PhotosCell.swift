//
//  PhotosCell.swift
//  HelloRxSwift
//
//  Created by ST_Ben.Huang 黃韋韜 on 2020/3/30.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PhotosCell: UITableViewCell,CellConfigurable {
    @IBOutlet var collectionView: UICollectionView!
    
    static let identifier = String(describing: PhotosCell.self)
    var photos:Array<Photo> = []
    private var bag = DisposeBag()
    private var cellViewModels:[PhotosCollectionCellViewModel] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: PhotosCollectionViewCell.identifier, bundle: nil),
                                forCellWithReuseIdentifier: PhotosCollectionViewCell.identifier)
    }
    
    func setup(viewModel: CellViewModel) {
        guard let vm = viewModel as? PhotoCellViewModel else {return}
        vm.output.cellViewModels?.drive(onNext: { [weak self] (collectionCellVMs) in
            self?.cellViewModels  = collectionCellVMs
            self?.collectionView.reloadData()
        } ).disposed(by: bag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
}

extension PhotosCell:UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionViewCell.identifier,for: indexPath)
        if let cell = cell as? PhotosCollectionViewCell {cell.setup(viewModel: cellViewModels[indexPath.row])}
        return cell
    }
    
}

extension PhotosCell:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }
}
