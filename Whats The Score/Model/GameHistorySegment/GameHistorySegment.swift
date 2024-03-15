//
//  GameHistorySegment.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/11/24.
//

import Foundation

enum GameHistorySegment {
    case scoreChange(ScoreChange)
    case endRound(EndRound)
    
    var id: UUID {
        switch self {
        case .scoreChange(let scoreChange):
            return scoreChange.id
        case .endRound(let endRound):
            return endRound.id
        }
    }
}

extension GameHistorySegment: Equatable {
}
func == (lhs: GameHistorySegment, rhs: GameHistorySegment) -> Bool {
    return lhs.id == rhs.id
}

struct ScoreChange {
    
    init(player: PlayerProtocol, scoreChange: Int) {
        self.playerID = player.id
        self.playerName = player.name
        self.scoreChange = scoreChange
    }
    
    static func getBlankScoreChange() -> ScoreChange {
        return ScoreChange(player: Player.getBasicPlayer(), scoreChange: 0)
    }
    
    var id: UUID = UUID()
    var playerID: UUID
    var playerName: String
    var scoreChange: Int
}

extension ScoreChange: Equatable {}
func == (lhs: ScoreChange, rhs: ScoreChange) -> Bool {
    return lhs.id == rhs.id
}

struct EndRound {
    static func getBlankEndRound() -> EndRound {
        return EndRound(roundNumber: 0, scoreChangeArray: [])
    }
    
    static func getEndRoundWith(numberOfPlayers: Int) -> EndRound {
        var scoreChanges: [ScoreChange] = []
        for _ in 0..<numberOfPlayers {
            scoreChanges.append(ScoreChange(player: Player.getBasicPlayer(), scoreChange: 0))
        }
        return EndRound(roundNumber: 0, scoreChangeArray: scoreChanges)
    }
    
    init(roundNumber: Int, scoreChangeArray: [ScoreChange]) {
        self.roundNumber = roundNumber
        self.scoreChangeArray = scoreChangeArray
    }
    
    init(withPlayers players: [PlayerProtocol], roundNumber: Int) {
        self.roundNumber = roundNumber
        
        var scoreChangeArray: [ScoreChange] = []
        players.forEach { scoreChangeArray.append(ScoreChange(player: $0, scoreChange: 0))}
        self.scoreChangeArray = scoreChangeArray
    }
    
    var id: UUID = UUID()
    var roundNumber: Int
    var scoreChangeArray: [ScoreChange]
}

extension EndRound: Equatable {}
func == (lhs: EndRound, rhs: EndRound) -> Bool {
    return lhs.id == rhs.id
}
