//
//  ScoreChangeSettings.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/8/24.
//

import Foundation

struct ScoreChangeSettings {
    var player: PlayerProtocol
    var scoreChange: Int = 0
    var scoreChangeID: UUID?
}

extension ScoreChangeSettings: Equatable {}
func == (lhs: ScoreChangeSettings, rhs: ScoreChangeSettings) -> Bool {
    
    if let lhsID = lhs.scoreChangeID, let rhsID = lhs.scoreChangeID {
        return lhsID == rhsID
    }
    
    return lhs.player.id == rhs.player.id && lhs.scoreChange == rhs.scoreChange
}
