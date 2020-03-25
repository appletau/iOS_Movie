//
//  ViewController.swift
//  test
//
//  Created by ST_Ben.Huang 黃韋韜 on 2020/3/24.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import UIKit
import RxCocoa
import Moya
import RxSwift

class ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    let disposeBag = DisposeBag()
    let numbers: Observable<Int> = Observable.create { (observer) -> Disposable in
        for i in 0...3 {
            observer.onNext(i)
            sleep(1)
        }
        observer.onCompleted()
        return Disposables.create()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIService.shared.request(GitHub.GetUserProfile(name: "yoxisem544"))
        .subscribe(onSuccess: { (p) in
          print(p)
        }, onError: { (e) in
          // 如果要處理 error message 的話可以這樣處理
          if let e = e as? MoyaError, let errorMessage = try? e.response?.mapJSON() {
            print(errorMessage)
          }
        })
        .disposed(by: disposeBag)
        
        /*
        textField.rx.text.bind(to: label.rx.text).disposed(by: disposeBag)
        numbers
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { print($0)})
            .disposed(by: disposeBag)
        numbers
            //.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map {"\($0)"}
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
        */
    }


}

