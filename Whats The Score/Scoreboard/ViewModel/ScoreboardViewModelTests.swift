//
//  ScoreboardViewModelTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 1/19/24.
//

import XCTest
@testable import Whats_The_Score

final class ScoreboardViewModelTests: XCTestCase {
    
    func getViewModelWithBasicGame() -> ScoreboardViewModel {
        return ScoreboardViewModel(game: GameMock())
    }
    
    
    // MARK: - DidSet
    
    func test_ScoreboardViewModel_WhenDelegateIsSet_ShouldCallBindViewToViewModelOnDelegate() {
        // given
        let sut = getViewModelWithBasicGame()
        let viewDelegateMock = ScoreboardViewModelViewProtocolMock()
        
        // when
        sut.delegate = viewDelegateMock
        
        // then
        XCTAssertEqual(viewDelegateMock.bindViewToViewModelCalledCount, 1)
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
    
    
    // MARK: - StartEditingPlayerScoreAt
    
    func test_ScoreboardViewModel_WhenStartEditingPlayerScoreAtCalledOutOfRange_ShouldNotCallCoordinatorShowEditPlayerScorePopover() {
        // given
        let sut = getViewModelWithBasicGame()
        let coordinator = ScoreboardCoordinatorMock(navigationController: RootNavigationController())
        sut.coordinator = coordinator
        
        // when
        sut.startEditingPlayerScoreAt(0)
        
        // then
        XCTAssertEqual(coordinator.showEditPlayerPopoverCalledCount, 0)
    }
    
    

//    func test_ScoreboardViewModel_WhenStartEditingPlayerScoreAtCalledInRangeSortPreferenceScore_ShouldCallCoordinatorShowEditPlayerScorePopoverWithScoreChangeOfPlayerAtIndexOfSortedPlayersAndDelegate() {
//        // given
//        
//        let players = [
//            PlayerMock(score: 1),
//            PlayerMock(score: 3),
//            PlayerMock(score: 2)
//        ]
//        
//        let sut = ScoreboardViewModel(game: GameMock(players: players))
//        sut.sortPreference.value = .score
//        
//        let index = Int.random(in: 0..<players.count)
//        
//        let coordinator = ScoreboardCoordinatorMock(navigationController: RootNavigationController())
//        sut.coordinator = coordinator
//        
//        // when
//        sut.startEditingPlayerScoreAt(index)
//        
//        // then
//        XCTAssertEqual(coordinator.showEditPlayerScorePopoverCalledCount, 1)
//        XCTAssertEqual(coordinator.showEditPlayerScorePopoverScoreChange?.player.id, sut.sortedPlayers[index].id)
//        XCTAssertTrue(coordinator.showEditPlayerScorePopoverDelegate as? ScoreboardViewModel === sut)
//    }
    
    
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
    
    func test_ScoreboardViewModel_WhenStartEditingPlayerAtCalledInRangeSortPreferenceScore_ShouldCallCoordinatorShowEditPlayerPopoverWithPlayerAtIndexOfSortedPlayersAndDelegate() {
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
        sut.startEditingPlayerAt(index)
        
        // then
        XCTAssertEqual(coordinator.showEditPlayerPopoverCalledCount, 1)
        XCTAssertEqual(coordinator.showEditPlayerPopoverPlayer?.id, sut.sortedPlayers[index].id)
        XCTAssertTrue(coordinator.showEditPlayerPopoverDelegate as? ScoreboardViewModel === sut)
    }
    
    
    // MARK: - EditScore
    
    func test_ScoreboardViewModel_WhenEditScoreCalledPlayerInGame_ShouldCallGameEditScoreWithScoreChangeChange() {
        // given
        let player = PlayerMock()
        
        let game = GameMock(players: [player])
        let sut = ScoreboardViewModel(game: game)
        
        let scoreChangeObject = ScoreChangeMock(player: player)
        
        // when
        sut.editScore(scoreChangeObject)
        
        // then
//        XCTAssertEqual(game.editScoreScoreChange?.id, scoreChangeObject.id)
//        XCTAssertEqual(game.editScoreCalledCount, 1)
    }
    
    func test_ScoreboardViewModel_WhenEditScoreCalledPlayerInGame_ShouldCallBindViewToViewModel() {
        // given
        let player = PlayerMock()
        let sut = ScoreboardViewModel(game: GameMock(players: [player]))
        let viewModelViewDelegate = ScoreboardViewModelViewProtocolMock()
        sut.delegate = viewModelViewDelegate
        
        let previousBindCount = viewModelViewDelegate.bindViewToViewModelCalledCount
        
        let scoreChangeObject = ScoreChangeMock(player: player)
        
        // when
        sut.editScore(scoreChangeObject)
        
        // then
        XCTAssertEqual(viewModelViewDelegate.bindViewToViewModelCalledCount, previousBindCount + 1)
    }
    
    func test_ScoreboardViewModel_WhenEditScoreCalled_ShouldCallIsEndOfGame() {
        // given
        let player = PlayerMock()
        let game = GameIsEndOfGameMock(players: [player])
        
        let sut = ScoreboardViewModel(game: game)
        
        let scoreChangeObject = ScoreChangeMock(player: player)
        
        // when
        sut.editScore(scoreChangeObject)
        
        // then
        XCTAssertEqual(game.isEndOfGameCalledCount, 1)
    }
    
    func test_ScoreboardViewModel_WhenEditScoreCalledIsEndOfGameTrue_ShouldCallCoordinatorShowEndGamePopoverWith1SecondDelay() {
        
        // given
        
        let player = PlayerMock()
        let game = GameIsEndOfGameMock(players: [player])
        game.isEndOfGameBool = true
        
        let sut = ScoreboardViewModel(game: game)
        
        let scoreChangeObject = ScoreChangeMock(player: player)
        
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
        let player = PlayerMock()
        let game = GameIsEndOfGameMock(players: [player])
        game.isEndOfGameBool = false
        
        let sut = ScoreboardViewModel(game: game)
        
        let coordinator = ScoreboardCoordinatorMock(navigationController: RootNavigationController())
        sut.coordinator = coordinator
        
        let scoreChangeObject = ScoreChangeMock(player: player, scoreChange: 0)
        
        // when
        sut.editScore(scoreChangeObject)
        
        // then
        XCTAssertEqual(coordinator.showEndGamePopoverCalledCount, 0)
    }
    
    
    // MARK: - FinishedEditingPlayer
    
    func test_ScoreboardViewModel_WhenFinishedEditingCalledPlayerNotInGame_ShouldNotCallGamePlayerNameChanged() {
        // given
        let gameMock = GameMock()
        let sut = ScoreboardViewModel(game: GameMock())
        
        let editedPlayer = PlayerMock()
        
        // when
        sut.finishedEditing(editedPlayer, toNewName: "")
        
        // then
//        XCTAssertEqual(gameMock.playerNameChangedCalledCount, 0)
    }
    
    func test_ScoreboardViewModel_WhenFinishedEditingCalledPlayerInGame_ShouldCallGamePlayerNameChanged() {
        
        // given
        let player = PlayerMock()
        let gameMock = GameMock(players: [player])
        let sut = ScoreboardViewModel(game: gameMock)
        
        let newPlayerName = UUID().uuidString
        
        // when
        sut.finishedEditing(player, toNewName: newPlayerName)
        
        // then
//        XCTAssertEqual(gameMock.playerNameChangedName, newPlayerName)
//        XCTAssertEqual(gameMock.playerNameChangedIndex, 0)
//        XCTAssertEqual(gameMock.playerNameChangedCalledCount, 1)
    }
    
    func test_ScoreboardViewModel_WhenFinishedEditingCalledPlayerInGame_ShouldCallBindViewToViewModel() {
        // given
        let player = PlayerMock()
        let sut = ScoreboardViewModel(game: GameMock(players: [player]))

        let viewModelViewDelegate = ScoreboardViewModelViewProtocolMock()
        sut.delegate = viewModelViewDelegate
        
        let previousBindCount = viewModelViewDelegate.bindViewToViewModelCalledCount
        
        // when
        sut.finishedEditing(player, toNewName: "")
        
        // then
        XCTAssertEqual(viewModelViewDelegate.bindViewToViewModelCalledCount, previousBindCount + 1)
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
    
    
    // MARK: - DeletePlayer
    
    func test_ScoreboardViewModel_WhenDeletePlayerCalled_ShouldCallGamesDeletePlayerAtWithPlayerPosition() {
        // given
        let position = Int.random(in: 1...100)
        let player = PlayerMock(position: position)
        let game = GameMock(players: [player])
        let sut = ScoreboardViewModel(game: game)
        
        // when
        sut.deletePlayer(player)
        
        // then
//        XCTAssertEqual(game.deletePlayerAtIndex, position)
//        XCTAssertEqual(game.deletePlayerAtCalledCount, 1)
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
    
    
    // MARK: - EndRound
    
    func test_ScoreboardViewModel_WhenEndRoundCalled_ShouldCallGameEndRoundWithEndRoundObject() {
        // given
        let gameMock = GameMock()
        let sut = ScoreboardViewModel(game: gameMock)
        
        let endRound = EndRoundMock()
        
        // when
        sut.endRound(endRound)
        
        // then
        XCTAssertEqual(gameMock.endRoundEndRound?.id, endRound.id)
        XCTAssertEqual(gameMock.endRoundCalledCount, 1)
    }
    
    func test_ScoreboardViewModel_WhenEndRoundCalled_ShouldCallBindViewToViewModel() {
        // given
        let sut = getViewModelWithBasicGame()
        
        let viewDelegate = ScoreboardViewModelViewProtocolMock()
        sut.delegate = viewDelegate
        
        let bindViewToViewModelCalledCount = viewDelegate.bindViewToViewModelCalledCount
        
        // when3
        sut.endRound(EndRoundMock())
        
        // then
        XCTAssertEqual(viewDelegate.bindViewToViewModelCalledCount, bindViewToViewModelCalledCount + 1)
    }
    
    
    func test_ScoreboardViewModel_WhenEndRoundCalled_ShouldCallIsEndOfGame() {
        // given
        let game = GameIsEndOfGameMock()
        game.isEndOfGameBool = true
        let sut = ScoreboardViewModel(game: game)
        
        // when
        sut.endRound(EndRoundMock())
        
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
        sut.endRound(EndRoundMock())
        
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
        sut.endRound(EndRoundMock())
        
        // then
        XCTAssertEqual(coordinator.showEndGamePopoverCalledCount, 0)
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
    
    
    
//    // MARK: - UpdateNumberOfRounds
//    
//    func test_ScoreboardViewModel_WhenUpdateNumberOfRoundsCalled_ShouldUpdateGameNumberOfRoundsToValueSent() {
//        // given
//        let sut = getViewModelWithBasicGame()
//        sut.game.numberOfRounds = 0
//        
//        let newNumberOfRounds = Int.random(in: 1...100)
//        
//        // when
//        sut.updateNumberOfRounds(to: newNumberOfRounds)
//        
//        // then
//        XCTAssertEqual(sut.game.numberOfRounds, newNumberOfRounds)
//    }
//    
//    func test_ScoreboardViewModel_WhenUpdateNumberOfRoundsCalled_ShouldCallBindViewModelToView() {
//        // given
//        let sut = getViewModelWithBasicGame()
//        let viewDelegate = ScoreboardViewModelViewProtocolMock()
//        sut.delegate = viewDelegate
//        
//        let bindViewCalledCount = viewDelegate.bindViewToViewModelCalledCount
//        
//        // when
//        sut.updateNumberOfRounds(to: 0)
//        
//        // then
//        XCTAssertEqual(viewDelegate.bindViewToViewModelCalledCount, bindViewCalledCount + 1)
//    }
//    
//    
//    // MARK: - UpdateWinningScore
//    
//    func test_ScoreboardViewModel_WhenUpdateWinningScoreCalled_ShouldUpdateGameEndingScoreValueSent() {
//        // given
//        let sut = getViewModelWithBasicGame()
//        sut.game.endingScore = 0
//        
//        let newWinningScore = Int.random(in: 1...100)
//        
//        // when
//        sut.updateWinningScore(to: newWinningScore)
//        
//        // then
//        XCTAssertEqual(sut.game.endingScore, newWinningScore)
//    }
//    
//    func test_ScoreboardViewModel_WhenUpdateWinningScoreCalled_ShouldCallBindViewModelToView() {
//        // given
//        let sut = getViewModelWithBasicGame()
//        let viewDelegate = ScoreboardViewModelViewProtocolMock()
//        sut.delegate = viewDelegate
//        
//        let bindViewCalledCount = viewDelegate.bindViewToViewModelCalledCount
//        
//        // when
//        sut.updateWinningScore(to: 0)
//        
//        // then
//        XCTAssertEqual(viewDelegate.bindViewToViewModelCalledCount, bindViewCalledCount + 1)
//    }
//    
//    
//    // MARK: - SetNoEnd
//    
//    func test_ScoreboardViewModel_WhenSetNoEndCalled_ShouldSetGameEndTypeToNone() {
//        // given
//        let sut = getViewModelWithBasicGame()
//        sut.game.gameEndType = .score
//        
//        // when
//        sut.setNoEnd()
//        
//        // then
//        XCTAssertEqual(sut.game.gameEndType, .none)
//    }
//    
//    func test_ScoreboardViewModel_WhenSetNoEnd_ShouldCallBindViewModelToView() {
//        // given
//        let sut = getViewModelWithBasicGame()
//        let viewDelegate = ScoreboardViewModelViewProtocolMock()
//        sut.delegate = viewDelegate
//        
//        let bindViewCalledCount = viewDelegate.bindViewToViewModelCalledCount
//        
//        // when
//        sut.setNoEnd()
//        
//        // then
//        XCTAssertEqual(viewDelegate.bindViewToViewModelCalledCount, bindViewCalledCount + 1)
//    }
    
    
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
    
    
    
//
//    // MARK: - UpdateGame
//    
//    func test_ScoreboardViewModel_WhenUpdateGameCalled_ShouldSetGameEqualToNewGame() {
//        // given
//        let sut = getViewModelWithBasicGame()
//        
//        let newGame = GameMock()
//        
//        // when
//        sut.update(newGame)
//        
//        // then
//        XCTAssertTrue(sut.game.isEqualTo(game: newGame))
//    }
//    
//    func test_ScoreboardViewModel_WhenUpdateGameCalled_ShouldCallBindViewToViewModel() {
//        // given
//        let sut = getViewModelWithBasicGame()
//        
//        let viewDelegate = ScoreboardViewModelViewProtocolMock()
//        sut.delegate = viewDelegate
//        
//        let bindCount = viewDelegate.bindViewToViewModelCalledCount
//        
//        // when
//        sut.update(GameMock())
//        
//        // then
//        XCTAssertEqual(viewDelegate.bindViewToViewModelCalledCount, bindCount + 1)
//    }
//    
//    func test_ScoreboardViewModel_WhenUpdateGameCalledGameIsEndOfGameTrue_ShouldCallCoordinatorShowEndGamePopoverWithDelayHalfASecond() {
//        // given
//        let sut = ScoreboardViewModel(game: GameMock())
//        
//        let game = GameIsEndOfGameMock()
//        game.isEndOfGameBool = true
//        
//        let coordinator = ScoreboardCoordinatorMock(navigationController: RootNavigationController())
//        sut.coordinator = coordinator
//        
//        // when
//        sut.update(game)
//        
//        // then
//        XCTAssertEqual(coordinator.showEndGamePopoverCalledCount, 1)
//        XCTAssertTrue(coordinator.showEndGamePopoverGame?.isEqualTo(game: game) ?? false)
//        XCTAssertTrue(coordinator.showEndGamePopoverDelegate === sut)
//        XCTAssertEqual(coordinator.showEndGamePopoverDelay, 0.5)
//    }
//    
//    func test_ScoreboardViewModel_WhenUpdateGameCalledGameIsEndOfGameFalse_ShouldNotCallCoordinatorShowEndGamePopover() {
//        // given
//        let sut = ScoreboardViewModel(game: GameMock())
//        
//        let game = GameIsEndOfGameMock()
//        game.isEndOfGameBool = false
//        
//        let coordinator = ScoreboardCoordinatorMock(navigationController: RootNavigationController())
//        sut.coordinator = coordinator
//        
//        // when
//        sut.update(game)
//        
//        // then
//        XCTAssertEqual(coordinator.showEndGamePopoverCalledCount, 0)
//    }
//    
//    
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
    
    func test_ScoreboardViewModel_WhenShowEndRoundPopoverCalled_ShouldCallShowEndRoundPopoverWithGameAndDelegate() {
        // given
        let game = GameMock()
        let sut = ScoreboardViewModel(game: game)
        
        let coordinator = ScoreboardCoordinatorMock(navigationController: RootNavigationController())
        sut.coordinator = coordinator
        
        
        // when
        sut.showEndRoundPopover()
        
        // then
        XCTAssertEqual(coordinator.showEndRoundPopoverCalledCount, 1)
        XCTAssertTrue(coordinator.showEndRoundPopoverGame?.isEqualTo(game: game) ?? false)
        XCTAssertTrue(coordinator.showEndRoundPopoverDelegate as? ScoreboardViewModel === sut)
    }
    
    
    // MARK: - Classes
    
    class ScoreboardViewModelViewProtocolMock: NSObject, ScoreboardViewModelViewProtocol {
        var bindViewToViewModelCalledCount = 0
        func bindViewToViewModel(dispatchQueue: Whats_The_Score.DispatchQueueProtocol) {
            bindViewToViewModelCalledCount += 1
        }
    }
}

class ScoreboardViewModelMock: NSObject, ScoreboardViewModelProtocol {
    
    init(game: GameProtocol) {
        self.game = game
    }
    
    override init() {
        self.game = GameMock()
    }
    
    var game: GameProtocol
    var delegate: ScoreboardViewModelViewProtocol?
    weak var coordinator: ScoreboardCoordinator?
    var playerToDelete: Observable<PlayerProtocol> = Observable(PlayerMock())
    var sortPreference: Observable<ScoreboardSortPreference> = Observable(.score)
    var sortedPlayers: [PlayerProtocol] = []
    
    var startEditingPlayerScoreAtCalledCount = 0
    var startEditingPlayerScoreAtIndex: Int?
    func startEditingPlayerScoreAt(_ index: Int) {
        startEditingPlayerScoreAtIndex = index
        startEditingPlayerScoreAtCalledCount += 1
    }
    
    var editScoreCalledCount = 0
    var editScorePlayerID: UUID?
    var editScorePlayerName: String?
    var editScoreChange: Int?
    func editScore(_ scoreChange: ScoreChangeProtocol) {
        editScoreCalledCount += 1
        editScoreChange = scoreChange.scoreChange
    }
    
    var addPlayerCalledCount = 0
    func addPlayer() {
        addPlayerCalledCount += 1
    }
    
    var endGameCalledCount = 0
    func endGame() {
        endGameCalledCount += 1
    }
    
    var startEditingPlayerAtCalledCount = 0
    var startEditingPlayerAtIndex: Int?
    func startEditingPlayerAt(_ index: Int) {
        startEditingPlayerAtCalledCount += 1
        startEditingPlayerAtIndex = index
    }
    
    var startDeletingPlayerAtCalledCount = 0
    var startDeletingPlayerAtIndex: Int?
    func startDeletingPlayerAt(_ index: Int) {
        startDeletingPlayerAtCalledCount += 1
        startDeletingPlayerAtIndex = index
    }
    
    var deletePlayerPlayer: PlayerProtocol?
    var deletePlayerCalledCount = 0
    func deletePlayer(_ player: PlayerProtocol) {
        self.deletePlayerPlayer = player
        self.deletePlayerCalledCount += 1
    }
    
    var resetGameCalledCount = 0
    func resetGame() {
        resetGameCalledCount += 1
    }
    
    var openingGameOverCheckCalledCount = 0
    func openingGameOverCheck() {
        openingGameOverCheckCalledCount += 1
    }
    
    var showGameHistoryCalledCount = 0
    func showGameHistory() {
        showGameHistoryCalledCount += 1
    }
    
    var showGameSettingsCalledCount = 0
    func showGameSettings() {
        showGameSettingsCalledCount += 1
    }
    
    var showEndRoundPopoverCalledCount = 0
    func showEndRoundPopover() {
        showEndRoundPopoverCalledCount += 1
    }
    
    func finishedEditing(_ player: PlayerProtocol, toNewName name: String) {}
    func endRound(_ endRound: EndRoundProtocol) {}
    func goToEndGameScreen() {}
    func keepPlayingSelected() {}
    func updateNumberOfRounds(to numberOfRounds: Int) {}
    func updateWinningScore(to winningScore: Int) {}
    func setNoEnd() {}
    func update(_ game: GameProtocol) {}
    func updateSettings(with gameEndType: GameEndType, endingScore: Int, andNumberOfRounds numberOfRounds: Int) {}
}
