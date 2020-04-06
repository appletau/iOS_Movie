//
//  MovieListCellViewModel.swift
//  HelloRxSwift
//
//  Created by tautau on 2020/4/2.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MovieListCellViewModel: ViewModelType {

    struct Input {
        let movieSubject:BehaviorRelay<NormalSubject?>
    }
    
    struct Output {
        let title:Driver<String>
        let category:Driver<String>
        let publishDate:Driver<String>
        let duration:Driver<String>
        let imageURL:Driver<URL>
    }
    
    let input: Input
    let output: Output
    let bag = DisposeBag()
    private let movieSubjectRelay = BehaviorRelay<NormalSubject?>(value: nil)
    
    init() {
        let titleDriver = movieSubjectRelay.asDriver().compactMap{$0?.title}
        let categoryDriver = movieSubjectRelay.asDriver().map {"類型：" + ($0?.genres.joined(separator: "/") ?? "") }
        let dateDriver = movieSubjectRelay.asDriver().map{String("上映日期：" + ($0?.pubdates.first?.prefix(10) ?? "")) }
        let durationDriver = movieSubjectRelay.asDriver().map{"片長：" + ($0?.durations.first ?? "") }
        let imageURLDriver = movieSubjectRelay.asDriver().compactMap{ $0?.images["small"] ?? URL(fileURLWithPath: "") }
        
        input = Input(movieSubject: movieSubjectRelay)
        output = Output(title: titleDriver,
                        category: categoryDriver,
                        publishDate: dateDriver,
                        duration: durationDriver,
                        imageURL: imageURLDriver)
    }
}
