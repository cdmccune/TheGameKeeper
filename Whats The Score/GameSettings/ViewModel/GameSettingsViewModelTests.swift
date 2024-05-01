//
//  GameSettingsViewModelTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 3/19/24.
//

import XCTest
@testable import Whats_The_Score

final class GameSettingsViewModelTests: XCTestCase {
    
    
    // MARK: - Init
    
    func test_GameSettingsViewModel_WhenInitialized_ShouldSetGamesNameAsGameName() {
        let game = GameMock()
        let gameName = UUID().uuidString
        game.name = gameName
        let sut = GameSettingsViewModel(game: game)
        XCTAssertEqual(sut.gameName, gameName)
    }

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
    
    
    // MARK: - SaveChanges
    
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
    
    
    // MARK: - resetGame
    
    func test_GameSettingsViewModel_WhenResetGameCalled_ShouldCallDelegateResetGame() {
        // given
        let sut = GameSettingsViewModel(game: GameMock())
        let delegate = GameSettingsDelegateMock()
        sut.delegate = delegate
        
        // when
        sut.resetGame()
        
        // then
        XCTAssertEqual(delegate.resetGameCalledCount, 1)
    }
    
    
    // MARK: - deleteGame
    
    func test_GameSettingsViewModel_WhenDeleteGameCalled_ShouldCallDelegateDeleteGame() {
        // given
        let sut = GameSettingsViewModel(game: GameMock())
        
        let delegate = GameSettingsDelegateMock()
        sut.delegate = delegate
        
        // when
        sut.deleteGame()
        
        // then
        XCTAssertEqual(delegate.deleteGameCalledCount, 1)
    }
    
    
    // MARK: - GameNameChanged
    
    func test_GameSettingsViewModel_WhenGameNameChangedCalled_ShouldSetGameNameTo() {
        // given
        let sut = GameSettingsViewModel(game: GameMock())
        let newGameName = UUID().uuidString
        
        // when
        sut.gameNameChanged(to: newGameName)
        
        // then
        XCTAssertEqual(sut.gameName, newGameName)
    }
    
    func test_GameSettingsViewModel_WhenGameNameChangedCalled_ShouldCallValidateGameSettings() {
        
        class GameSettingsViewModelValidateGameSettingsMock: GameSettingsViewModel {
            var validateGameSettingsCalledCount = 0
            override func validateGameSettings() {
                validateGameSettingsCalledCount += 1
            }
        }
        
        // given
        let sut = GameSettingsViewModelValidateGameSettingsMock(game: GameMock())
        
        // when
        sut.gameNameChanged(to: "")
        
        // then
        XCTAssertEqual(sut.validateGameSettingsCalledCount, 1)
    }
    
    
    // MARK: - GameEndQuantityChanged
    
    func test_GameSettingsViewmodel_WhenGameEndQuantityChangeCalledGameEndTypeScore_ShouldChangeEndingScoreToNewValue() {
        // given
        let sut = GameSettingsViewModel(game: GameMock())
        sut.gameEndType.value = .score
        let newEndingScore = Int.random(in: 1...100)
        
        // when
        sut.gameEndQuantityChanged(to: newEndingScore)
        
        // then
        XCTAssertEqual(sut.endingScore, newEndingScore)
    }
    
    func test_GameSettingsViewmodel_WhenGameEndQuantityChangeCalledGameEndTypeRound_ShouldChangeNumberOfRoundsToNewValue() {
        // given
        let sut = GameSettingsViewModel(game: GameMock())
        sut.gameEndType.value = .round
        let newGameEndQuantity = Int.random(in: 1...10)
        
        // when
        sut.gameEndQuantityChanged(to: newGameEndQuantity)
        
        // then
        XCTAssertEqual(sut.numberOfRounds, newGameEndQuantity)
    }

    func test_GameSettingsViewModel_WhenGameEndQuantityChangedCalled_ShouldCallValidateGameSettings() {

        class GameSettingsViewModelValidateGameSettingsMock: GameSettingsViewModel {
            var validateGameSettingsCalledCount = 0
            override func validateGameSettings() {
                validateGameSettingsCalledCount += 1
            }
        }

        // given
        let sut = GameSettingsViewModelValidateGameSettingsMock(game: GameMock())
        
        // when
        sut.gameEndQuantityChanged(to: 0)
        
        // then
        XCTAssertEqual(sut.validateGameSettingsCalledCount, 1)
    }

    
    // MARK: - GameEndTypeChanged
    
    func test_GameSettingsViewModel_WhenGameEndTypeChangedCalled_ShouldSetGameEndTypeToNewValue() {
        // given
        let sut = GameSettingsViewModel(game: GameMock())
        let newGameEndType = GameEndType.allCases.randomElement()!
        
        // when
        sut.gameEndTypeChanged(toRawValue: newGameEndType.rawValue)
        
        // then
        XCTAssertEqual(sut.gameEndType.value, newGameEndType)
    }

