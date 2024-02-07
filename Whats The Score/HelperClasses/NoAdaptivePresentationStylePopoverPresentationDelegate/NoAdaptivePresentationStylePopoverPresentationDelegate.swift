//
//  NoAdaptivePresentationStylePopoverPresentationDelegate.swift
//  Whats The Score
//
//  Created by Curt McCune on 2/6/24.
//

import Foundation
import UIKit

class NoAdaptivePresentationStylePopoverPresentationDelegate: NSObject, UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
