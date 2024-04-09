//
//  EndRoundSettings.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/8/24.
//

import Foundation

struct EndRoundSettings {
    var scoreChangeSettingsArray: [ScoreChangeSettings]
    var roundNumber: Int
    var endRoundID: UUID? = nil
}

extension EndRoundSettings: Equatable {}
func == (lhs: EndRoundSettings, rhs: EndRoundSettings) -> Bool {
    if let lhsID = lhs.endRoundID, let rhsID = rhs.endRoundID {
        return lhsID == rhsID
    }
    
    return lhs.scoreChangeSettingsArray == rhs.scoreChangeSettingsArray && lhs.roundNumber == rhs.roundNumber
}
