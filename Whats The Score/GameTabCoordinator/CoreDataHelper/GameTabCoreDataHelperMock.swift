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
    var initializeGameName: String?
    var initializeGameCalledCount = 0
    func initializeGame(with gameType: GameType, _ gameEndType: GameEndType, gameEndQuantity: Int, _ playerSettings: [PlayerSettings], andName name: String) -> GameProtocol {
        initializeGameGameType = gameType
        initializeGameGameEndType = gameEndType
        initializeGameGameEndQuantity = gameEndQuantity
        initializeGamePlayerSettings = playerSettings
        initializeGameName = name
        initializeGameCalledCount += 1
        
        return gameToReturn
    }
    
    var endGameCalledCount = 0
    var endGameGame: GameProtocol?
    func endGame(_ game: GameProtocol) {
        endGameGame = game
        endGameCalledCount += 1
    }
    
    var makeGameActiveCalledCount = 0
    var makeGameActiveGame: GameProtocol?
    func makeGameActive(_ game: GameProtocol) {
        makeGameActiveCalledCount += 1
        makeGameActiveGame = game
    }
}
