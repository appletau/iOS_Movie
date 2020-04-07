//
//  RefreshData.swift
//  LiveSports
//
//  Created by Daniel on 2020/3/10.
//  Copyright © 2020 ST_Ray.Lin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol Refreshable: class {
    func refreshData()
    var endRefresh: PublishSubject<Void> { get }
}

class RxRefreshControl: UIRefreshControl {
    private weak var refreshable: Refreshable?
    private let disposeBag = DisposeBag()
    
    private override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init coder has not been implemented")
    }
    
    convenience init(_ refreshable: Refreshable) {
        self.init()
        self.refreshable = refreshable
        self.binding()
    }
    
    private func binding() {
        rx.controlEvent(.valueChanged)
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.refreshable?.refreshData()
            })
            .disposed(by: disposeBag)
        
        refreshable?.endRefresh
            .subscribe(onNext: { [weak self] (_) in
                self?.endRefreshing()
            })
            .disposed(by: self.disposeBag)
    }
}
