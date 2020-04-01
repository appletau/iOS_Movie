//
//  RatingModel.swift
//  HelloRxSwift
//
//  Created by ST_Ben.Huang 黃韋韜 on 2020/3/25.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import Foundation

struct Rating: Codable {
    let min:Int
    let max:Int
    let average:Float
    let stars:String
    let details:Dictionary<String,Int>
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.min = values.contains(.min) ? try values.decode(Int.self, forKey: .min) : -1
        self.max = values.contains(.max) ? try values.decode(Int.self, forKey: .max) : -1
        self.average = values.contains(.average) ? try values.decode(Float.self, forKey: .average) : -1.0
        self.stars = values.contains(.stars) ? try values.decode(String.self, forKey: .stars) : ""
        self.details = values.contains(.details) ? try values.decode(Dictionary<String,Int>.self, forKey: .details) : [:]
    }
}
