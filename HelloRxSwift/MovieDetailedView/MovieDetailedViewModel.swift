//
//  MovieDetailedViewModel.swift
//  HelloRxSwift
//
//  Created by ST_Ben.Huang 黃韋韜 on 2020/3/30.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import RxDataSources

enum MovieDetailedCellContent:Int ,CaseIterable {
    case main_info
    case rating
    case summary
    case celebrity
    case photos
    case popular_review
}

class MovieDetailedViewModel:ViewModelType {
    
    struct Input {
        let summaryCellExpandBtnPressed:AnyObserver<Void>
        let subjectID:AnyObserver<String>
    }
    
    struct Output {
        let isSummaryCellExpand:BehaviorRelay<Bool>
        let subjectResultRelay:BehaviorRelay<Subject?>
    }
    
    let input: Input
    let output: Output
    
    private let cellBtnPressedSub = PublishSubject<Void>()
    private let idSub = PublishSubject<String>()
    private let isCellExpandRelay = BehaviorRelay<Bool>(value: false)
    private let subjectResultRelay = BehaviorRelay<Subject?>(value: nil)
    private let bag = DisposeBag()
    
    var test:((Bool) ->Void) = { (Bool) -> Void in}
    
    init() {
        self.input = Input(summaryCellExpandBtnPressed: cellBtnPressedSub.asObserver(), subjectID: idSub.asObserver())
        self.output = Output(isSummaryCellExpand: isCellExpandRelay, subjectResultRelay: subjectResultRelay)
        
        idSub.subscribe(onNext: { (id) in
            self.searchMovie(id: id)
            }).disposed(by: bag)
        
        cellBtnPressedSub.subscribe { [weak self] (_) in
            guard let self = self else {return}
            if self.isCellExpandRelay.value {
                self.isCellExpandRelay.accept(false)
                self.test(false)
            } else {
                self.isCellExpandRelay.accept(true)
                self.test(true)
            }
        }.disposed(by: bag)
    }
    
    private func searchMovie(id:String) {
        APIService.shared.request(Movie.GetMovie(id: id, parameters: ["apikey":apiKey]))
            .subscribe(onSuccess: {[weak self] (model) in
                self?.subjectResultRelay.accept(model)
                }, onError: { (e) in
                    if let e = e as? MoyaError, let errorMessage = try? e.response?.mapJSON() {
                        print(errorMessage)
                    }
            })
            .disposed(by: bag)
    }
}
