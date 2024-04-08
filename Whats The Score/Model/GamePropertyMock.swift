//
//  GamePropertyMock.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/8/24.
//

import XCTest
@testable import Whats_The_Score


class GamePropertyMock: Game {
    
    var temporaryPlayerArray: [PlayerProtocol] = []
    override var players: [PlayerProtocol] { temporaryPlayerArray }
    
    var temporaryGameType: GameType = .basic
    override var gameType: GameType { 
        get { temporaryGameType }
        set { temporaryGameType = newValue}
    }
    
    var temporaryGameEndType: GameEndType = .none
    override var gameEndType: GameEndType {
        get { temporaryGameEndType }
        set { temporaryGameEndType = newValue}
    }
    
    var temporaryEndingScoreType: Int = 0
    override var endingScore: Int {
        get { temporaryEndingScoreType }
        set { temporaryEndingScoreType = newValue}
    }
}
