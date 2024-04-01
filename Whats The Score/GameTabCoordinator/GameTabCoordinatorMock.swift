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
    
    required init(navigationController: RootNavigationController) {
        super.init(navigationController: navigationController)
    }
    
    var startCalledCount = 0
    override func start() {
        startCalledCount += 1
    }
    
    var gameSetupCompleteGameType: GameType?
    var gameSetupCompleteGameEndType: GameEndType?
    var gameSetupCompleteGameEndQuantity: Int?
    var gameSetupCompletePlayers: [PlayerProtocol]?
    var gameSetupCompleteCalledCount = 0
    override func gameSetupComplete(withGameType gameType: GameType,
                                    gameEndType: GameEndType,
                                    gameEndQuantity: Int,
                                    andPlayers players: [PlayerProtocol]) {
        self.gameSetupCompleteGameType = gameType
        self.gameSetupCompleteGameEndType = gameEndType
        self.gameSetupCompleteGameEndQuantity = gameEndQuantity
        self.gameSetupCompletePlayers = players
        self.gameSetupCompleteCalledCount += 1
        
    }
    
    var showEndGameScreenGame: GameProtocol?
    var showEndGameScreenCalledCount = 0
    override func showEndGameScreen(forGame game: GameProtocol) {
        showEndGameScreenGame = game
        showEndGameScreenCalledCount += 1
    }
}
