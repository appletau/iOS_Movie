//
//  ReviewModel.swift
//  HelloRxSwift
//
//  Created by ST_Ben.Huang 黃韋韜 on 2020/4/1.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import Foundation

struct Comment: Codable {
    let useful_count:Int
    let author:User
    let content:String
    let created_at:String
    
}
