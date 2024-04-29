//
//  PopoverDimissingDelegate.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/29/24.
//

import Foundation
import UIKit

protocol PopoverDimissingDelegate: AnyObject {
    var maskView: UIView? { get set }
    func popoverDismissed()
}
