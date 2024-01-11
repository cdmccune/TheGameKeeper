//
//  PlayerSetupNameTextFieldDelegate.swift
//  What's The Score
//
//  Created by Curt McCune on 1/11/24.
//

import Foundation
import UIKit

class PlayerSetupNameTextFieldDelegate: DismissingTextFieldDelegate {
    
    var hasDefaultName: Bool?
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if hasDefaultName ?? false {
            textField.text = ""
        }
    }
}
