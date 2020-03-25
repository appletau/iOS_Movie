//
//  APIService.swift
//  HelloRxSwift
//
//  Created by ST_Ben.Huang 黃韋韜 on 2020/3/24.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import Moya
import RxSwift




final class APIService {
    static let shared = APIService()
    
    private init() {}
    private var provider = MoyaProvider<MultiTarget>()
    
    func request<Request: ApiTargetType>(_ request: Request) -> Single<Request.ResponseDataType> {
        let target = MultiTarget.init(request)
        provider = MoyaProvider<MultiTarget>(session: customSession(request: request), plugins: [])
        if let keyPath = request.dataKeyPath {
            return provider.rx.request(target).filterSuccessfulStatusCodes().map(Request.ResponseDataType.self,atKeyPath: keyPath)
        } else {
            return provider.rx.request(target).filterSuccessfulStatusCodes().map(Request.ResponseDataType.self)
        }
    }
    
    private func customSession<T: ApiTargetType>(request: T) -> Session {
        let configuration = URLSessionConfiguration.default
        configuration.headers = .default
        configuration.timeoutIntervalForRequest = request.timeout
        configuration.timeoutIntervalForResource = request.timeout
        return Session(configuration: configuration, startRequestsImmediately: false)
    }
}
