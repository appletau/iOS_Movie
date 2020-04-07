//
//  ExtenLabel.swift
//  HelloRxSwift
//
//  Created by ST_Ben.Huang 黃韋韜 on 2020/4/6.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    func isLabelTruncated(maxNumberOfLine:Int) -> Bool {
         let myText = self.text! as NSString
         let rect = CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude)
         let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [.font: self.font!], context: nil)

         return Int(ceil(CGFloat(labelSize.height) / self.font.lineHeight)) > maxNumberOfLine
     }
}
