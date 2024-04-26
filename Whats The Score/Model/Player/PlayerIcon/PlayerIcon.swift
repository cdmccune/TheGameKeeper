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
    case berries = 1
    case car = 2
    case cherry = 3
    case chest = 4
    case coin = 5
    case dice = 6
    case dinosaur = 7
    case fish = 8
    case flower = 9
    case frog = 10
    case key = 11
    case lemon = 12
    case monster = 13
    case orange = 14
    case spaceShip = 15
    
    
    var image: UIImage {
        switch self {
        case .alien:
            return UIImage(named: "alien")!
        case .berries:
            return UIImage(named: "berries")!
        case .car:
            return UIImage(named: "car")!
        case .cherry:
            return UIImage(named: "cherry")!
        case .chest:
            return UIImage(named: "chest")!
        case .coin:
            return UIImage(named: "coin")!
        case .dice:
            return UIImage(named: "dice")!
        case .dinosaur:
            return UIImage(named: "dinosaur")!
        case .fish:
            return UIImage(named: "fish")!
        case .flower:
            return UIImage(named: "flower")!
        case .frog:
            return UIImage(named: "frog")!
        case .key:
            return UIImage(named: "key")!
        case .lemon:
            return UIImage(named: "lemon")!
        case .monster:
            return UIImage(named: "monster")!
        case .orange:
            return UIImage(named: "orange")!
        case .spaceShip:
            return UIImage(named: "spaceShip")!
        }
    }
    
    var color: UIColor {
        switch self {
        case .alien:
            return UIColor(named: "alien")!
        case .berries:
            return UIColor(named: "berries")!
        case .car:
            return UIColor(named: "car")!
        case .cherry:
            return UIColor(named: "cherry")!
        case .chest:
            return UIColor(named: "chest")!
        case .coin:
            return UIColor(named: "coin")!
        case .dice:
            return UIColor(named: "dice")!
        case .dinosaur:
            return UIColor(named: "dinosaur")!
        case .fish:
            return UIColor(named: "fish")!
        case .flower:
            return UIColor(named: "flower")!
        case .frog:
            return UIColor(named: "frog")!
        case .key:
            return UIColor(named: "key")!
        case .lemon:
            return UIColor(named: "lemon")!
        case .monster:
            return UIColor(named: "monster")!
        case .orange:
            return UIColor(named: "orange")!
        case .spaceShip:
            return UIColor(named: "spaceShip")!
        }
    }
}
