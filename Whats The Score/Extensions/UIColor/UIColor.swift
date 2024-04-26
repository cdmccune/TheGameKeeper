//
//  UIColor.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/16/24.
//

import Foundation
import UIKit

extension UIColor {
    static var textColor: UIColor {
        return UIColor(named: "TextColor")!
    }
    
    static var backgroundColor: UIColor {
        return UIColor(named: "BackgroundColor")!
    }
}

extension UIColor {
    public convenience init (hex: String) {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if (cString.count) != 6 {
            self.init(red: 0, green: 0, blue: 0, alpha: 1)
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
