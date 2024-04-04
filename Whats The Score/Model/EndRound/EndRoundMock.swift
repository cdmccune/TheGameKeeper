//
//  EndRoundMock.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 4/4/24.
//

import Foundation
@testable import Whats_The_Score

class EndRoundMock: EndRoundProtocol {
    
    init(id: UUID = UUID(),
         roundNumber: Int = 0,
         scoreChanges: Set<ScoreChange> = []) {
        self.id = id
        self.roundNumber = roundNumber
        self.scoreChanges = scoreChanges
    }
    
    var id: UUID
    var roundNumber: Int
    var scoreChanges: Set<Whats_The_Score.ScoreChange>
}
