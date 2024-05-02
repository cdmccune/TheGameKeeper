//
//  GameSettingsDelegateMock.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 3/19/24.
//

import XCTest
@testable import Whats_The_Score

class GameSettingsDelegateMock: GameSettingsDelegate {
    var updateGameSettingsCalledCount = 0
    var updateGameSettingsGameEndType: GameEndType?
    var updateGameSettingsNumberOfRounds: Int?
    var updateGameSettingsEndingScore: Int?
    var updateGameSettingsGameName: String?
    
    func updateGameSettings(gameName: String, gameEndType: GameEndType, numberOfRounds: Int, endingScore: Int) {
        self.updateGameSettingsCalledCount += 1
        updateGameSettingsGameEndType = gameEndType
        updateGameSettingsNumberOfRounds = numberOfRounds
        updateGameSettingsEndingScore = endingScore
        updateGameSettingsGameName = gameName
    }
    
    var resetGameCalledCount = 0
    func resetGame() {
        resetGameCalledCount += 1
    }
    
    var deleteGameCalledCount = 0
    func deleteGame() {
        deleteGameCalledCount += 1
    }
}
