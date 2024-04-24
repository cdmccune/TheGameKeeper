//
//  EndGameCoordinatorProtocolMock.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 4/24/24.
//

import Foundation
@testable import Whats_The_Score

class EndGameCoordinatorProtocolMock: EndGameCoordinatorProtocol {
    var reopenCompletedGameCalledCount = 0
    var reopenCompletedGameGame: GameProtocol?
    func reopenNonActiveGame(_ game: Whats_The_Score.GameProtocol) {
        reopenCompletedGameCalledCount += 1
        reopenCompletedGameGame = game
    }
    
    
}
