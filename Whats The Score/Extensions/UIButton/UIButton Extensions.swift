//
//  UIButton Extensions.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/17/24.
//

import Foundation
import UIKit


extension UIButton {
    @objc func setAttributedUnderlinedTitleWithSubtext(title: String, subtext: String) {
        let subtextFont = UIFont.pressPlay2PRegular(withSize: 15)
        let titleFont = UIFont.pressPlay2PRegular(withSize: 22)
        
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = 10
        paragraphStyle.alignment = .center
        
        var titleAttributes: [NSAttributedString.Key: Any] = [
            .font: titleFont,
            .paragraphStyle: paragraphStyle,
            .underlineColor: UIColor.textColor,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .foregroundColor: UIColor.textColor
        ]
        
        var subtextAttributes: [NSAttributedString.Key: Any] = [
            .font: subtextFont,
            .paragraphStyle: paragraphStyle,
            .foregroundColor: UIColor.textColor
        ]
        
        let attributedString = NSMutableAttributedString(string: "\(title)", attributes: titleAttributes)
        let subtextAttributedString = NSAttributedString(string: "\n\(subtext)", attributes: subtextAttributes)
        attributedString.append(subtextAttributedString)
        
        self.setAttributedTitle(attributedString, for: .normal)
        
        titleAttributes[.foregroundColor] = UIColor.textColor.withAlphaComponent(0.5)
        titleAttributes[.underlineColor] = UIColor.textColor.withAlphaComponent(0.5)
        subtextAttributes[.foregroundColor] = UIColor.textColor.withAlphaComponent(0.5)
        
        let attributedSelectedString = NSMutableAttributedString(string: "\(title)\n", attributes: titleAttributes)
        let subtextAttributedSelectedString = NSAttributedString(string: subtext, attributes: subtextAttributes)
        attributedSelectedString.append(subtextAttributedSelectedString)
        
        self.setAttributedTitle(attributedSelectedString, for: .highlighted)
        self.setAttributedTitle(attributedSelectedString, for: .disabled)
    }
}
