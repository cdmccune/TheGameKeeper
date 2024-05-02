//
//  GameTabCoordinatorMock.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 3/21/24.
//

import Foundation
@testable import Whats_The_Score

class GameTabCoordinatorMock: GameTabCoordinator {
    
    init() {
        super.init(navigationController: RootNavigationController())
    }
    
    required init(navigationController: RootNavigationController, coreDataStore: CoreDataStoreProtocol = CoreDataStore(.inMemory)) {
        super.init(navigationController: navigationController, coreDataStore: coreDataStore)
    }
    
    var startCalledCount = 0
    override func start() {
        startCalledCount += 1
    }
    
    var startQuickGameCalledCount = 0
    override func startQuickGame() {
        startQuickGameCalledCount += 1
    }
    
    var gameSetupCompleteGameType: GameType?
    var gameSetupCompleteGameEndType: GameEndType?
    var gameSetupCompleteGameEndQuantity: Int?
    var gameSetupCompletePlayers: [PlayerSettings]?
    var gameSetupCompleteName: String?
    var gameSetupCompleteCalledCount = 0
    override func gameSetupComplete(withGameType gameType: GameType,
                                    gameEndType: GameEndType,
                                    gameEndQuantity: Int,
                                    players: [PlayerSettings],
                                    andName name: String) {
        self.gameSetupCompleteGameType = gameType
        self.gameSetupCompleteGameEndType = gameEndType
        self.gameSetupCompleteGameEndQuantity = gameEndQuantity
        self.gameSetupCompletePlayers = players
        self.gameSetupCompleteName = name
        self.gameSetupCompleteCalledCount += 1
        
    }
    
    var showEndGameScreenGame: GameProtocol?
    var showEndGameScreenCalledCount = 0
    override func showEndGameScreen(forGame game: GameProtocol) {
        showEndGameScreenGame = game
        showEndGameScreenCalledCount += 1
    }
    
    var deleteGameCalledCount = 0
    override func deleteGame() {
        deleteGameCalledCount += 1
    }
    
    var playGameAgainCalledCount = 0
    var playGameAgainGame: GameProtocol?
    override func playGameAgain(_ game: GameProtocol) {
        playGameAgainCalledCount += 1
        playGameAgainGame = game
    }
}
