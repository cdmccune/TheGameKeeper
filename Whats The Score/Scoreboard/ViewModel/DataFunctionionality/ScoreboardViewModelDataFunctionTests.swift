//
//  ScoreboardViewModelDataFunctionTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 1/19/24.
//

import XCTest
@testable import Whats_The_Score

final class ScoreboardViewModelDataFunctionTests: XCTestCase {
    
    func getViewModelWithBasicGame() -> ScoreboardViewModel {
        return ScoreboardViewModel(game: GameMock())
    }
    
    
    // MARK: - AddPlayer
    
    func test_ScoreboardViewModel_WhenAddPlayerCalled_ShouldCallAddPlayerOnGame() {
        // given
        let sut = getViewModelWithBasicGame()
        let gameMock = GameMock()
        sut.game = gameMock
        
        // when
        sut.addPlayer()
        
        // then
        XCTAssertEqual(gameMock.addPlayerCalledCount, 1)
    }
    
    func test_ScoreboardViewModel_WhenAddPlayerCalled_ShouldCallBindViewModelToView() {
        // given
        let sut = getViewModelWithBasicGame()
        
        let viewDelegate = ScoreboardViewModelViewProtocolMock()
        sut.delegate = viewDelegate
        
        let gameMock = GameMock()
        sut.game = gameMock
        
        let bindViewToViewModelCalledCount = viewDelegate.bindViewToViewModelCalledCount
        
        // when
        sut.addPlayer()
        
        // then
        XCTAssertEqual(viewDelegate.bindViewToViewModelCalledCount, bindViewToViewModelCalledCount + 1)
    }
    
    func test_ScoreboardViewModel_WhenAddPlayerCalled_ShouldCallCoreDataStoreSaveChanges() {
        // given
        let sut = getViewModelWithBasicGame()
        let coreDataStore = CoreDataStoreMock()
        sut.coreDataStore = coreDataStore
        
        // when
        sut.addPlayer()
        
        // then
        XCTAssertEqual(coreDataStore.saveContextCalledCount, 1)
    }
    
    
    // MARK: - DeletePlayer
    
    func test_ScoreboardViewModel_WhenDeletePlayerCalled_ShouldCallGamesDeletePlayer() {
        // given
        let position = Int.random(in: 1...100)
        let player = PlayerMock(position: position)
        let game = GameMock()
        let sut = ScoreboardViewModel(game: game)
        
        // when
        sut.deletePlayer(player)
        
        // then
        XCTAssertEqual(game.deletePlayerPlayer?.id, player.id)
        XCTAssertEqual(game.deletePlayerCalledCount, 1)
    }
    
    func test_ScoreboardViewModel_WhenDeletePlayerCalled_ShouldCallBindViewModelToView() {
        // given
        let sut = getViewModelWithBasicGame()
        let viewDelegate = ScoreboardViewModelViewProtocolMock()
        sut.delegate = viewDelegate
        
        let previousBindCount = viewDelegate.bindViewToViewModelCalledCount
        
        // when
        sut.deletePlayer(PlayerMock(name: "", position: 0))
        
        // then
        XCTAssertEqual(viewDelegate.bindViewToViewModelCalledCount, previousBindCount + 1)
    }
    
    func test_ScoreboardViewModel_WhenDeletePlayerCalled_ShouldCallCoreDataStoreSaveChanges() {
        // given
        let sut = getViewModelWithBasicGame()
        let coreDataStore = CoreDataStoreMock()
        sut.coreDataStore = coreDataStore
        
        // when
        sut.deletePlayer(PlayerMock())
        
        // then
        XCTAssertEqual(coreDataStore.saveContextCalledCount, 1)
    }
    
    // MARK: - ResetGame
    
    func test_ScoreboardViewModel_WhenResetGameCalled_ShouldCallGameResetGame() {
        // given
        let game = GameMock()
        let sut = ScoreboardViewModel(game: game)
        
        // when
        sut.resetGame()
        
        // then
        XCTAssertEqual(game.resetGameCalledCount, 1)
    }
    
    func test_ScoreboardViewModel_WhenResetGameCalled_ShouldCallBindViewToViewModel() {
        // given
        let sut = getViewModelWithBasicGame()
        let viewDelegate = ScoreboardViewModelViewProtocolMock()
        sut.delegate = viewDelegate
        
        let bindViewToViewModelCalledCountBefore = viewDelegate.bindViewToViewModelCalledCount
        
        // when
        sut.resetGame()
        
        // then
        XCTAssertEqual(viewDelegate.bindViewToViewModelCalledCount, bindViewToViewModelCalledCountBefore + 1)
    }
    
