//
//  ScoreboardViewModelTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 1/19/24.
//

import XCTest
@testable import Whats_The_Score

final class ScoreboardViewModelTests: XCTestCase {

}

class ScoreboardViewModelMock: ScoreboardViewModelProtocol {
    init(game: GameProtocol) {
        self.game = game
    }
    
    var game: GameProtocol
    var delegate: ScoreboardViewModelViewProtocol?
    
    var endCurrentRoundCalledCount = 0
    func endCurrentRound() {
        endCurrentRoundCalledCount += 1
    }
    
    var endGameCalledCount = 0
    func endGame() {
        endGameCalledCount += 1
    }
}
