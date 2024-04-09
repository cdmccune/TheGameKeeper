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
    var scoreChangeID: UUID? = nil
}
