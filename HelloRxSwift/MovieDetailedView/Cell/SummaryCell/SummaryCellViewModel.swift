//
//  SummaryCellViewModel.swift
//  HelloRxSwift
//
//  Created by tautau on 2020/4/4.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class SummaryCellViewModel: ViewModelType,CellViewModel {
    struct Input {
        let movieSubject:BehaviorRelay<NormalSubject?>
        let expandBtnPressed:PublishRelay<Void>
    }
    
    struct Output {
        let summary:Driver<String>
        let isCellExpanded:BehaviorRelay<Bool>
    }
    
    let input:Input
    let output: Output
    let bag = DisposeBag()
    private let movieSubjectRelay = BehaviorRelay<NormalSubject?>(value: nil)
    private let expandBtnPressedRelay = PublishRelay<Void>()
    private let isCellExpandedRelay = BehaviorRelay<Bool>(value: false)
    
    init() {
        let summaryDriver = movieSubjectRelay.asDriver().compactMap {$0?.summary}
        input = Input(movieSubject: movieSubjectRelay, expandBtnPressed: expandBtnPressedRelay)
        output = Output(summary: summaryDriver, isCellExpanded: isCellExpandedRelay)
        
        expandBtnPressedRelay.subscribe { [weak self] (_) in
            guard let self = self else {return}
            if self.isCellExpandedRelay.value {
                self.isCellExpandedRelay.accept(false)
            } else {
                self.isCellExpandedRelay.accept(true)
            }
        }.disposed(by: bag)
    }
}
