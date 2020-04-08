//
//  CelebrityCell.swift
//  HelloRxSwift
//
//  Created by ST_Ben.Huang 黃韋韜 on 2020/3/30.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

class CelebrityCell: UITableViewCell,CellConfigurable {
    @IBOutlet private weak var collectionView: UICollectionView!
    
    static let identifier = String(describing: CelebrityCell.self)
    var celebrities:Array<Celebrity> = []
    private var bag = DisposeBag()
    private var cellViewModels:[CelebrityCollectionCellViewModel] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: CelebrityCollectionViewCell.identifier, bundle: nil),
                                forCellWithReuseIdentifier: CelebrityCollectionViewCell.identifier)
    }
    
    func setup(viewModel: CellViewModel) {
        guard let vm = viewModel as? CelebrityCellViewModel else {return}
        vm.output.cellViewModels?.drive(onNext: { [weak self] (collectionCellVMs) in
            self?.cellViewModels  = collectionCellVMs
            self?.collectionView.reloadData()
        }).disposed(by: bag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
}

extension CelebrityCell:UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CelebrityCollectionViewCell.identifier,for: indexPath)
        if let cell = cell as? CelebrityCollectionViewCell {cell.setup(viewModel: cellViewModels[indexPath.row])}
        return cell
    }
    
}

extension CelebrityCell:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 130, height: 200)
    }
}