    func test_ScoreboardViewModel_WhenResetCalled_ShouldCallCoreDataStoreSaveChanges() {
        // given
        let sut = getViewModelWithBasicGame()
        let coreDataStore = CoreDataStoreMock()
        sut.coreDataStore = coreDataStore
        
        // when
        sut.resetGame()
        
        // then
        XCTAssertEqual(coreDataStore.saveContextCalledCount, 1)
    }
    
    
    // MARK: - FinishedEditingPlayer
    
    func test_ScoreboardViewModel_WhenFinishedEditingPlayerCalled_ShouldCallGameEditPlayerWithPlayerSettings() {
        // given
        let game = GameMock()
        let sut = ScoreboardViewModel(game: game)
        let playerSettings = PlayerSettings.getStub()
        
        // when
        sut.finishedEditing(playerSettings)
        
        // then
        XCTAssertEqual(game.editPlayerPlayerSettings, playerSettings)
        XCTAssertEqual(game.editPlayerCalledCount, 1)
    }
    
    func test_ScoreboardViewModel_WhenFinishedEditingCalled_ShouldCallBindViewToViewModel() {
        // given
        let sut = getViewModelWithBasicGame()

        let viewModelViewDelegate = ScoreboardViewModelViewProtocolMock()
        sut.delegate = viewModelViewDelegate
        
        let previousBindCount = viewModelViewDelegate.bindViewToViewModelCalledCount
        
        // when
        sut.finishedEditing(PlayerSettings.getStub())
        
        // then
        XCTAssertEqual(viewModelViewDelegate.bindViewToViewModelCalledCount, previousBindCount + 1)
    }
    
    func test_ScoreboardViewModel_WhenFinishedEditingCalled_ShouldCallCoreDataStoreSaveChanges() {
        // given
        let sut = getViewModelWithBasicGame()
        let coreDataStore = CoreDataStoreMock()
        sut.coreDataStore = coreDataStore
        
        // when
        sut.finishedEditing(PlayerSettings.getStub())
        
        // then
        XCTAssertEqual(coreDataStore.saveContextCalledCount, 1)
    }

    
    // MARK: - EditScore
    
    func test_ScoreboardViewModel_WhenEditScoreCalled_ShouldCallGameChangeScoreWithScoreChangeChange() {
        // given
        let game = GameMock()
        let sut = ScoreboardViewModel(game: game)
        
        let scoreChangeObject = ScoreChangeSettings.getStub()
        
        // when
        sut.editScore(scoreChangeObject)
        
        // then
        XCTAssertEqual(game.changeScoreScoreChangeSettings, scoreChangeObject)
        XCTAssertEqual(game.changeScoreCalledCount, 1)
    }
    
    func test_ScoreboardViewModel_WhenEditScoreCalledPlayerInGame_ShouldCallBindViewToViewModel() {
        // given
        let sut = ScoreboardViewModel(game: GameMock())
        
        let viewModelViewDelegate = ScoreboardViewModelViewProtocolMock()
        sut.delegate = viewModelViewDelegate
        
        let previousBindCount = viewModelViewDelegate.bindViewToViewModelCalledCount
        
        let scoreChangeObject = ScoreChangeSettings.getStub()
        
        // when
        sut.editScore(scoreChangeObject)
        
        // then
        XCTAssertEqual(viewModelViewDelegate.bindViewToViewModelCalledCount, previousBindCount + 1)
    }
    
    func test_ScoreboardViewModel_WhenEditScoreCalled_ShouldCallIsEndOfGame() {
        // given
        let game = GameIsEndOfGameMock()
        
        let sut = ScoreboardViewModel(game: game)
        
        let scoreChangeObject = ScoreChangeSettings.getStub()
        
        // when
        sut.editScore(scoreChangeObject)
        
        // then
        XCTAssertEqual(game.isEndOfGameCalledCount, 1)
    }
    
