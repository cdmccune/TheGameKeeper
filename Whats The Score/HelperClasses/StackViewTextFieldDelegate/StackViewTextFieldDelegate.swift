//
//  StackViewTextFieldDelegate.swift
//  Whats The Score
//
//  Created by Curt McCune on 2/19/24.
//

import Foundation
import UIKit

class StackViewTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    init(delegate: StackViewTextFieldDelegateDelegate) {
        self.delegate = delegate
    }
    
    weak var delegate: StackViewTextFieldDelegateDelegate?
}

protocol StackViewTextFieldDelegateDelegate: NSObject {
    func textFieldEditingBegan(index: Int)
    func textFieldShouldReturn(for index: Int)
    func textFieldValueChanged(forIndex index: Int, to newValue: Int)
}
