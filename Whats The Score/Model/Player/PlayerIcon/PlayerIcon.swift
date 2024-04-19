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
    case alien1 = 1
    case alien2 = 2
    case alien3 = 3
    case alien4 = 4
    case alien5 = 5
    case alien6 = 6
    case alien7 = 7
    case alien8 = 8
    case alien9 = 9
    case alien10 = 10
    case alien11 = 11
    case alien12 = 12
    case alien13 = 13
    case alien14 = 14
    
    var image: UIImage {
//        switch self {
//        case .alien:
            return UIImage(named: "Alien")!
//        }
    }
    
    var color: UIColor {
//        switch self {
//        case .alien:
            return UIColor.green
//        }
    }
}
