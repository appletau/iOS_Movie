//
//  APIProtocol.swift
//  HelloRxSwift
//
//  Created by ST_Ben.Huang 黃韋韜 on 2020/3/24.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import Moya

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
    var baseURL: URL { return URL(string: "https://api.github.com")! }
    var path: String { fatalError("path for ApiTargetType must be override") }
    var method: Moya.Method { return .get }
    var headers: [String : String]? { return nil }
    var task: Task { return .requestPlain }
    var sampleData: Data { return Data() }
    
    var dataKeyPath: String? { return nil }
    var timeout: TimeInterval { return 20 }
}


protocol GitHubApiTargetType:ApiTargetType {}

extension GitHubApiTargetType{}

enum GitHub {
  // 先 conform GitHubApiTargetType 取得最基本的資訊
  // 並且針對這個 endpoint 在定義更詳細的資訊
  // 如果 default 資訊不是你想要的，使用 overload 把它蓋掉
    struct GetUserProfile: GitHubApiTargetType {
    typealias ResponseDataType = User
    var method: Moya.Method { return .get }
    var path: String { return "/users/\(name)" }
    var task: Task { return .requestPlain }

    // stored properties
    private let name: String

    init(name: String) {
      self.name = name
    }
  }
}



