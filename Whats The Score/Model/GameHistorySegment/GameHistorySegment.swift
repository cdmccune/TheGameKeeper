//
//  GameHistorySegment.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/11/24.
//

import Foundation

enum GameHistorySegment {
    case scoreChange(ScoreChange)
    case endRound(UUID, Int, [ScoreChange])
    
    var id: UUID {
        switch self {
        case .scoreChange(let scoreChange):
            return scoreChange.id
        case .endRound(let id, _, _):
            return id
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
