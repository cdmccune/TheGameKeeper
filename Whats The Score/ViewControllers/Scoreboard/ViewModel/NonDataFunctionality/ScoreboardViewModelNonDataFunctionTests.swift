//
//  ScoreboardViewModelNonDataFunctionTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 4/9/24.
//

import XCTest
@testable import Whats_The_Score

final class ScoreboardViewModelNonDataFunctionTests: XCTestCase {

  
    func getViewModelWithBasicGame() -> ScoreboardViewModel {
        return ScoreboardViewModel(game: GameMock())
    }
    
    
    // MARK: - SortedPlayers
    
    func test_ScoreboardViewModel_WhenSortPreferenceIsScore_ShouldReturnPlayersSortedByScore() {
        // given
        let sut = getViewModelWithBasicGame()
        sut.sortPreference.value = .score
        var players = [PlayerProtocol]()
        for _ in 0...Int.random(in: 5...10) {
            players.append(PlayerMock(score: Int.random(in: -1000...1000)))
        }
        sut.game = GameMock(players: players)
        
        // when
        let viewModelSortedPlayers = sut.sortedPlayers
        let actualSortedPlayers = players.sorted { $0.score > $1.score }
        
        // then
        viewModelSortedPlayers.enumerated().forEach { (index, player) in
            XCTAssertEqual(actualSortedPlayers[index].id, player.id)
        }
    }
    
    func test_ScoreboardViewModel_WhenSortPreferenceIsTurn_ShouldReturnPlayersSortedByTurn() {
        // given
        let sut = getViewModelWithBasicGame()
        sut.sortPreference.value = .position
        var players = [PlayerProtocol]()
        for _ in 0...Int.random(in: 5...10) {
            players.append(PlayerMock(position: Int.random(in: -1000...1000)))
        }
        sut.game = GameMock(players: players)
        
        // when
        let viewModelSortedPlayers = sut.sortedPlayers
        let actualSortedPlayers = players.sorted { $0.position < $1.position }
        
        // then
        viewModelSortedPlayers.enumerated().forEach { (index, player) in
            XCTAssertEqual(actualSortedPlayers[index].id, player.id)
        }
    }
    
    func test_ScoreboardViewModel_WhenSortPreferenceIsScoreLowestIsWinning_ShouldReturnPlayersSortedByInvertedScore() {
        // given
        let sut = getViewModelWithBasicGame()
        sut.sortPreference.value = .score
        var players = [PlayerProtocol]()
        for _ in 0...Int.random(in: 5...10) {
            players.append(PlayerMock(score: Int.random(in: -1000...1000)))
        }
        sut.game = GameMock(players: players)
        sut.game.lowestIsWinning = true
        
        // when
        let viewModelSortedPlayers = sut.sortedPlayers
        let actualInvertedSortedPlayers = players.sorted { $0.score < $1.score }
        
        // then
        viewModelSortedPlayers.enumerated().forEach { (index, player) in
            XCTAssertEqual(actualInvertedSortedPlayers[index].id, player.id)
        }
    }
    
    
    // MARK: - AddPlayer
    
    func test_ScoreboardViewModel_WhenAddPlayerCalled_ShouldCallCoordinatorShowEditPlayerPopoverWithSelfAsDelegate() {
        let sut = getViewModelWithBasicGame()
        let coordinator = ScoreboardCoordinatorMock(navigationController: RootNavigationController())
        sut.coordinator = coordinator
        
        // when
        sut.addPlayer()
        
        // then
        XCTAssertEqual(coordinator.showEditPlayerPopoverCalledCount, 1)
        XCTAssertIdentical(coordinator.showEditPlayerPopoverDelegate, sut)
    }
    
