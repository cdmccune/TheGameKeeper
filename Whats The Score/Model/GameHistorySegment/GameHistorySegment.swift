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
    static func getBlankScoreChange() -> ScoreChange {
        return ScoreChange(player: Player(name: "", position: 0), scoreChange: 0)
    }
    
    var id: UUID = UUID()
    var player: Player
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
    
    var id: UUID = UUID()
    var roundNumber: Int
    var scoreChangeArray: [ScoreChange]
}
