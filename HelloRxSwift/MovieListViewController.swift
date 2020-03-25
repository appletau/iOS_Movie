//
//  MovieListViewController.swift
//  HelloRxSwift
//
//  Created by ST_Ben.Huang 黃韋韜 on 2020/3/25.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import UIKit
import RxSwift
import Moya

class MovieListViewController: UIViewController {
    let bag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIService.shared.request(Movie.GetMovieList(type: TopMovie.self, parameters: ["apikey":apiKey]))
          .subscribe(onSuccess: { (p) in
            print(p)
          }, onError: { (e) in
            // 如果要處理 error message 的話可以這樣處理
            if let e = e as? MoyaError, let errorMessage = try? e.response?.mapJSON() {
              print(errorMessage)
            }
          })
          .disposed(by: bag)
    }
    

}
