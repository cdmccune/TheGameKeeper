//
//  EndRoundMock.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 4/4/24.
//

import Foundation
@testable import Whats_The_Score

class EndRoundMock: EndRoundProtocol {
    
    static func getEndRoundWith(numberOfPlayers: Int) -> EndRoundMock {
        var scoreChanges: [ScoreChangeProtocol] = []
        for i in 0..<numberOfPlayers {
            scoreChanges.append(ScoreChangeMock(player: PlayerMock(position: i + 1), scoreChange: 0))
        }
        return EndRoundMock(roundNumber: 0, scoreChangeArray: scoreChanges)
    }
    
    init(id: UUID = UUID(),
         roundNumber: Int = 0,
         scoreChangeArray: [ScoreChangeProtocol] = []) {
        self.id = id
        self.roundNumber = roundNumber
        self.scoreChanges = scoreChangeArray
    }
    
    var id: UUID
    var roundNumber: Int
    var scoreChanges: [ScoreChangeProtocol]
}