    func test_GameSettingsViewModel_WhenGameEndTypeChangedCalled_ShouldCallValidateGameSettings() {
        class GameSettingsViewModelValidateGameSettingsMock: GameSettingsViewModel {
            var validateGameSettingsCalledCount = 0
            override func validateGameSettings() {
                validateGameSettingsCalledCount += 1
            }
        }
        
        // given
        let sut = GameSettingsViewModelValidateGameSettingsMock(game: GameMock())
        
        // when
        sut.gameEndTypeChanged(toRawValue: 0)
        
        // then
        XCTAssertEqual(sut.validateGameSettingsCalledCount, 1)
    }
    
    
    // MARK: - Validate Game Settings
    
    func test_GameSettingsViewModel_WhenValidateGameSettingsCalled_GameNameIsBlank_ShouldSetDataValidationStringToGameNameString() {
        // given
        let sut = GameSettingsViewModel(game: GameMock())
        let expectation = XCTestExpectation(description: "data validation string should be set")
        
        sut.dataValidationString.valueChanged = { string in
            expectation.fulfill()
            XCTAssertEqual(string, "The game name can't be blank")
        }
        
        // when
        sut.validateGameSettings()
        
        // then
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_GameSettingsViewModel_WhenValidateGameSettingsCalled_GameEndTypeScoreAndScoreSetIsEqualToThanWinningPlayerScore_ShouldSetDataValidationStringToGameScoreString() {
        // given
        let game = GameMock()
        game.winningPlayers = [PlayerMock(score: 10)]
        
        let sut = GameSettingsViewModel(game: game)
        sut.gameName = "d"
        sut.gameEndType.value = .score
        sut.endingScore = 10

        let expectation = XCTestExpectation(description: "data validation string should be set")
        sut.dataValidationString.valueChanged = { string in
            expectation.fulfill()
            XCTAssertEqual(string, "Winning score must be more than 10")
        }
        
        // when
        sut.validateGameSettings()
        
        // then
        wait(for: [expectation], timeout: 0.1)
    }

    func test_GameSettingsViewModel_WhenValidateGameSettingsCalled_NumberOfRoundsLessThanGameCurrentRound_ShouldSetDataValidationStringToNumberOfRoundsString() {
        // given
        let game = GameMock()
        game.currentRound = Int.random(in: 1...10)
        
        let sut = GameSettingsViewModel(game: game)
        sut.numberOfRounds = 0
        sut.gameEndType.value = .round
        sut.gameName = "d"
        
        let expectation = XCTestExpectation(description: "data validation string should be set")
        
        sut.dataValidationString.valueChanged = { string in
            expectation.fulfill()
            XCTAssertEqual(string, "# of rounds must be at least \(game.currentRound)")
        }
        
        // when
        sut.validateGameSettings()
        
        // then
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_GameSettingsViewModel_WhenValidateGameSettingsCalled_AllChecksPass_ShouldSetDataValidationStringToBlank() {
        // given
        let sut = GameSettingsViewModel(game: GameMock())
        sut.gameEndType.value = .round
        sut.numberOfRounds = 10
        sut.gameName = "d"
        
        let expectation = XCTestExpectation(description: "data validation string should be set to blank")
        
        sut.dataValidationString.valueChanged = { string in
            expectation.fulfill()
            XCTAssertEqual(string, "")
        }
        
        // when
        sut.validateGameSettings()
        
        // then
        wait(for: [expectation], timeout: 0.1)
    }
}

class GameSettingsViewModelMock: GameSettingsViewModelProtocol {
    
    var numberOfRounds: Int = 0
    var endingScore: Int = 0
    var gameName: String = ""
    var gameEndType: Observable<GameEndType> = Observable(nil)
    var dataValidationString: Observable<String> = Observable(nil)
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
    
    var deleteGameCalledCount = 0
    func deleteGame() {
        deleteGameCalledCount += 1
    }
    
    var resetGameCalledCount = 0
    func resetGame() {
        resetGameCalledCount += 1
    }
    
    var gameEndQuantityChangedCalledCount = 0
    var gameEndQuantityChangedQuantity: Int?
    func gameEndQuantityChanged(to quantity: Int) {
        gameEndQuantityChangedCalledCount += 1
        gameEndQuantityChangedQuantity = quantity
    }
    
    var gameNameChangedCalledCount = 0
    var gameNameChangedName: String?
    func gameNameChanged(to name: String) {
        gameNameChangedCalledCount += 1
        gameNameChangedName = name
    }

    var gameEndTypeChangedCalledCount = 0
    var gameEndTypeChangedRawValue: Int?
    func gameEndTypeChanged(toRawValue rawValue: Int) {
        gameEndTypeChangedCalledCount += 1
        gameEndTypeChangedRawValue = rawValue
    }
    
    func validateGameSettings() {
        
    }
}
