//
//  MainInfoCellViewModel.swift
//  HelloRxSwift
//
//  Created by tautau on 2020/4/4.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class MainInfoCellViewModel: ViewModelType,CellViewModel {
    struct Input {
        let movieSubject:BehaviorRelay<NormalSubject?>
    }
    
    struct Output {
        let castNames:Driver<String>
        let directorNames:Driver<String>
        let publishDate:Driver<String>
        let category:Driver<String>
        let countries:Driver<String>
        let imageURL:Driver<URL>
    }
    
    let input:Input
    let output: Output
    let bag = DisposeBag()
    private let movieSubjectRelay = BehaviorRelay<NormalSubject?>(value: nil)
    
    init() {
        let castNamesDriver = movieSubjectRelay.asDriver().map { "演員：" + ($0?.casts.compactMap {$0.name}.joined(separator: "/") ?? "") }
        let directorNamesDriver = movieSubjectRelay.asDriver().map { "導演：" + ($0?.directors.compactMap {$0.name}.joined(separator: "/") ?? "") }
        let dateDriver = movieSubjectRelay.asDriver().map{String( "上映日期：" + ($0?.pubdates.first?.prefix(10) ?? "")) }
        let categoryDriver = movieSubjectRelay.asDriver().map { "類型：" + ($0?.genres.joined(separator: "/") ?? "") }
        let countriesDrivaer = movieSubjectRelay.asDriver().map {"製片國家/地區：" + ($0?.countries.joined(separator: "/") ?? "")}
        let imageURLDriver = movieSubjectRelay.asDriver().compactMap{ $0?.images["small"] ?? URL(fileURLWithPath: "") }
        
        input = Input(movieSubject: movieSubjectRelay)
        output = Output(castNames: castNamesDriver,
                        directorNames: directorNamesDriver,
                        publishDate: dateDriver,
                        category: categoryDriver,
                        countries: countriesDrivaer,
                        imageURL: imageURLDriver)
    }
}

