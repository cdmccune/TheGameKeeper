//
//  GameSetupCoordinatorMock.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 3/21/24.
//

import Foundation
@testable import Whats_The_Score

class GameSetupCoordinatorMock: GameSetupCoordinator {
    
    init() {
        let navigationController = RootNavigationController()
        super.init(navigationController: navigationController)
    }
    
    var startCalledCount = 0
    override func start() {
        startCalledCount += 1
    }
    
    var playersSetupCalledCount = 0
    var playersSetupPlayers: [PlayerProtocol]?
    override func playersSetup(_ players: [PlayerProtocol]) {
        playersSetupCalledCount += 1
        playersSetupPlayers = players
    }
    
    var gameTypeSelectedCalledCount = 0
    override func gameTypeSelected(_ gameType: GameType) {
        self.gameType = gameType
        gameTypeSelectedCalledCount += 1
    }
    
    var gameEndTypeSelectedCalledCount = 0
    override func gameEndTypeSelected(_ gameEndType: GameEndType) {
        self.gameEndType = gameEndType
        gameEndTypeSelectedCalledCount += 1
    }
    
    var gameEndQuantityCalledCount = 0
    override func gameEndQuantitySelected(_ gameEndQuantity: Int) {
        gameEndQuantityCalledCount += 1
        self.gameEndQuantity = gameEndQuantity
    }
    
    var gameNameSetCalledCount = 0
    var gameNameSetName: String?
    override func gameNameSet(_ name: String) {
        gameNameSetCalledCount += 1
        gameNameSetName = name
    }
}
