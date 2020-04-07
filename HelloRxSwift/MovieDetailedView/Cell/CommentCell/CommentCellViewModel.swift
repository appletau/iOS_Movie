//
//  CommentCellViewModel.swift
//  HelloRxSwift
//
//  Created by tautau on 2020/4/4.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class CommentCellViewModel: ViewModelType, CellViewModel {
    struct Input {
        let comment:BehaviorRelay<Comment?>
        let expandBtnPressed:PublishRelay<Void>
    }
    
    struct Output {
        let comment:Driver<String>
        let publishDate:Driver<String>
        let usefulCount:Driver<String>
        let avatarURL:Driver<URL>
        let isCellExpanded:BehaviorRelay<Bool>
    }
    
    let input:Input
    let output: Output
    let bag = DisposeBag()
    private let movieSubjectRelay = BehaviorRelay<Comment?>(value: nil)
    private let expandBtnPressedRelay = PublishRelay<Void>()
    private let isCellExpandedRelay = BehaviorRelay<Bool>(value: false)
    
    init() {
        let commentDriver = movieSubjectRelay.asDriver().compactMap {$0?.content}
        let publishDateDriver = movieSubjectRelay.asDriver().compactMap {$0?.created_at}
        let usefulCountDriver = movieSubjectRelay.asDriver().map {"\($0?.useful_count ?? 0)有用"}
        let avatarURLDrvier = movieSubjectRelay.asDriver().compactMap {$0?.author.avatar}
        input = Input(comment: movieSubjectRelay, expandBtnPressed: expandBtnPressedRelay)
        output = Output(comment: commentDriver,
                        publishDate: publishDateDriver,
                        usefulCount: usefulCountDriver,
                        avatarURL: avatarURLDrvier,
                        isCellExpanded: isCellExpandedRelay)
        expandBtnPressedRelay.subscribe(onNext: {[weak self] (_) in
            guard let self = self else {return}
            if self.isCellExpandedRelay.value {
                self.isCellExpandedRelay.accept(false)
            } else {
                self.isCellExpandedRelay.accept(true)
            }
            }).disposed(by: bag)
    }
}
