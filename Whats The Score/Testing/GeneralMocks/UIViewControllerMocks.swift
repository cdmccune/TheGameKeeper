//
//  UIViewControllerMocks.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 5/3/24.
//

import Foundation
import UIKit
@testable import Whats_The_Score

class ViewControllerPresentMock: UIViewController {
    var presentCalledCount = 0
    var presentViewController: UIViewController?
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        presentCalledCount += 1
        presentViewController = viewControllerToPresent
    }
}
