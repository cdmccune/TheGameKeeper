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
    
    @objc func underlineButtonForButtonStates(title: String) {
        let titleFont = UIFont.pressPlay2PRegular(withSize: 22)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = 5
        
        var titleStringAttributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .foregroundColor: UIColor.textColor,
            .font: titleFont,
            .underlineColor: UIColor.textColor,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        let titleAttributedString = NSMutableAttributedString(string: title, attributes: titleStringAttributes)
        
        // This is to allow for the underline
        let addedString = NSMutableAttributedString(string: "\n")
        addedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 1), range: NSRange(location: 0, length: addedString.length))
        titleAttributedString.append(addedString)
        
        setAttributedTitle(titleAttributedString, for: .normal)
        
        
        // Disabled and Highlighted States
        titleStringAttributes[.foregroundColor] = UIColor.textColor.withAlphaComponent(0.5)
        titleStringAttributes[.underlineColor] = UIColor.textColor.withAlphaComponent(0.5)
        
        let titleAttributedStringDisabled = NSMutableAttributedString(string: title, attributes: titleStringAttributes)
        
        // This is to allow for the underline
        titleAttributedStringDisabled.append(addedString)
        
        setAttributedTitle(titleAttributedStringDisabled, for: .disabled)
        setAttributedTitle(titleAttributedStringDisabled, for: .highlighted)
    }
}
