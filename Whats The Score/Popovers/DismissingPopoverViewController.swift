//
//  DismissingPopover.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/29/24.
//

import Foundation
import UIKit

protocol DismissingPopoverViewController: UIViewController {
    var dismissingDelegate: PopoverDimissingDelegate? { get set }
    func dismissPopover()
}

extension DismissingPopoverViewController {
    func dismissPopover() {
        dismissingDelegate?.popoverDismissed()
        self.dismiss(animated: true)
    }
}
