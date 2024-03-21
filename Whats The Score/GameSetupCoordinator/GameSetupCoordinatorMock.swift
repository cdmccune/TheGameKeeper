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
}
