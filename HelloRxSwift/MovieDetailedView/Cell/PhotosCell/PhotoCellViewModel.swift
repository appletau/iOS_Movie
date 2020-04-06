//
//  PhotoCellViewModel.swift
//  HelloRxSwift
//
//  Created by tautau on 2020/4/4.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class PhotoCellViewModel: ViewModelType,CellViewModel {
    struct Input {
        let movieSubject:BehaviorRelay<NormalSubject?>
    }
    
    struct Output {
        var cellViewModels:Driver<[PhotosCollectionCellViewModel]>?
    }
    
    let input:Input
    var output: Output
    let bag = DisposeBag()
    private let movieSubjectRelay = BehaviorRelay<NormalSubject?>(value: nil)
    private var cellViewModelsDriver:Driver<[PhotosCollectionCellViewModel]>?
    
    init() {
        input = Input(movieSubject: movieSubjectRelay)
        output = Output()
        output.cellViewModels = movieSubjectRelay.asDriver().compactMap {$0?.photos}.map { [weak self] (photos) -> [PhotosCollectionCellViewModel] in
            guard let self = self else {return []}
            return self.convertToCellVMS(withPhotos: photos)
        }
    }
    
    private func convertToCellVMS(withPhotos photos:[Photo]) -> [PhotosCollectionCellViewModel]{
        return photos.map { (photo) -> PhotosCollectionCellViewModel in
            let vm = PhotosCollectionCellViewModel()
            Observable.just(photo).bind(to: vm.input.photo).disposed(by: bag)
            return vm
        }
    }
}
