//
//  ViewControllerExtensions.swift
//  Whats The Score
//
//  Created by Curt McCune on 1/15/24.
//

import Foundation
import UIKit

extension UIViewController {
    @objc func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                         action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
