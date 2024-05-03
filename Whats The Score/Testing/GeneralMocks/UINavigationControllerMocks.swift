//
//  UINavigationControllerMocks.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 5/3/24.
//

import UIKit
import CoreData
@testable import Whats_The_Score

class NavigationControllerPushMock: UINavigationController {
    var pushViewControllerCount = 0
    var pushedViewController: UIViewController?
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.pushedViewController = viewController
        pushViewControllerCount += 1
    }
}

class RootNavigationControllerPushMock: RootNavigationController {
    var pushViewControllerCount = 0
    var pushedViewController: UIViewController?
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.pushedViewController = viewController
        pushViewControllerCount += 1
    }
}

class NavigationControllerPopMock: UINavigationController {
    var popViewControllerCount = 0
    
    override func popViewController(animated: Bool) -> UIViewController? {
        popViewControllerCount += 1
        return nil
    }
}
