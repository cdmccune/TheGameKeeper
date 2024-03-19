//
//  GameSettingsDelegateMock.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 3/19/24.
//

import XCTest
@testable import Whats_The_Score

class GameSettingsDelegateMock: GameSettingsDelegate {
    var updateCalledCount = 0
    var updateGame: GameProtocol?
    
    func update(_ game: GameProtocol) {
        updateCalledCount += 1
        updateGame = game
    }
}
