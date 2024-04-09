//
//  GamePropertyMock.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/8/24.
//

import XCTest
import CoreData
@testable import Whats_The_Score


class GamePropertyMock: Game {
    
    var temporaryManagedObjectContext: NSManagedObjectContext?
    override var managedObjectContext: NSManagedObjectContext? {
        return temporaryManagedObjectContext
    }
    
    var temporaryPlayerArray: [PlayerProtocol] = []
    override var players: [PlayerProtocol] { temporaryPlayerArray }
    
    var temporaryScoreChangeArray: [ScoreChangeProtocol] = []
    override var scoreChanges: [ScoreChangeProtocol] { temporaryScoreChangeArray }
    
    var temporaryEndRoundsArray: [EndRoundProtocol] = []
    override var endRounds: [EndRoundProtocol] { temporaryEndRoundsArray }
    
    private var temporaryGameType: GameType = .basic
    override var gameType: GameType {
        get { temporaryGameType }
        set { temporaryGameType = newValue}
    }
    
    private var temporaryGameEndType: GameEndType = .none
    override var gameEndType: GameEndType {
        get { temporaryGameEndType }
        set { temporaryGameEndType = newValue}
    }
    
    private var temporaryEndingScoreType: Int = 0
    override var endingScore: Int {
        get { temporaryEndingScoreType }
        set { temporaryEndingScoreType = newValue}
    }
    
    private var temporaryCurrentRound: Int = 0
    override var currentRound: Int {
        get { temporaryCurrentRound }
        set { temporaryCurrentRound = newValue}
    }
}
