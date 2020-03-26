//
//  RatingModel.swift
//  HelloRxSwift
//
//  Created by ST_Ben.Huang 黃韋韜 on 2020/3/25.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import Foundation

struct Rating:Codable {
    let min:Int
    let max:Int
    let average:Float
    let stars:String
    let details:Dictionary<String,Int>
}
