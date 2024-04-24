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
    
    var gameTabGameMadeActiveCalledCount = 0
    var gameTabGameMadeActiveGame: GameProtocol?
    override func gameTabGameMadeActive(_ game: GameProtocol) {
        gameTabGameMadeActiveCalledCount += 1
        gameTabGameMadeActiveGame = game
    }
    
    var gameTabActiveGameCompletedCalledCount = 0
    override func gameTabActiveGameCompleted() {
        gameTabActiveGameCompletedCalledCount += 1
    }
    
    var homeTabGameMadeActiveCalledCount = 0
    var homeTabGameMadeActiveGame: GameProtocol?
    override func homeTabGameMadeActive(_ game: GameProtocol) {
        homeTabGameMadeActiveCalledCount += 1
        homeTabGameMadeActiveGame = game
    }
}
