//
//  NoAdaptivePresentationStylePopoverPresentationDelegate.swift
//  Whats The Score
//
//  Created by Curt McCune on 2/6/24.
//

import Foundation
import UIKit

class NoAdaptivePresentationStylePopoverPresentationDelegate: NSObject, UIPopoverPresentationControllerDelegate {
    
    init(tapToExit: Bool = true) {
        self.tapToExit = tapToExit
    }
    
    var tapToExit: Bool
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return tapToExit
    }
}
