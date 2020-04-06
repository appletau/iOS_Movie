//
//  PhotoModel.swift
//  HelloRxSwift
//
//  Created by ST_Ben.Huang 黃韋韜 on 2020/4/1.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import Foundation

struct Photo: Codable {
    let thumb:URL
    let image:URL
    let cover:URL
    let alt:URL
    let id:String
    let icon:URL
}
