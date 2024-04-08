//
//  GameTabCoreDataHelperMock.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 4/5/24.
//

import Foundation
@testable import Whats_The_Score

class GameTabCoreDataHelperMock: GameTabCoreDataHelperProtocol {
    var coreDataStore: Whats_The_Score.CoreDataStoreProtocol = CoreDataStoreMock()
    
    var gameToReturn: GameProtocol = GameMock()
    
    var startQuickGameCalledCount = 0
    func startQuickGame() -> GameProtocol {
        startQuickGameCalledCount += 1
        return gameToReturn
    }
    
    var initializeGameGameType: GameType?
    var initializeGameGameEndType: GameEndType?
    var initializeGameGameEndQuantity: Int?
    var initializeGamePlayerSettings: [PlayerSettings]?
    var initializeGameCalledCount = 0
    func initializeGame(with gameType: GameType, _ gameEndType: GameEndType, gameEndQuantity: Int, _ playerSettings: [PlayerSettings]) -> GameProtocol {
        initializeGameGameType = gameType
        initializeGameGameEndType = gameEndType
        initializeGameGameEndQuantity = gameEndQuantity
        initializeGamePlayerSettings = playerSettings
        initializeGameCalledCount += 1
        
        return gameToReturn
    }
}
