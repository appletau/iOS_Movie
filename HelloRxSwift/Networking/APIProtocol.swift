//
//  APIProtocol.swift
//  HelloRxSwift
//
//  Created by ST_Ben.Huang 黃韋韜 on 2020/3/24.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import Moya

let apiKey = "0df993c66c0c636e29ecbb5344252a4a"

/// 預先指定response的data type
protocol DecodableResponseTargetType: TargetType {
    associatedtype ResponseDataType: Codable
}

/// API的共用protocol，設定API共用參數，且api的response皆要可以被decode
protocol ApiTargetType: DecodableResponseTargetType {
    var dataKeyPath: String? { get }
    var timeout: TimeInterval { get }
}

/// 共用參數
extension ApiTargetType {
    var baseURL: URL { return URL(string: "https://api.douban.com/v2/movie")! }
    var path: String { fatalError("path for ApiTargetType must be override") }
    var method: Moya.Method { return .get }
    var headers: [String : String]? { return nil }
    var task: Task { return .requestPlain }
    var sampleData: Data { return Data() }
    
    var dataKeyPath: String? { return nil }
    var timeout: TimeInterval { return 20 }
}




