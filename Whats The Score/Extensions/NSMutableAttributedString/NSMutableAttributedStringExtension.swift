//
//  NSMutableAttributedStringExtension.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/16/24.
//

import Foundation
import UIKit

extension NSMutableAttributedString {
    
    func addStrokeAttribute(strokeColor: UIColor, strokeWidth: CGFloat) {
        let fullRange = NSRange(location: 0, length: self.length)
        
        self.enumerateAttributes(in: fullRange, options: []) { (attributes, range, _) in
            var newAttributes = attributes
            newAttributes[.strokeColor] = strokeColor
            newAttributes[.strokeWidth] = abs(strokeWidth) * -1
            self.addAttributes(newAttributes, range: range)
        }
    }
    
    func addTextColorAttribute(textColor: UIColor) {
        let fullRange = NSRange(location: 0, length: self.length)
        
        self.enumerateAttributes(in: fullRange, options: []) { (attributes, range, _) in
            var newAttributes = attributes
            newAttributes[.foregroundColor] = textColor
            self.addAttributes(newAttributes, range: range)
        }
    }
}
