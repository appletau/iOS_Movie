//
//  ExtenString.swift
//  HelloRxSwift
//
//  Created by ST_Ben.Huang 黃韋韜 on 2020/3/26.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import UIKit

extension String {
    public func width(font: UIFont, height: CGFloat) -> CGFloat {
        return NSAttributedString(string: self, attributes: [.font: font]).width(height: height)
    }
    
    public func nsrange(of searchString: String) -> NSRange? {
        guard let range = self.range(of: searchString) else { return nil }
        let nsrange = NSRange(range, in: self)
        return nsrange
    }
}


extension NSAttributedString {
    public func width(height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: [.usesLineFragmentOrigin, .usesFontLeading],
                                            context: nil)
        return ceil(boundingBox.width) + 0.5
    }
}
