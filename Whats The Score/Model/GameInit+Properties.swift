//
//  GameInit+Properties.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/5/24.
//

import Foundation
import CoreData

class Game: NSManagedObject, GameProtocol {
    
    // MARK: - Initialization
    
    convenience init(basicGameWithContext context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = UUID()
        self.endRounds_ = []
        self.players_ = []
        self.scoreChanges_ = []
        self.name = ""
        self.lowestIsWinning = false
    }
    
    convenience init(name: String,
                     gameType: GameType,
                     gameEndType: GameEndType,
                     gameStatus: GameStatus = .active,
                     numberOfRounds: Int = 2,
                     currentRound: Int = 1,
                     endingScore: Int = 10,
                     lowestIsWinning: Bool = false,
                     players: [Player],
                     context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = UUID()
        self.name = name
        self.gameType = gameType
        self.gameEndType = gameEndType
        self.gameStatus = gameStatus
        self.numberOfRounds = numberOfRounds
        self.currentRound = currentRound
        self.endingScore = endingScore
        self.lowestIsWinning = lowestIsWinning
        players.forEach { player in
            self.addToPlayers_(player)
        }
        self.scoreChanges_ = []
        self.endRounds_ = []
    }
    
    // MARK: - NSManaged Properties
    
    @NSManaged public var id: UUID
    @NSManaged public var lastModified: Date
    @NSManaged public var lowestIsWinning: Bool
    @NSManaged public var name: String
    @NSManaged private var players_: Set<Player>
    @NSManaged private var scoreChanges_: Set<ScoreChange>
    @NSManaged private var endRounds_: Set<EndRound>
    @NSManaged private var gameType_: Int64
    @NSManaged private var gameEndType_: Int64
    @NSManaged private var numberOfRounds_: Int64
    @NSManaged private var endingScore_: Int64
    @NSManaged private var currentRound_: Int64
    @NSManaged private var gameStatus_: Int64
    
    
    // MARK: - Overrides
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        lastModified = Date()
    }
    
    override func willSave() {
        super.willSave()
        let date = Date()
        if isUpdated,
           (date.timeIntervalSince1970 - lastModified.timeIntervalSince1970) > 2 {
            lastModified = Date()
        }
    }
    
    
    // MARK: - Computed Public Properties
    
    var gameType: GameType {
        get {
            return GameType(rawValue: Int(truncatingIfNeeded: gameType_)) ?? .basic
        }
        set {
            gameType_ = Int64(newValue.rawValue)
        }
    }
    
    var gameEndType: GameEndType {
        get {
            return GameEndType(rawValue: Int(truncatingIfNeeded: gameEndType_)) ?? .none
        }
        set {
            gameEndType_ = Int64(newValue.rawValue)
        }
    }
    
    var gameStatus: GameStatus {
        get {
            return GameStatus(rawValue: Int(truncatingIfNeeded: gameStatus_)) ?? .active
        }
        
        set {
            gameStatus_ = Int64(newValue.rawValue)
        }
    }
    
    var numberOfRounds: Int {
        get {
            Int(truncatingIfNeeded: numberOfRounds_)
        }
        set {
            numberOfRounds_ = Int64(newValue)
        }
    }
    
    var endingScore: Int {
        get {
            Int(truncatingIfNeeded: endingScore_)
        }
        set {
            endingScore_ = Int64(newValue)
        }
    }
    
    var currentRound: Int {
        get {
            Int(truncatingIfNeeded: currentRound_)
        }
        set {
            currentRound_ = Int64(newValue)
        }
    }
    
    var players: [PlayerProtocol] {
        players_.sorted { $0.position < $1.position }
    }
    
    var winningPlayers: [PlayerProtocol] {
        let sortedPlayers = players.sorted { $0.score>$1.score }
        return players.filter { $0.score == (sortedPlayers.first?.score ?? 0) }
    }
    
    var endRounds: [EndRoundProtocol] {
        endRounds_.sorted { $0.roundNumber < $1.roundNumber }
    }
    
    var scoreChanges: [ScoreChangeProtocol] {
        return scoreChanges_.sorted { $0.position < $1.position }
    }
}
