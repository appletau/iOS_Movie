//
//  CellConfigurable.swift
//  HelloRxSwift
//
//  Created by ST_Ben.Huang 黃韋韜 on 2020/3/30.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import Foundation

protocol CellConfigurable {
    func setup(viewModel: CellViewModel)
    func showSkeleton()
    func hideSkeleton()
}

