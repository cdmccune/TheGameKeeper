//
//  TestableUIAlertAction.swift
//  Whats The Score
//
//  Created by Curt McCune on 2/9/24.
//

import Foundation
import UIKit

class TestableUIAlertAction: UIAlertAction {
    var handler: ((UIAlertAction) -> Void)?
    class func createWith(title: String?, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)? = nil) -> TestableUIAlertAction {
        let action = TestableUIAlertAction(title: title, style: style, handler: handler)
        action.handler = handler
        return action
    }
}
