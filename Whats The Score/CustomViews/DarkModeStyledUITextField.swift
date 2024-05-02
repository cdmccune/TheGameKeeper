//
//  DarkModeStyledUITextField.swift
//  Whats The Score
//
//  Created by Curt McCune on 5/2/24.
//

import Foundation
import UIKit

class DarkModeStyledUITextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTextField()
    }
    
    private func setupTextField() {
        // Setting the border style and color
        self.borderStyle = .roundedRect
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        self.layer.borderWidth = 0.5
        
        // Ensure clipsToBounds is true to apply the cornerRadius
        self.clipsToBounds = true
        
        // Set the text color
        self.textColor = UIColor.textColor
        
        // Update placeholder text color
        updatePlaceholderTextColor()
    }
    
    // Function to update placeholder text color
    private func updatePlaceholderTextColor() {
        guard let placeholderText = self.placeholder else { return }
        self.attributedPlaceholder = NSAttributedString(string: placeholderText,
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.5)])
    }
    
    // Override the placeholder property to update text color dynamically
    override var placeholder: String? {
        didSet {
            updatePlaceholderTextColor()
        }
    }
}
