//
//  String+.swift
//  FlexibleBottomSheet
//
//  Created by 60156672 on 2022/04/27.
//

import Foundation
import UIKit

extension String {
    func getWidthOfString(font: UIFont) -> CGFloat {
        return (self as NSString).size(withAttributes: [NSAttributedString.Key.font : font]).width
    }
}
