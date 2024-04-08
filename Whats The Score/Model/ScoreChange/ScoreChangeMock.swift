//
//  ScoreChangeMock.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 4/4/24.
//

import Foundation
@testable import Whats_The_Score

class ScoreChangeMock: ScoreChangeProtocol {
    init(endRound: EndRound? = nil,
         game: Game? = nil,
         player: PlayerProtocol = PlayerMock(),
         scoreChange: Int = 0,
         position: Int = 0,
         id: UUID = UUID()) {
        
        self.endRound = endRound
        self.game = game
        self.player = player
        self.scoreChange = scoreChange
        self.position = position
        self.id = id
    }
    
    
    var endRound: Whats_The_Score.EndRound?
    var game: Whats_The_Score.Game?
    var player: Whats_The_Score.PlayerProtocol
    var scoreChange: Int
    var position: Int
    var id: UUID
}
