//
//  CelebrityCellViewModel.swift
//  HelloRxSwift
//
//  Created by tautau on 2020/4/4.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class CelebrityCellViewModel: ViewModelType,CellViewModel {
    
    struct Input {
        let movieSubject:BehaviorRelay<NormalSubject?>
    }
    
    struct Output {
        var cellViewModels:Driver<[CelebrityCollectionCellViewModel]>?
    }
    
    let input:Input
    var output: Output
    let bag = DisposeBag()
    private let movieSubjectRelay = BehaviorRelay<NormalSubject?>(value: nil)
    private var cellViewModelsDriver:Driver<[CelebrityCollectionCellViewModel]>?
    
    init() {
        input = Input(movieSubject: movieSubjectRelay)
        output = Output()
        output.cellViewModels = movieSubjectRelay.asDriver().compactMap {$0}.map {$0.directors + $0.casts}.map { [weak self] (celebrities) -> [CelebrityCollectionCellViewModel] in
            guard let self = self else {return []}
            return self.convertToCellVMS(withCelebrities: celebrities)
        }

    }
    
    private func convertToCellVMS(withCelebrities celebrities:[Celebrity]) -> [CelebrityCollectionCellViewModel]{
        return celebrities.map { (celebrity) -> CelebrityCollectionCellViewModel in
            let vm = CelebrityCollectionCellViewModel()
            Observable.just(celebrity).bind(to: vm.input.celebrity).disposed(by: bag)
            return vm
        }
    }
}