    func test_ScoreboardViewModel_WhenEditScoreCalledIsEndOfGameTrue_ShouldCallCoordinatorShowEndGamePopoverWith1SecondDelay() {
        
        // given
        let game = GameIsEndOfGameMock()
        game.isEndOfGameBool = true
        
        let sut = ScoreboardViewModel(game: game)
        
        let scoreChangeObject = ScoreChangeSettings.getStub()
        
        let coordinator = ScoreboardCoordinatorMock(navigationController: RootNavigationController())
        sut.coordinator = coordinator
        
        
        // when
        sut.editScore(scoreChangeObject)
        
        // then
        XCTAssertEqual(coordinator.showEndGamePopoverCalledCount, 1)
        XCTAssertTrue(coordinator.showEndGamePopoverGame?.isEqualTo(game: game) ?? false)
        XCTAssertEqual(coordinator.showEndGamePopoverDelay, 1.0)
        XCTAssertTrue(coordinator.showEndGamePopoverDelegate === sut)
    }
    
    func test_ScoreboardViewModel_WhenEditScoreCalledIsEndOfGameFalse_ShouldNotCallEndGame() {
        
        // given
        let game = GameIsEndOfGameMock()
        game.isEndOfGameBool = false
        
        let sut = ScoreboardViewModel(game: game)
        
        let coordinator = ScoreboardCoordinatorMock(navigationController: RootNavigationController())
        sut.coordinator = coordinator
        
        let scoreChangeObject = ScoreChangeSettings.getStub()
        
        // when
        sut.editScore(scoreChangeObject)
        
        // then
        XCTAssertEqual(coordinator.showEndGamePopoverCalledCount, 0)
    }
    
    func test_Scoreboard_WhenEditScoreCalled_ShouldCallCoreDataStoreSaveChanges() {
        // given
        let sut = getViewModelWithBasicGame()
        let coreDataStore = CoreDataStoreMock()
        sut.coreDataStore = coreDataStore
        
        // when
        sut.editScore(ScoreChangeSettings.getStub())
        
        // then
        XCTAssertEqual(coreDataStore.saveContextCalledCount, 1)
    }
    
    
    // MARK: - EndRound
    
    func test_ScoreboardViewModel_WhenEndRoundCalled_ShouldCallGameEndRoundWithEndRoundObject() {
        // given
        let gameMock = GameMock()
        let sut = ScoreboardViewModel(game: gameMock)
        
        let endRound = EndRoundSettings(scoreChangeSettingsArray: [], roundNumber: 0, endRoundID: UUID())
        
        // when
        sut.endRound(endRound)
        
        // then
        XCTAssertEqual(gameMock.endRoundEndRound, endRound)
        XCTAssertEqual(gameMock.endRoundCalledCount, 1)
    }
    
    func test_ScoreboardViewModel_WhenEndRoundCalled_ShouldCallBindViewToViewModel() {
        // given
        let sut = getViewModelWithBasicGame()
        
        let viewDelegate = ScoreboardViewModelViewProtocolMock()
        sut.delegate = viewDelegate
        
        let bindViewToViewModelCalledCount = viewDelegate.bindViewToViewModelCalledCount
        
        // when3
        sut.endRound(EndRoundSettings.getStub(withPlayerCount: 0))
        
        // then
        XCTAssertEqual(viewDelegate.bindViewToViewModelCalledCount, bindViewToViewModelCalledCount + 1)
    }
    
    
    func test_ScoreboardViewModel_WhenEndRoundCalled_ShouldCallIsEndOfGame() {
        // given
        let game = GameIsEndOfGameMock()
        game.isEndOfGameBool = true
        let sut = ScoreboardViewModel(game: game)
        
        // when
        sut.endRound(EndRoundSettings.getStub(withPlayerCount: 0))
        
        // then
        XCTAssertEqual(game.isEndOfGameCalledCount, 1)
    }
    
    func test_ScoreboardViewModel_WhenEndRoundCalledIsEndOfGameTrue_ShouldCallCoordinatorShowEndGamePopupWithDelayOneSecond() {
        // given
        let game = GameIsEndOfGameMock()
        game.isEndOfGameBool = true
        let sut = ScoreboardViewModel(game: game)
        
        let coordinator = ScoreboardCoordinatorMock(navigationController: RootNavigationController())
        sut.coordinator = coordinator
        
        // when
        sut.endRound(EndRoundSettings.getStub(withPlayerCount: 0))
        
        // then
        XCTAssertEqual(coordinator.showEndGamePopoverCalledCount, 1)
        XCTAssertEqual(coordinator.showEndGamePopoverDelay, 1.0)
        XCTAssertTrue(coordinator.showEndGamePopoverGame?.isEqualTo(game: game) ?? false)
        XCTAssertTrue(coordinator.showEndGamePopoverDelegate === sut)
    }
    
