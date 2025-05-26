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
    var updateGameSettingsLowestIsWinning: Bool?
    
    
    func updateGameSettings(gameName: String, gameEndType: GameEndType, numberOfRounds: Int, endingScore: Int, lowestIsWinning: Bool) {
        self.updateGameSettingsCalledCount += 1
        updateGameSettingsGameEndType = gameEndType
        updateGameSettingsNumberOfRounds = numberOfRounds
        updateGameSettingsEndingScore = endingScore
        updateGameSettingsGameName = gameName
        updateGameSettingsLowestIsWinning = lowestIsWinning
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
