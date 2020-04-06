//
//  ExpandContent.swift
//  HelloRxSwift
//
//  Created by ST_Ben.Huang 黃韋韜 on 2020/4/1.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import Foundation
import UIKit
import RxSwift


protocol ExpandContent:UITableViewCell {
    var expandBtn:UIButton!{get}
    var bag:DisposeBag{get}
    func switchLinesOfContentLabel(_ isExpanded:Bool)
}
