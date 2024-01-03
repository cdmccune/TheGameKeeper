//
//  GeneralMocks.swift
//  What's The Score
//
//  Created by Curt McCune on 12/30/23.
//

import UIKit

class NavigationControllerPushMock: UINavigationController {
    var pushViewControllerCount = 0
    var viewController: UIViewController?
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.viewController = viewController
        pushViewControllerCount += 1
    }
}
