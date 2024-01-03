//
//  GameSetupViewModelTests.swift
//  What's The Score Tests
//
//  Created by Curt McCune on 12/30/23.
//

import XCTest
@testable import What_s_The_Score

final class GameSetupViewModelTests: XCTestCase {
    
    //MARK: Setup functions
    
    func getBasicGameSettings() -> GameSettings {
        return GameSettings(gameType: .basic, gameEndType: .none, numberOfRounds: 1, numberOfPlayers: 2)
    }
    
    
    //MARK: - Tests
    
    func test_GameSetupViewModel_WhenDelegateIsSet_ShouldCallBindViewToGameSettings() {
        //given
        var sut = GameSetupViewModel(gameSettings: getBasicGameSettings())
        let delegateMock = GameSetupViewModelDelegateMock()
        
        //when
        sut.delegate = delegateMock
        
        //then
        XCTAssertEqual(delegateMock.bindViewToGameSettingsCalledCount, 1)
    }

    func test_GameSetupViewModel_WhenGameSettingsValueChanged_ShouldCallBindViewToGameSettings() {
        //given
        var sut = GameSetupViewModel(gameSettings: getBasicGameSettings())
        let delegateMock = GameSetupViewModelDelegateMock()
        sut.delegate = delegateMock
        
        let calledCount = delegateMock.bindViewToGameSettingsCalledCount
        
        //when
        sut.gameSettings.gameEndType = .score
        
        //then
        XCTAssertEqual(delegateMock.bindViewToGameSettingsCalledCount, calledCount + 1)
    }
    
    
    //MARK: - Mock
    
    class GameSetupViewModelDelegateMock: NSObject, GameSetupViewModelProtocol {
        var bindViewToGameSettingsCalledCount = 0
        
        func bindViewToGameSettings(with gameSettings: GameSettings) {
            bindViewToGameSettingsCalledCount += 1
        }
    }

}
