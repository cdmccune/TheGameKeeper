//
//  DismissingTextFieldDelegate.swift
//  What's The Score
//
//  Created by Curt McCune on 1/10/24.
//

import Foundation
import UIKit

class DismissingTextFieldDelegate: NSObject, UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
