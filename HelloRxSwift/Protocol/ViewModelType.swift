//
//  ViewModelType.swift
//  HelloRxSwift
//
//  Created by ST_Ben.Huang 黃韋韜 on 2020/3/26.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import Foundation

protocol ViewModelType {
   associatedtype Input
   associatedtype Output

   var input: Input { get }
   var output: Output { get }
}
