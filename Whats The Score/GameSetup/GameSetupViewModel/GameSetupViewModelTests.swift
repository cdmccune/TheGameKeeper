//
//  GameSetupViewModelTests.swift
//  What's The Score Tests
//
//  Created by Curt McCune on 12/30/23.
//

import XCTest
@testable import Whats_The_Score

final class GameSetupViewModelTests: XCTestCase {
    
    // MARK: Setup functions
    
    func getBasicGame() -> Game {
        return Game(gameType: .basic, gameEndType: .none, numberOfRounds: 1, numberOfPlayers: 2)
    }
    
    
    // MARK: - Tests
    
    func test_GameSetupViewModel_WhenDelegateIsSet_ShouldCallBindViewToGame() {
        // given
        var sut = GameSetupViewModel(game: getBasicGame())
        let delegateMock = GameSetupViewModelDelegateMock()
        
        // when
        sut.delegate = delegateMock
        
        // then
        XCTAssertEqual(delegateMock.bindViewToGameCalledCount, 1)
    }

    func test_GameSetupViewModel_WhenGameValueChanged_ShouldCallBindViewToGame() {
        // given
        var sut = GameSetupViewModel(game: getBasicGame())
        let delegateMock = GameSetupViewModelDelegateMock()
        sut.delegate = delegateMock
        
        let calledCount = delegateMock.bindViewToGameCalledCount
        
        // when
        sut.game.gameEndType = .score
        
        // then
        XCTAssertEqual(delegateMock.bindViewToGameCalledCount, calledCount + 1)
    }
    
    
    // MARK: - Mock
    
    class GameSetupViewModelDelegateMock: NSObject, GameSetupViewModelProtocol {
        var bindViewToGameCalledCount = 0
        
        func bindViewToGame(with game: Game) {
            bindViewToGameCalledCount += 1
        }
    }

}
