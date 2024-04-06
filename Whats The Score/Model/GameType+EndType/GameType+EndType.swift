//
//  GameType+EndType.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/5/24.
//

import Foundation

enum GameType: Int, CaseIterable {
    case basic = 0
    case round = 1
}

enum GameEndType: Int, CaseIterable {
    case none = 0
    case round = 1
    case score = 2
}
