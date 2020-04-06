//
//  PhotosCollectionCellViewModel.swift
//  HelloRxSwift
//
//  Created by ST_Ben.Huang 黃韋韜 on 2020/4/6.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PhotosCollectionCellViewModel: ViewModelType {
    
    struct Input {
        let photo:BehaviorRelay<Photo?>
    }
    
    struct Output {
        let photoURL:Driver<URL>
    }
    
    let input:Input
    let output: Output
    let bag = DisposeBag()
    private let photoRelay = BehaviorRelay<Photo?>(value:nil)
    
    init() {
        let photoURLDriver = photoRelay.asDriver().compactMap {$0?.image}
        input = Input(photo: photoRelay)
        output = Output(photoURL: photoURLDriver)
    }
}