    func test_ScoreboardViewModel_WhenEndRoundCalledIsEndOfGameFalse_ShouldNotCallCoordinatorShowEndGamePopup() {
        // given
        let game = GameIsEndOfGameMock()
        game.isEndOfGameBool = false
        let sut = ScoreboardViewModel(game: game)
        
        let coordinator = ScoreboardCoordinatorMock(navigationController: RootNavigationController())
        sut.coordinator = coordinator
        
        // when
        sut.endRound(EndRoundSettings.getStub(withPlayerCount: 0))
        
        // then
        XCTAssertEqual(coordinator.showEndGamePopoverCalledCount, 0)
    }
    
    func test_ScoreboardViewModel_WhenEndRoundCalled_ShouldCallCoreDataStoreSaveChanges() {
        // given
        let sut = getViewModelWithBasicGame()
        let coreDataStore = CoreDataStoreMock()
        sut.coreDataStore = coreDataStore
        
        // when
        sut.endRound(EndRoundSettings.getStub(withPlayerCount: 0))
        
        // then
        XCTAssertEqual(coreDataStore.saveContextCalledCount, 1)
    }
    
    
    // MARK: - UpdateGameSettings
    
    func test_ScoreboardViewModel_WhenUpdateGameSettingsCalled_ShouldCallGameUpdateSettingsWithCorrectSettings() {
        // given
        let gameMock = GameMock()
        let sut = ScoreboardViewModel(game: gameMock)
        
        let numberOfRounds = Int.random(in: 1...10)
        let endingScore = Int.random(in: 1...10)
        let gameEndType = GameEndType.allCases.randomElement()!
        
        // when
        sut.updateGameSettings(gameEndType: gameEndType, numberOfRounds: numberOfRounds, endingScore: endingScore)
        
        // then
        XCTAssertEqual(gameMock.updateSettingsCalledCount, 1)
        XCTAssertEqual(gameMock.updateSettingsGameEndType, gameEndType)
        XCTAssertEqual(gameMock.updateSettingsNumberOfRounds, numberOfRounds)
        XCTAssertEqual(gameMock.updateSettingsEndingScore, endingScore)
    }
    
    func test_ScoreboardViewModel_WhenUpdateGameSettingsCalled_ShouldCallBindViewToViewModel() {
        // given
        let sut = getViewModelWithBasicGame()
        
        let viewDelegate = ScoreboardViewModelViewProtocolMock()
        sut.delegate = viewDelegate
        
        let bindCount = viewDelegate.bindViewToViewModelCalledCount
        
        // when
        sut.updateGameSettings(gameEndType: .none, numberOfRounds: 0, endingScore: 0)
        
        // then
        XCTAssertEqual(viewDelegate.bindViewToViewModelCalledCount, bindCount + 1)
    }
    
    func test_ScoreboardViewModel_WhenUpdateGameSettingsCalled_ShouldCallCoreDataStoreSaveChanges() {
        // given
        let sut = getViewModelWithBasicGame()
        let coreDataStore = CoreDataStoreMock()
        sut.coreDataStore = coreDataStore
        
        // when
        sut.updateGameSettings(gameEndType: GameEndType.none, numberOfRounds: 0, endingScore: 0)
        
        // then
        XCTAssertEqual(coreDataStore.saveContextCalledCount, 1)
    }
    
    
    // MARK: - DeleteGame
    
    func test_ScoreboardViewModel_WhenDeleteGameCalled_ShouldCallCoordinatorDeleteGame() {
        // given
        let sut = getViewModelWithBasicGame()

        let coordinator = ScoreboardCoordinatorMock(navigationController: RootNavigationController())
        sut.coordinator = coordinator
        
        // when
        sut.deleteGame()
        
        // then
        XCTAssertEqual(coordinator.deleteGameCalledCount, 1)
    }
    
    
    // MARK: - UpdateNumberOfRounds
    
    func test_ScoreboardViewModel_WhenUpdateNumberOfRoundsCalled_ShouldUpdateGameNumberOfRoundsToValueSent() {
        // given
        let sut = getViewModelWithBasicGame()
        sut.game.numberOfRounds = 0
        
        let newNumberOfRounds = Int.random(in: 1...100)
        
        // when
        sut.updateNumberOfRounds(to: newNumberOfRounds)
        
        // then
        XCTAssertEqual(sut.game.numberOfRounds, newNumberOfRounds)
    }
    
