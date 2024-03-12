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
        return ScoreChange(player: Player(name: "", position: 0), scoreChange: 0)
    }
    
    var player: Player
    var scoreChange: Int
}
