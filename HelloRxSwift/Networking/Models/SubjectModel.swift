//
//  SubjectModel.swift
//  HelloRxSwift
//
//  Created by ST_Ben.Huang 黃韋韜 on 2020/3/25.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import Foundation

struct Subject:MovieSubject {
    let id:String
    let title:String
    let original_title:String
    let alt:String
    let rating:Rating
    let collect_count:Int
    let images:Dictionary<String,URL>
    let subtype:String
    let directors:Array<Celebrity>
    let casts:Array<Celebrity>
    let pubdates:Array<String>
    let mainland_pubdate:String
    let year:String
    let durations:Array<String>
    let genres:Array<String>
}
