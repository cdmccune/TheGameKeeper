//
//  GameSettingsViewModelTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 3/19/24.
//

import XCTest
@testable import Whats_The_Score

final class GameSettingsViewModelTests: XCTestCase {

    func test_GameSettingsViewModel_WhenSetInitialValuesCalled_ShouldSetGameEndTypeValueToGameGameEndType() {
        // given
        let game = GameMock()
        let gameEndTypeRawValue = Int.random(in: 0...2)
        let gameEndType = GameEndType(rawValue: gameEndTypeRawValue)!
        game.gameEndType = gameEndType
        
        let sut = GameSettingsViewModel(game: game)
        
        let expectation = XCTestExpectation(description: "Game end type should be set")
        
        sut.gameEndType.valueChanged = { gameEndTypeChanged in
            expectation.fulfill()
            XCTAssertEqual(gameEndTypeChanged, gameEndType)
        }
        
        // when
        sut.setInitialValues()
        
        // then
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_GameSettingsViewModel_WhenSaveChangesCalled_ShouldCallDelegateUpdateGameSettings() {
        // given
        let game = GameMock()
        let sut = GameSettingsViewModel(game: game)
        
        sut.gameEndType.value = GameEndType.none
        sut.endingScore = 0
        sut.numberOfRounds = 0
        
        let delegate = GameSettingsDelegateMock()
        sut.delegate = delegate
        
        
        // when
        sut.saveChanges()
        
        // then
        XCTAssertEqual(delegate.updateGameSettingsCalledCount, 1)
    }
    
    func test_GameSettingsViewModel_WhenSaveChangesCalled_ShouldCallDelegateWithCorrectSettings() {
        // given
        let sut = GameSettingsViewModel(game: GameMock())
        
        let gameEndType = GameEndType.allCases.randomElement()!
        let endingScore = Int.random(in: 1...10)
        let numberOfRounds = Int.random(in: 1...10)
        
        sut.gameEndType.value = gameEndType
        sut.endingScore = endingScore
        sut.numberOfRounds = numberOfRounds
        
        let delegate = GameSettingsDelegateMock()
        sut.delegate = delegate
        
        // when
        sut.saveChanges()
        
        // then
        XCTAssertEqual(delegate.updateGameSettingsEndingScore, endingScore)
        XCTAssertEqual(delegate.updateGameSettingsNumberOfRounds, numberOfRounds)
        XCTAssertEqual(delegate.updateGameSettingsGameEndType, gameEndType)
    }
}

class GameSettingsViewModelMock: GameSettingsViewModelProtocol {
    
    var numberOfRounds: Int = 0
    var endingScore: Int = 0
    var gameEndType: Observable<GameEndType> = Observable(nil)
    var game: GameProtocol = GameMock()
    var delegate: GameSettingsDelegate?
    
    var setInitialValuesCalledCount = 0
    func setInitialValues() {
        setInitialValuesCalledCount += 1
    }
    
    var saveChangesCalledCount = 0
    func saveChanges() {
        saveChangesCalledCount += 1
    }
}
