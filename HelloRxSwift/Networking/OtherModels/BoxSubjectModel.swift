//
//  BoxSubjectModel.swift
//  HelloRxSwift
//
//  Created by ST_Ben.Huang 黃韋韜 on 2020/3/25.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import Foundation

struct BoxSubject:Codable {
    let rank:Int
    let box:Int
    let new:Bool
    let subject:Subject
}
