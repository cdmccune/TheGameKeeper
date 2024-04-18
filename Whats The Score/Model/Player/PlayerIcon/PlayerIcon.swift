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
    
    var image: UIImage {
        switch self {
        case .alien:
            return UIImage(named: "Alien")!
        }
    }
    
    var color: UIColor {
        switch self {
        case .alien:
            return UIColor.green
        }
    }
}