    func test_ScoreboardViewModel_WhenUpdateNumberOfRoundsCalled_ShouldCallBindViewModelToView() {
        // given
        let sut = getViewModelWithBasicGame()
        let viewDelegate = ScoreboardViewModelViewProtocolMock()
        sut.delegate = viewDelegate
        
        let bindViewCalledCount = viewDelegate.bindViewToViewModelCalledCount
        
        // when
        sut.updateNumberOfRounds(to: 0)
        
        // then
        XCTAssertEqual(viewDelegate.bindViewToViewModelCalledCount, bindViewCalledCount + 1)
    }
    
    func test_ScoreboardViewModel_WhenUpdateNumberOfRoundsCalled_ShouldCallCoreDataStoreSaveChanges() {
        // given
        let sut = getViewModelWithBasicGame()
        let coreDataStore = CoreDataStoreMock()
        sut.coreDataStore = coreDataStore
        
        // when
        sut.updateNumberOfRounds(to: 0)
        
        // then
        XCTAssertEqual(coreDataStore.saveContextCalledCount, 1)
    }
    
    
    // MARK: - UpdateWinningScore
    
    func test_ScoreboardViewModel_WhenUpdateWinningScoreCalled_ShouldUpdateGameEndingScoreValueSent() {
        // given
        let sut = getViewModelWithBasicGame()
        sut.game.endingScore = 0
        
        let newWinningScore = Int.random(in: 1...100)
        
        // when
        sut.updateWinningScore(to: newWinningScore)
        
        // then
        XCTAssertEqual(sut.game.endingScore, newWinningScore)
    }
    
    func test_ScoreboardViewModel_WhenUpdateWinningScoreCalled_ShouldCallBindViewModelToView() {
        // given
        let sut = getViewModelWithBasicGame()
        let viewDelegate = ScoreboardViewModelViewProtocolMock()
        sut.delegate = viewDelegate
        
        let bindViewCalledCount = viewDelegate.bindViewToViewModelCalledCount
        
        // when
        sut.updateWinningScore(to: 0)
        
        // then
        XCTAssertEqual(viewDelegate.bindViewToViewModelCalledCount, bindViewCalledCount + 1)
    }
    
    func test_ScoreboardViewModel_WhenUpdateWinningScoreCalled_ShouldCallCoreDataStoreSaveChanges() {
        // given
        let sut = getViewModelWithBasicGame()
        let coreDataStore = CoreDataStoreMock()
        sut.coreDataStore = coreDataStore
        
        // when
        sut.updateWinningScore(to: 0)
        
        // then
        XCTAssertEqual(coreDataStore.saveContextCalledCount, 1)
    }
    
    
    // MARK: - SetNoEnd
    
    func test_ScoreboardViewModel_WhenSetNoEndCalled_ShouldSetGameEndTypeToNone() {
        // given
        let sut = getViewModelWithBasicGame()
        sut.game.gameEndType = .score
        
        // when
        sut.setNoEnd()
        
        // then
        XCTAssertEqual(sut.game.gameEndType, .none)
    }
    
    func test_ScoreboardViewModel_WhenSetNoEnd_ShouldCallBindViewModelToView() {
        // given
        let sut = getViewModelWithBasicGame()
        let viewDelegate = ScoreboardViewModelViewProtocolMock()
        sut.delegate = viewDelegate
        
        let bindViewCalledCount = viewDelegate.bindViewToViewModelCalledCount
        
        // when
        sut.setNoEnd()
        
        // then
        XCTAssertEqual(viewDelegate.bindViewToViewModelCalledCount, bindViewCalledCount + 1)
    }
    
    func test_ScoreboardViewModel_WhenSetNoEndCalled_ShouldCallCoreDataStoreSaveChanges() {
        // given
        let sut = getViewModelWithBasicGame()
        let coreDataStore = CoreDataStoreMock()
        sut.coreDataStore = coreDataStore
        
        // when
        sut.setNoEnd()
        
        // then
        XCTAssertEqual(coreDataStore.saveContextCalledCount, 1)
    }

    
    // MARK: - Classes
    
    class ScoreboardViewModelViewProtocolMock: NSObject, ScoreboardViewModelViewProtocol {
        var bindViewToViewModelCalledCount = 0
        func bindViewToViewModel(dispatchQueue: Whats_The_Score.DispatchQueueProtocol) {
            bindViewToViewModelCalledCount += 1
        }
    }
}
