//
//  TopMovie.swift
//  HelloRxSwift
//
//  Created by ST_Ben.Huang 黃韋韜 on 2020/3/25.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import Foundation

struct TopMovie: MovieList {
    let start:Int
    let count:Int
    let total:Int
    let title:String
    let subjects:Array<Subject>
}
