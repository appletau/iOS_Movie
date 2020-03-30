//
//  MovieDetailedViewModel.swift
//  HelloRxSwift
//
//  Created by ST_Ben.Huang 黃韋韜 on 2020/3/30.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

enum MovieDetailedCellContent {
    case main_info
    case rating
    case summary
    case celebrity
    case photos
    case popular_review
}
