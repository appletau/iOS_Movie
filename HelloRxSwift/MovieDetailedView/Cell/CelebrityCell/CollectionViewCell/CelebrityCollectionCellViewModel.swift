//
//  CelebrityCokkectionCellVoewModel.swift
//  HelloRxSwift
//
//  Created by ST_Ben.Huang 黃韋韜 on 2020/4/6.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CelebrityCollectionCellViewModel: ViewModelType {
    
    struct Input {
        let celebrity:BehaviorRelay<Celebrity?>
    }
    
    struct Output {
        let avatarURL:Driver<URL>
        let name:Driver<String>
    }
    
    let input:Input
    let output: Output
    let bag = DisposeBag()
    private let celebrityRelay = BehaviorRelay<Celebrity?>(value:nil)
    
    init() {
        let avatarURLDriver = celebrityRelay.asDriver().compactMap {$0?.avatars?["small"]}
        let nameDriver = celebrityRelay.asDriver().compactMap {$0?.name}
        input = Input(celebrity: celebrityRelay)
        output = Output(avatarURL: avatarURLDriver, name: nameDriver)
    }
}