    func test_ScoreboardViewModel_WhenAddPlayerCalled_ShouldCallCoordinatorShowEditPlayerPopoverWithPlayerWithUnusedIcon() {
        let game = GameMock()
        let sut = ScoreboardViewModel(game: game)
        let coordinator = ScoreboardCoordinatorMock(navigationController: RootNavigationController())
        sut.coordinator = coordinator
        
        let icons = PlayerIcon.allCases
        var playerArray = [PlayerMock]()
        for icon in icons {
            playerArray.append(PlayerMock(icon: icon))
        }
        
        let randomPlayer = playerArray.randomElement()
        playerArray.removeAll { $0 == randomPlayer }
        game.players = playerArray
        
        // when
        sut.addPlayer()
        
        // then
        XCTAssertEqual(coordinator.showEditPlayerPopoverPlayer?.icon, randomPlayer?.icon)
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
    
    
    // MARK: - StartEditingPlayerScoreAt
    
    func test_ScoreboardViewModel_WhenStartEditingPlayerScoreAtCalledOutOfRange_ShouldNotCallCoordinatorShowEditPlayerScorePopover() {
        // given
        let sut = getViewModelWithBasicGame()
        let coordinator = ScoreboardCoordinatorMock(navigationController: RootNavigationController())
        sut.coordinator = coordinator
        
        // when
        sut.startEditingPlayerScoreAt(0)
        
        // then
        XCTAssertEqual(coordinator.showEditPlayerScorePopoverCalledCount, 0)
    }
    
    
    func test_ScoreboardViewModel_WhenStartEditingPlayerScoreAtCalledInRangeSortPreferenceScore_ShouldCallCoordinatorShowEditPlayerScorePopoverWithScoreChangeOfPlayerAtIndexOfSortedPlayersAndDelegate() {
        // given
        
        let players = [
            PlayerMock(score: 1),
            PlayerMock(score: 3),
            PlayerMock(score: 2)
        ]
        
        let sut = ScoreboardViewModel(game: GameMock(players: players))
        sut.sortPreference.value = .score
        
        let index = Int.random(in: 0..<players.count)
        
        let coordinator = ScoreboardCoordinatorMock(navigationController: RootNavigationController())
        sut.coordinator = coordinator
        
        // when
        sut.startEditingPlayerScoreAt(index)
        
        // then
        XCTAssertEqual(coordinator.showEditPlayerScorePopoverCalledCount, 1)
        XCTAssertEqual(coordinator.showEditPlayerScorePopoverScoreChange?.player.id, sut.sortedPlayers[index].id)
        XCTAssertTrue(coordinator.showEditPlayerScorePopoverDelegate as? ScoreboardViewModel === sut)
    }
    
    
    // MARK: - StartEditingPlayerAt
    
    func test_ScoreboardViewModel_WhenStartEditingPlayerAtCalledOutOfRange_ShouldNotCallCoordinatorShowEditPlayerPopover() {
        // given
        let sut = getViewModelWithBasicGame()
        let coordinator = ScoreboardCoordinatorMock(navigationController: RootNavigationController())
        sut.coordinator = coordinator
        
        // when
        sut.startEditingPlayerAt(0)
        
        // then
        XCTAssertEqual(coordinator.showEditPlayerPopoverCalledCount, 0)
    }
    
    func test_ScoreboardViewModel_WhenStartEditingPlayerAtCalledInRangeSortPreferenceScore_ShouldCallCoordinatorShowEditPlayerPopoverWithPlayerAtIndexOfSortedPlayersWithNameIconAndIDAndDelegate() {
        // given
        
        let players = [
            PlayerMock(name: UUID().uuidString, score: 1, icon: PlayerIcon.allCases.randomElement()!),
            PlayerMock(name: UUID().uuidString, score: 3, icon: PlayerIcon.allCases.randomElement()!),
            PlayerMock(name: UUID().uuidString, score: 2, icon: PlayerIcon.allCases.randomElement()!)
        ]
        
        let sut = ScoreboardViewModel(game: GameMock(players: players))
        sut.sortPreference.value = .score
        
        let index = Int.random(in: 0..<players.count)
        
        let coordinator = ScoreboardCoordinatorMock(navigationController: RootNavigationController())
        sut.coordinator = coordinator
        
        // when
        sut.startEditingPlayerAt(index)
        
        // then
        XCTAssertEqual(coordinator.showEditPlayerPopoverCalledCount, 1)
        XCTAssertEqual(coordinator.showEditPlayerPopoverPlayer?.id, sut.sortedPlayers[index].id)
        XCTAssertEqual(coordinator.showEditPlayerPopoverPlayer?.name, sut.sortedPlayers[index].name)
        XCTAssertEqual(coordinator.showEditPlayerPopoverPlayer?.icon, sut.sortedPlayers[index].icon)
        XCTAssertTrue(coordinator.showEditPlayerPopoverDelegate as? ScoreboardViewModel === sut)
    }
    
    
    // MARK: - StartDeletingPlayerAt
    
    func test_ScoreboardViewModel_WhenStartDeletingPlayerAtCalledOutOfRange_ShouldNotSetPlayerToDelete() {
        // given
        let sut = getViewModelWithBasicGame()
        
        // when
        sut.startDeletingPlayerAt(0)
        
        // then
        XCTAssertNil(sut.playerToDelete.value)
    }
    
    func test_ScoreboardViewModel_WhenStartDeletingPlayerAtCalledInRange_ShouldSetPlayerToDelete() {
        // given
        let player = PlayerMock()
        let sut = ScoreboardViewModel(game: GameMock(players: [player]))
        
        // when
        sut.startDeletingPlayerAt(0)
        
        // then
        XCTAssertEqual(sut.playerToDelete.value?.id, player.id)
    }
    
    
    // MARK: - openingGameOverCheck
    
    func test_ScoreboardViewModel_WhenOpeningGameOverCheckCalledGameIsEndOfGameTrue_ShouldCallCoordinatorShowKeepPlayingPopoverWithHalfSecondDelay() {
        // given
        let sut = getViewModelWithBasicGame()
        let game = GameIsEndOfGameMock()
        game.isEndOfGameBool = true
        sut.game = game
        
        let coordinator = ScoreboardCoordinatorMock(navigationController: RootNavigationController())
        sut.coordinator = coordinator
        
        // when
        sut.openingGameOverCheck()
        
        // then
        XCTAssertEqual(coordinator.showKeepPlayingPopoverCalledCount, 1)
        XCTAssertTrue(coordinator.showKeepPlayingPopoverGame?.isEqualTo(game: game) ?? false)
        XCTAssertTrue(coordinator.showKeepPlayingPopoverDelegate === sut)
        XCTAssertEqual(coordinator.showKeepPlayingPopoverDelay, 0.5)
    }
    
    func test_ScoreboardViewModel_WhenOpeningGameOverCheckCalledGameIsEndOfGameFalse_ShouldNotCallCoordinatorShowKeepPlayingPopover() {
        // given
        let sut = getViewModelWithBasicGame()
        let game = GameIsEndOfGameMock()
        game.isEndOfGameBool = false
        sut.game = game
        
        let coordinator = ScoreboardCoordinatorMock(navigationController: RootNavigationController())
        sut.coordinator = coordinator
        
        // when
        sut.openingGameOverCheck()
        
        // then
        XCTAssertEqual(coordinator.showKeepPlayingPopoverCalledCount, 0)
    }
    
    
    // MARK: - ShowGameHistory
    
    func test_ScoreboardViewModel_WhenShowGameHistoryCalled_ShouldCallCoordinatorShowGameHistoryWithGameAndDelegateAsSelf() {
        // given
        let game = GameMock()
        let sut = ScoreboardViewModel(game: game)
        let coordinator = ScoreboardCoordinatorMock(navigationController: RootNavigationController())
        sut.coordinator = coordinator
        
        // when
        sut.showGameHistory()
        
        // then
        XCTAssertEqual(coordinator.showGameHistoryCalledCount, 1)
        XCTAssertTrue(coordinator.showGameHistoryGame?.isEqualTo(game: game) ?? false)
        XCTAssertTrue(coordinator.showGameHistoryDelegate as? ScoreboardViewModel === sut)
    }
    
    
    // MARK: - ShowGameSettings
    
    func test_ScoreboardViewModel_WhenShowGameSettingsCalled_ShouldCallShowSettingsOnCoordinatorWithGameAndDelegateAsSelf() {
        // given
        let game = GameMock()
        let sut = ScoreboardViewModel(game: game)
        let coordinator = ScoreboardCoordinatorMock(navigationController: RootNavigationController())
        sut.coordinator = coordinator
        
        // when
        sut.showGameSettings()
        
        // then
        XCTAssertEqual(coordinator.showSettingsCalledCount, 1)
        XCTAssertTrue(coordinator.showSettingsGame?.isEqualTo(game: game) ?? false)
        XCTAssertTrue(coordinator.showSettingsDelegate as? ScoreboardViewModel === sut)
    }
    
    
    // MARK: - ShowEndRoundPopover
    
    func test_ScoreboardViewModel_WhenShowEndRoundPopoverCalled_ShouldCallCoordinatorShowEndRoundPopoverWithSelfAsDelegate() {
        // given
        let game = GameMock()
        let sut = ScoreboardViewModel(game: game)
        
        let coordinator = ScoreboardCoordinatorMock(navigationController: RootNavigationController())
        sut.coordinator = coordinator
        
        
        // when
        sut.showEndRoundPopover()
        
        // then
        XCTAssertEqual(coordinator.showEndRoundPopoverCalledCount, 1)
        XCTAssertTrue(coordinator.showEndRoundPopoverDelegate as? ScoreboardViewModel === sut)
    }
    
    func test_ScoreboardViewModel_WhenShowEndRoundPopoverCalled_ShouldCallCoordinatorShowEndRoundPopoverWithEndRoundWithScoreChangesOfGamePlayers() {
        // given
        
        let players = [
            PlayerMock(),
            PlayerMock(),
            PlayerMock()
        ]
        let game = GameMock(players: players)
        let sut = ScoreboardViewModel(game: game)
        
        let coordinator = ScoreboardCoordinatorMock(navigationController: RootNavigationController())
        sut.coordinator = coordinator
        
        // when
        sut.showEndRoundPopover()
        
        // then
        let endRoundSettings = coordinator.showEndRoundPopoverEndRound
        
        for (index, player) in players.enumerated() {
            XCTAssertEqual(endRoundSettings?.scoreChangeSettingsArray[index].player.id, player.id)
        }
    }
    
    func test_ScoreboardViewModel_WhenShowEndRoundPopoverCalled_ShouldCallCoordintatorShowEndRoundPopoverWithEndROundSettingsRoundNumberEqaulToGameCurrentRound() {
        // given
        let round = Int.random(in: 1...10)
        let sut = ScoreboardViewModel(game: GameMock(currentRound: round))
        
        let coordinator = ScoreboardCoordinatorMock(navigationController: RootNavigationController())
        sut.coordinator = coordinator
        
        // when
        sut.showEndRoundPopover()
        
        // then
        XCTAssertEqual(coordinator.showEndRoundPopoverEndRound?.roundNumber, round)
    }
    
    
    // MARK: - GoToEndGameScreen
    
    func test_ScoreboardViewModel_WhenGoToEndGameScreenCalled_ShouldCallCoordinatorGoToEndGameScreenWithHalfSecondDelay() {
        // given
        let game = GameMock()
        let sut = ScoreboardViewModel(game: game)
        
        let coordinator = ScoreboardCoordinatorMock(navigationController: RootNavigationController())
        sut.coordinator = coordinator
        
        // when
        sut.goToEndGameScreen()
        
        // then
        XCTAssertEqual(coordinator.showEndGameScreenCalledCount, 1)
        XCTAssertEqual(coordinator.showEndGameScreenDelay, 0.5)
        XCTAssertTrue(coordinator.showEndGameScreenGame?.isEqualTo(game: game) ?? false)
    }
    
    
    // MARK: - EndGame
    
    func test_ScoreboardViewModel_WhenEndGameCalled_ShouldCallCoordinatorShowEndGameWithGameAndDelegate() {
        // given
        let game = GameMock()
        let sut = ScoreboardViewModel(game: game)
        let coordinator = ScoreboardCoordinatorMock(navigationController: RootNavigationController())
        sut.coordinator = coordinator
        
        // when
        sut.endGame()
        
        // then
        XCTAssertEqual(coordinator.showEndGamePopoverCalledCount, 1)
        XCTAssertTrue(coordinator.showEndGamePopoverGame?.isEqualTo(game: game) ?? false)
        XCTAssertTrue(coordinator.showEndGamePopoverDelegate as? ScoreboardViewModel === sut)
    }
    
    
    // MARK: - KeepPlayingSelected
    
    func test_ScoreboardViewModel_WhenKeepPlayingSelectedCalledIsEndOfGameFalse_ShouldNotCallCoordinatorShowKeepPlayingPopover() {
        // given
        let sut = getViewModelWithBasicGame()
        let game = GameIsEndOfGameMock()
        game.isEndOfGameBool = false
        sut.game = game
        
        let coordinator = ScoreboardCoordinatorMock(navigationController: RootNavigationController())
        sut.coordinator = coordinator
        
        // when
        sut.keepPlayingSelected()
        
        // then
        XCTAssertEqual(coordinator.showKeepPlayingPopoverCalledCount, 0)
    }
    
    func test_ScoreboardViewModel_WhenKeepPlayingSelectedCalledIsEndOfGameTrue_ShouldCallCoordinatorShowKeepPlayingPopoverWithHalfSecondDelay() {
        // given
        let game = GameIsEndOfGameMock()
        game.isEndOfGameBool = true
        let sut = ScoreboardViewModel(game: game)
        
        let coordinator = ScoreboardCoordinatorMock(navigationController: RootNavigationController())
        sut.coordinator = coordinator
        
        // when
        sut.keepPlayingSelected()
        
        // then
        XCTAssertEqual(coordinator.showKeepPlayingPopoverCalledCount, 1)
        XCTAssertEqual(coordinator.showKeepPlayingPopoverDelay, 0.5)
        XCTAssertTrue(coordinator.showKeepPlayingPopoverGame?.isEqualTo(game: game) ?? false)
        XCTAssertTrue(coordinator.showKeepPlayingPopoverDelegate === sut)
    }
    
    
    // MARK: - UpdateFromHistory
    
    func test_ScoreboardViewModel_WhenUpdateFromHistoryCalled_ShouldCallBindViewToViewModel() {
        // given
        let sut = getViewModelWithBasicGame()
        
        let viewDelegate = ScoreboardViewModelViewProtocolMock()
        sut.delegate = viewDelegate
        
        let bindCount = viewDelegate.bindViewToViewModelCalledCount
        
        // when
        sut.updateFromHistory()
        
        // then
        XCTAssertEqual(viewDelegate.bindViewToViewModelCalledCount, bindCount + 1)
    }
    
    func test_ScoreboardViewModel_WhenUpdateFromHistoryCalledGameIsEndOfGameTrue_ShouldCallCoordinatorShowEndGamePopoverWithDelayHalfASecond() {
        // given
        
        let game = GameIsEndOfGameMock()
        game.isEndOfGameBool = true
        let sut = ScoreboardViewModel(game: game)
        
        let coordinator = ScoreboardCoordinatorMock(navigationController: RootNavigationController())
        sut.coordinator = coordinator
        
        // when
        sut.updateFromHistory()
        
        // then
        XCTAssertEqual(coordinator.showEndGamePopoverCalledCount, 1)
        XCTAssertTrue(coordinator.showEndGamePopoverGame?.isEqualTo(game: game) ?? false)
        XCTAssertTrue(coordinator.showEndGamePopoverDelegate === sut)
        XCTAssertEqual(coordinator.showEndGamePopoverDelay, 0.5)
    }
    
    
    // MARK: - Classes
    
    class ScoreboardViewModelViewProtocolMock: NSObject, ScoreboardViewModelViewProtocol {
        var bindViewToViewModelCalledCount = 0
        func bindViewToViewModel(dispatchQueue: Whats_The_Score.DispatchQueueProtocol?) {
            bindViewToViewModelCalledCount += 1
        }
    }
}
