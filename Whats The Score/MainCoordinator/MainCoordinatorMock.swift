//
//  MainCoordinatorMock.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 3/20/24.
//

import Foundation
@testable import Whats_The_Score


class MainCoordinatorMock: MainCoordinator {
    var setupNewGameCalledCount = 0
    override func setupNewGame() {
        setupNewGameCalledCount += 1
    }
    
    var setupQuickGameCalledCount = 0
    override func setupQuickGame() {
        setupQuickGameCalledCount += 1
    }
    
    var playActiveGameCalledCount = 0
    override func playActiveGame() {
        playActiveGameCalledCount += 1
    }
}
