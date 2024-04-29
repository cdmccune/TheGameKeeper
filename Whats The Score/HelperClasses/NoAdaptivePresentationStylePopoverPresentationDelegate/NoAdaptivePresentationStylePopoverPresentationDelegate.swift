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
    var maskView: UIView?
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return tapToExit
    }
    
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        // Remove the mask when the popover will dismiss
        self.maskView?.removeFromSuperview()
        self.maskView = nil
    }
}
