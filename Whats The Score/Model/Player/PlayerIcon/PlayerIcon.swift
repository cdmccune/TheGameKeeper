//
//  PlayerIcon.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/18/24.
//

import Foundation
import UIKit

enum PlayerIcon: Int, CaseIterable {
    case alien = 0
    case apple = 1
    case banana = 2
   
    
    var image: UIImage {
        switch self {
        case .alien:
            return UIImage(named: "alien")!
        case .apple:
            return UIImage(named: "apple")!
        case .banana:
            return UIImage(named: "banana")!
        }
    }
    
    var color: UIColor {
        switch self {
        case .alien:
            return UIColor.green
        case .apple:
            return UIColor.red
        case .banana:
            return UIColor.yellow
        }
    }
}
