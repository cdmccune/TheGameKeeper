//
//  Game.swift
//  What's The Score
//
//  Created by Curt McCune on 12/30/23.
//

import Foundation

struct Game {
    var gameType: GameType
    var gameEndType: GameEndType
    var numberOfRounds: Int
    var endingScore: Int?
    var numberOfPlayers: Int
    
    var players: [Player] = []
}

enum GameType: Int, CaseIterable {
    case basic = 0
    case round = 1
}

enum GameEndType: Int, CaseIterable {
    case none = 0
    case round = 1
    case score = 2
}
