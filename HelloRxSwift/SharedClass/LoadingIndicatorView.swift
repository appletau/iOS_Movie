//
//  LoadingIndicatorView.swift
//  HelloRxSwift
//
//  Created by ST_Ben.Huang 黃韋韜 on 2020/4/7.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import Foundation
import UIKit

class LoadingIndicatorView:UIView {
    
    lazy var loadingIndicator:UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style:.large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(indicator)
        indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect())
        isHidden = true
        backgroundColor = UIColor(red: 68/255, green: 68/255, blue: 68/255, alpha: 0.7)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func startAnimating() {
        isHidden = false
        loadingIndicator.startAnimating()
    }
    
    func stopAnimating() {
        isHidden = true
        loadingIndicator.stopAnimating()
    }
}
