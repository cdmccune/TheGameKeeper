//
//  StackViewTextFieldDelegate.swift
//  Whats The Score
//
//  Created by Curt McCune on 2/19/24.
//

import Foundation
import UIKit

class StackViewTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    // MARK: - Init
    
    init(delegate: StackViewTextFieldDelegateDelegateProtocol) {
        self.delegate = delegate
    }
    
    
    // MARK: - Delegate
    
    weak var delegate: StackViewTextFieldDelegateDelegateProtocol?
    
    
    // MARK: - Functions
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.textFieldEditingBegan(index: textField.tag)
    }


}

protocol StackViewTextFieldDelegateDelegateProtocol: NSObject {
    func textFieldEditingBegan(index: Int)
    func textFieldShouldReturn(for index: Int)
    func textFieldValueChanged(forIndex index: Int, to newValue: String?)
}
