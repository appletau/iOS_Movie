//
//  ExtenObservableType.swift
//  HelloRxSwift
//
//  Created by ST_Ben.Huang 黃韋韜 on 2020/3/26.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


extension ObservableType {
    
    //https://github.com/ReactiveX/RxSwift/issues/1164#issuecomment-290561416
    func currentAndPrevious() -> Observable<(current: Element, previous: Element?)> {
        return self.multicast({ () -> PublishSubject<Element> in PublishSubject<Element>() }) { (values: Observable<Element>) -> Observable<(current: Element, previous: Element?)> in
            let pastValues = values.asObservable().map { previous -> Element? in previous }.startWith(nil)
            return Observable.zip(values.asObservable(), pastValues) { (current, previous) in
                return (current: current, previous: previous)
            }
        }
    }
}
