//
//  GameHistorySegment.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/11/24.
//

import Foundation

enum GameHistorySegment {
    case scoreChange(ScoreChange)
    case endRound(Int, [ScoreChange])
}

struct ScoreChange {
    static func getBlankScoreChange() -> ScoreChange {
        return ScoreChange(playerID: UUID(), scoreChange: 0, playerName: "")
    }
    
    var playerID: UUID
    var scoreChange: Int
    var playerName: String
}
