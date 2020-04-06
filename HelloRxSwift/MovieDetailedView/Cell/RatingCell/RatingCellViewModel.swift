//
//  RatingCellViewModel.swift
//  HelloRxSwift
//
//  Created by tautau on 2020/4/4.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class RatingCellViewModel: ViewModelType,CellViewModel {
    struct Input {
        let movieSubject:BehaviorRelay<NormalSubject?>
    }
    
    struct Output {
        let ratingAverage:Driver<Float>
    }
    
    let input:Input
    let output: Output
    let bag = DisposeBag()
    private let movieSubjectRelay = BehaviorRelay<NormalSubject?>(value: nil)
    
    init() {
        let ratingAverageDriver = movieSubjectRelay.asDriver().compactMap {$0?.rating?.average}
        input = Input(movieSubject: movieSubjectRelay)
        output = Output(ratingAverage: ratingAverageDriver)
    }
}
