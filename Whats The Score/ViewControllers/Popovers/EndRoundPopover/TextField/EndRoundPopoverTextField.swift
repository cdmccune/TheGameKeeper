//
//  EndRoundPopoverTextField.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/11/24.
//

import UIKit

class EndRoundPopoverTextField: StackViewTextField {
    
    // MARK: - Initialization

    override init(delegate: StackViewTextFieldDelegateDelegateProtocol, isLast: Bool, index: Int) {
        super.init(delegate: delegate, isLast: isLast, index: index)
        self.setupViews()
        self.addMakeNegativeButtonToToolbar()
    }
    
    required init?(coder: NSCoder) {fatalError("NSCoder not implemented")}
    
    
    // MARK: - Private functions
    
    private func setupViews() {
        self.font =  UIFont(name: "Press Start 2P Regular", size: 15)
    }
    
    private func addMakeNegativeButtonToToolbar() {
        let plusMinusImage = UIImage(systemName: "plus.forwardslash.minus")
        let makeNegativeAction = UIBarButtonItem(image: plusMinusImage, style: .plain, target: self, action: #selector(makeNegativeTapped))
        let toolbar = self.inputAccessoryView as? UIToolbar
        
        guard toolbar?.items?.indices.contains(1) ?? false else { return }
        toolbar?.items?.insert(makeNegativeAction, at: 1)
    }
    
    @objc private func makeNegativeTapped() {
        if let textInt = Int(self.text ?? "") {
            self.text = String(textInt * -1)
        } else if self.text?.isEmpty ?? false {
            self.text = "-"
        } else if self.text == "-" {
            self.text = ""
        }
        
        self.textFieldDidChange()
    }
}
