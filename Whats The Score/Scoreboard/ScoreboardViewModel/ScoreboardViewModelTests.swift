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
        return ScoreboardViewModel(game: Game(basicGameWithPlayers: []))
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
        var players = [Player]()
        for _ in 0...Int.random(in: 5...10) {
            players.append(Player(name: "",
                                  position: Int.random(in: -1000...1000),
                                  score: Int.random(in: -1000...1000)))
        }
        sut.game.players = players
        
        // when
        let viewModelSortedPlayers = sut.sortedPlayers
        let actualSortedPlayers = players.sorted { $0.score > $1.score }
        
        // then
        XCTAssertEqual(viewModelSortedPlayers, actualSortedPlayers)
    }
    
    func test_ScoreboardViewModel_WhenSortPreferenceIsTurn_ShouldReturnPlayersSortedByTurn() {
        // given
        let sut = getViewModelWithBasicGame()
        sut.sortPreference.value = .position
        var players = [Player]()
        for _ in 0...Int.random(in: 5...10) {
            players.append(Player(name: "",
                                  position: Int.random(in: -1000...1000),
                                  score: Int.random(in: -1000...1000)))
        }
        sut.game.players = players
        
        // when
        let viewModelSortedPlayers = sut.sortedPlayers
        let actualSortedPlayers = players.sorted { $0.position < $1.position }
        
        // then
        XCTAssertEqual(viewModelSortedPlayers, actualSortedPlayers)
    }
    
    
    // MARK: - StartEditingPlayerScoreAt
    
    func test_ScoreboardViewModel_WhenStartEditingPlayerScoreAtCalledOutOfRange_ShouldNotSetValueOfPlayerToEditScore() {
        // given
        let sut = getViewModelWithBasicGame()
        sut.game.players = []
        sut.playerToEditScore.value = nil
        
        // when
        sut.startEditingPlayerScoreAt(0)
        
        // then
        XCTAssertNil(sut.playerToEditScore.value)
    }
    
    func test_ScoreboardViewModel_WhenStartEditingPlayerScoreAtCalledWhenReorderedByScore_ShouldSetCorrectPlayerAsPlayerToEditScore() {
        
        // given
        let sut = getViewModelWithBasicGame()
        sut.sortPreference.value = .score
        var players = Array(repeating: Player(name: "", position: 0), count: 5)
        players[3].score = 1
        sut.game.players = players
        
        // when
        sut.startEditingPlayerScoreAt(0)
        
        // then
        XCTAssertEqual(sut.playerToEditScore.value, players[3])
    }
    
    
    // MARK: - StartEditingPlayerAt
    
    func test_ScoreboardViewModel_WhenStartEditingPlayerAtCalledOutOfRange_ShouldNotSetValueOfPlayerToEditScore() {
        // given
        let sut = getViewModelWithBasicGame()
        sut.game.players = []
        sut.playerToEdit.value = nil
        
        // when
        sut.startEditingPlayerAt(0)
        
        // then
        XCTAssertNil(sut.playerToEdit.value)
    }
    
    func test_ScoreboardViewModel_WhenStartEditingPlayerAtCalledWhenReorderedByScore_ShouldSetCorrectPlayerAsPlayerToEditScore() {
        // given
        let sut = getViewModelWithBasicGame()
        sut.sortPreference.value = .score
        var players = Array(repeating: Player(name: "", position: 0), count: 5)
        players[3].score = 1
        sut.game.players = players
        
        // when
        sut.startEditingPlayerAt(0)
        
        // then
        XCTAssertEqual(sut.playerToEdit.value, players[3])
    }
    
    
    // MARK: - EditPlayerScoreAt
    
    func test_ScoreboardViewModel_WhenEditScoreCalledPlayerInGame_ShouldCallGameEditScoreWithPlayerAndChange() {
        // given
        let player = Player.getBasicPlayer()
        
        let game = GameMock(players: [player])
        let sut = ScoreboardViewModel(game: game)
        
        let scoreChange = Int.random(in: 1...1000)
        let scoreChangeObject = ScoreChange(player: player, scoreChange: scoreChange)
        
        // when
        sut.editScore(scoreChangeObject)
        
        // then
        XCTAssertEqual(game.editScoreForPlayer, player)
        XCTAssertEqual(game.editScoreForChange, scoreChange)
        XCTAssertEqual(game.editScoreForCalledCount, 1)
    }
    
    func test_ScoreboardViewModel_WhenEditPlayerScoreAtCalledPlayerInGame_ShouldCallBindViewToViewModel() {
        // given
        let sut = getViewModelWithBasicGame()
        let player = Player.getBasicPlayer()
        sut.game.players = [player]
        let viewModelViewDelegate = ScoreboardViewModelViewProtocolMock()
        sut.delegate = viewModelViewDelegate
        
        let previousBindCount = viewModelViewDelegate.bindViewToViewModelCalledCount
        
        let scoreChangeObject = ScoreChange(player: player, scoreChange: 0)
        
        // when
        sut.editScore(scoreChangeObject)
        
        // then
        XCTAssertEqual(viewModelViewDelegate.bindViewToViewModelCalledCount, previousBindCount + 1)
    }
    
    func test_ScoreboardViewModel_WhenEditPlayerScoreAtCalled_ShouldCallIsEndOfGame() {
        // given
        let game = GameIsEndOfGameMock()
        let sut = ScoreboardViewModel(game: game)
        
        let player = Player.getBasicPlayer()
        sut.game.players = [player]
        
        let scoreChangeObject = ScoreChange(player: player, scoreChange: 0)
        
        // when
        sut.editScore(scoreChangeObject)
        
        // then
        XCTAssertEqual(game.isEndOfGameCalledCount, 1)
    }
    
    func test_ScoreboardViewModel_WhenEditPlayerScoreAtCalledIsEndOfGameTrue_ShouldCallEndGameAfterOneSecond() {
        
        // given
        let game = GameIsEndOfGameMock()
        game.isEndOfGameBool = true
        let sut = ScoreboardViewModelEndGameExpectationModel(game: game)
        
        let calledExpectation = XCTestExpectation(description: "End game should be called")
        
        sut.endGameCompletion = {
            calledExpectation.fulfill()
        }
        
        // when
        sut.endRound(withChanges: [:])
        wait(for: [calledExpectation], timeout: 1.1)
    }
    
    func test_ScoreboardViewModel_WhenEditPlayerScoreAtCalledIsEndOfGameTrue_ShouldNotCallEndGameBefore1Second() {
        
        // given
        let game = GameIsEndOfGameMock()
        game.isEndOfGameBool = true
        let sut = ScoreboardViewModelEndGameExpectationModel(game: game)
        
        let waitExpecation = XCTestExpectation(description: "End game should wait at least .9 seconds")
        waitExpecation.isInverted = true
        
        sut.endGameCompletion = {
            waitExpecation.fulfill()
        }
        
        // when
        sut.endRound(withChanges: [:])
        wait(for: [waitExpecation], timeout: 0.9)
    }
    
    func test_ScoreboardViewModel_WhenEditPlayerScoreatCalledIsEndOfGameFalse_ShouldNotCallEndGame() {
        
        // given
        let game = GameIsEndOfGameMock()
        game.isEndOfGameBool = false
        let sut = ScoreboardViewModelEndGameExpectationModel(game: game)
        sut.dispatchQueue = DispatchQueueMainMock()
        
        sut.endGameCompletion = {
            XCTFail("End game shouldn't be called")
        }
        
        // when
        sut.endRound(withChanges: [:])
    }
    
    
    // MARK: - FinishedEditingPlayer
    
    func test_ScoreboardViewModel_WhenFinishedEditingCalledPlayerNotInGame_ShouldNotChangePlayers() {
        // given
        let sut = getViewModelWithBasicGame()
        let players = [Player(name: "", position: 0)]
        sut.game.players = players
        
        let editedPlayer = Player(name: "", position: 0)
        
        // when
        sut.finishedEditing(editedPlayer)
        
        // then
        XCTAssertEqual(players, sut.game.players)
    }
    
    func test_ScoreboardViewModel_WhenFinishedEditingCalledPlayerInGame_ShouldUpdatePlayerName() {
        
        // given
        let sut = ScoreboardViewModel(game: Game(gameType: .basic, gameEndType: .none, numberOfPlayers: 0))
        
        let playerName1 = UUID().uuidString
        let player1 = Player(name: playerName1, position: 0)
        
        let playerName2 = UUID().uuidString
        let player2 = Player(name: playerName2, position: 0)
        
        let players = [player1, player2]
        sut.game.players = players
        
        let playerToEditIndex = Int.random(in: 0...1)
        var playerToEdit = players[playerToEditIndex]
        let newPlayerName = UUID().uuidString
        playerToEdit.name = newPlayerName
        
        // when
        sut.finishedEditing(playerToEdit)
        
        // then
        XCTAssertEqual(sut.game.players[playerToEditIndex].name, newPlayerName)
    }
    
    func test_ScoreboardViewModel_WhenFinishedEditingCalledPlayerInGame_ShouldCallBindViewToViewModel() {
        // given
        let sut = getViewModelWithBasicGame()
        let player = Player(name: "", position: 0)
        sut.game.players = [player]
        let viewModelViewDelegate = ScoreboardViewModelViewProtocolMock()
        sut.delegate = viewModelViewDelegate
        
        let previousBindCount = viewModelViewDelegate.bindViewToViewModelCalledCount
        
        // when
        sut.finishedEditing(player)
        
        // then
        XCTAssertEqual(viewModelViewDelegate.bindViewToViewModelCalledCount, previousBindCount + 1)
    }
    
    
    // MARK: - StartDeletingPlayerAt
    
    func test_ScoreboardViewModel_WhenStartDeletingPlayerAtCalledOutOfRange_ShouldNotSetPlayerToDelete() {
        // given
        let sut = getViewModelWithBasicGame()
        sut.game.players = []
        
        // when
        sut.startDeletingPlayerAt(0)
        
        // then
        XCTAssertNil(sut.playerToDelete.value)
    }
    
    func test_ScoreboardViewModel_WhenStartDeletingPlayerAtCalledInRange_ShouldSetPlayerToDelete() {
        // given
        let sut = getViewModelWithBasicGame()
        let player = Player(name: "", position: 0)
        sut.game.players = [player]
        
        // when
        sut.startDeletingPlayerAt(0)
        
        // then
        XCTAssertEqual(sut.playerToDelete.value, player)
    }
    
    
    // MARK: - DeletePlayer
    
    func test_ScoreboardViewModel_WhenDeletePlayerCalled_ShouldRemovePlayerFromCurrentGame() {
        // given
        let sut = getViewModelWithBasicGame()
        let player = Player(name: "", position: 0)
        sut.game.players = [player]
        
        // when
        sut.deletePlayer(player)
        
        // then
        XCTAssertEqual(sut.game.players.count, 0)
    }
    
    func test_ScoreboardViewModel_WhenDeletePlayerCalled_ShouldCallBindViewModelToView() {
        // given
        let sut = getViewModelWithBasicGame()
        let viewDelegate = ScoreboardViewModelViewProtocolMock()
        sut.delegate = viewDelegate
        
        let previousBindCount = viewDelegate.bindViewToViewModelCalledCount
        
        // when
        sut.deletePlayer(Player(name: "", position: 0))
        
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
    
    func test_ScoreboardViewModel_WhenEndRoundCalled_ShouldCallGameEndRoundWithScoreChangeDictionary() {
        // given
        let gameMock = GameMock()
        let sut = ScoreboardViewModel(game: gameMock)
        
        let player = Player.getBasicPlayer()
        let scoreChange = Int.random(in: 1...1000)
        let scoreChangeDictionary = [player: scoreChange]
        
        // when
        sut.endRound(withChanges: scoreChangeDictionary)
        
        // then
        XCTAssertEqual(gameMock.endRoundChangeDictionary, scoreChangeDictionary)
        XCTAssertEqual(gameMock.endRoundCalledCount, 1)
    }
    
    func test_ScoreboardViewModel_WhenEndRoundCalled_ShouldCallBindViewToViewModel() {
        // given
        let sut = getViewModelWithBasicGame()
        
        let viewDelegate = ScoreboardViewModelViewProtocolMock()
        sut.delegate = viewDelegate
        
        let bindViewToViewModelCalledCount = viewDelegate.bindViewToViewModelCalledCount
        
        // when3
        sut.endRound(withChanges: [:])
        
        // then
        XCTAssertEqual(viewDelegate.bindViewToViewModelCalledCount, bindViewToViewModelCalledCount + 1)
    }
    
    
    func test_ScoreboardViewModel_WhenEndRoundCalled_ShouldCallIsEndOfGame() {
        // given
        let game = GameIsEndOfGameMock()
        game.isEndOfGameBool = true
        let sut = ScoreboardViewModel(game: game)
        
        // when
        sut.endRound(withChanges: [:])
        
        // then
        XCTAssertEqual(game.isEndOfGameCalledCount, 1)
    }
    
    func test_ScoreboardViewModel_WhenEndRoundCalledIsEndOfGameTrue_ShouldCallEndGameAfterOneSecond() {
        
        // given
        let sut = ScoreboardViewModelEndGameExpectationModel(game: GameMock())
        let game = GameIsEndOfGameMock()
        game.isEndOfGameBool = true
        sut.game = game
        
        let calledExpectation = XCTestExpectation(description: "End game should be called")
        
        sut.endGameCompletion = {
            calledExpectation.fulfill()
        }
        
        // when
        sut.endRound(withChanges: [:])
        wait(for: [calledExpectation], timeout: 1.1)
    }
    
    func test_ScoreboardViewModel_WhenEndRoundCalledIsEndOfGameTrue_ShouldNotCallEndGameBefore1Second() {
        
        // given
        let sut = ScoreboardViewModelEndGameExpectationModel(game: GameMock())
        let game = GameIsEndOfGameMock()
        game.isEndOfGameBool = true
        sut.game = game
        
        let waitExpecation = XCTestExpectation(description: "End game should wait at least .9 seconds")
        waitExpecation.isInverted = true
        
        sut.endGameCompletion = {
            waitExpecation.fulfill()
        }
        
        // when
        sut.endRound(withChanges: [:])
        wait(for: [waitExpecation], timeout: 0.9)
    }
    
    func test_ScoreboardViewModel_WhenEndRoundCalledIsEndOfGameFalse_ShouldNotCallEndGame() {
        
        // given
        let sut = ScoreboardViewModelEndGameExpectationModel(game: GameMock())
        sut.dispatchQueue = DispatchQueueMainMock()
        
        let game = GameIsEndOfGameMock()
        game.isEndOfGameBool = false
        sut.game = game
    
        
        sut.endGameCompletion = {
            XCTFail("End game should not be called")
        }
        
        // when
        sut.endRound(withChanges: [:])
    }
    
    
    // MARK: - EndGame
    
    func test_ScoreboardViewModel_WhenEndGameCalled_ShouldSetValueOfShouldShowEndGamePopoverToTrue() {
        // given
        let sut = getViewModelWithBasicGame()
        
        // when
        sut.endGame()
        
        // then
        XCTAssertTrue(sut.shouldShowEndGamePopup.value ?? false)
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
    
    func test_ScoreboardViewModel_WhenGoToEndGameScreenCalled_ShouldntSetValueOfShouldGoToEndGameScreenToTrueBeforeHalfASecond() {
        // given
        let sut = getViewModelWithBasicGame()
        let expectation = XCTestExpectation(description: "Value shouldn't be changed before .5 seconds")
        expectation.isInverted = true
        
        sut.shouldGoToEndGameScreen.valueChanged = { _ in
            expectation.fulfill()
        }
        
        // when
        sut.goToEndGameScreen()
        
        // then
        wait(for: [expectation], timeout: 0.4)
    }
    
    func test_ScoreboardViewModel_WhenGoToEndGameScreenCalled_ShouldSetValueOfShouldGoToEndGameScreenToTrueHalfASecondIn() {
        // given
        let sut = getViewModelWithBasicGame()
        let expectation = XCTestExpectation(description: "Value should be changed before 0.6")
        
        sut.shouldGoToEndGameScreen.valueChanged = { bool in
            expectation.fulfill()
            XCTAssertTrue(bool ?? false)
        }
        
        // when
        sut.goToEndGameScreen()
        
        // then
        wait(for: [expectation], timeout: 0.6)
    }
    
    // MARK: - KeepPlayingSelected
    
    func test_ScoreboardViewModel_WhenKeepPlayingSelectedCalledIsEndOfGameFalse_ShouldNotSetShowKeepPlayingPopupValue() {
        // given
        let sut = getViewModelWithBasicGame()
        let game = GameIsEndOfGameMock()
        game.isEndOfGameBool = false
        sut.game = game
        let expectation = XCTestExpectation(description: "Value shouldn't be changed")
        expectation.isInverted = true
        
        sut.shouldShowKeepPlayingPopup.valueChanged = { _ in
            expectation.fulfill()
        }
        
        // when
        sut.keepPlayingSelected()
        
        // then
        wait(for: [expectation], timeout: 1)
    }
    
    func test_ScoreboardViewModel_WhenKeepPlayingSelectedCalledIsEndOfGameTrue_ShouldntSetValueOfShouldShowKeepPlayingPopupToTrueBeforeHalfASecond() {
        // given
        let sut = getViewModelWithBasicGame()
        let game = GameIsEndOfGameMock()
        game.isEndOfGameBool = true
        sut.game = game
        let expectation = XCTestExpectation(description: "Value shouldn't be changed before .5 seconds")
        expectation.isInverted = true
        
        sut.shouldShowKeepPlayingPopup.valueChanged = { _ in
            expectation.fulfill()
        }
        
        // when
        sut.keepPlayingSelected()
        
        // then
        wait(for: [expectation], timeout: 0.4)
    }
    
    func test_ScoreboardViewModel_WheKeepPlayingSelectedCalled_ShouldSetValueOfShouldShowKeepPlayingPopupToTrueHalfASecondIn() {
        // given
        let sut = getViewModelWithBasicGame()
        let game = GameIsEndOfGameMock()
        game.isEndOfGameBool = true
        sut.game = game
        let expectation = XCTestExpectation(description: "Value should be changed before 0.6")
        
        sut.shouldShowKeepPlayingPopup.valueChanged = { bool in
            expectation.fulfill()
            XCTAssertTrue(bool ?? false)
        }
        
        // when
        sut.keepPlayingSelected()
        
        // then
        wait(for: [expectation], timeout: 0.6)
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
    
    
    // MARK: - openingGameOverCheck
    
    func test_ScoreboardViewModel_WhenOpeningGameOverCheckCalledGameIsEndOfGameTrue_ShouldSetShowKeepPlayingPopoverTrueAfterPoint5Seconds() {
        // given
        let sut = getViewModelWithBasicGame()
        let game = GameIsEndOfGameMock()
        game.isEndOfGameBool = true
        sut.game = game
        
        let expectation = XCTestExpectation(description: "Value should be changed before 0.6")
        
        sut.shouldShowKeepPlayingPopup.valueChanged = { bool in
            expectation.fulfill()
            XCTAssertTrue(bool ?? false)
        }
        
        // when
        sut.openingGameOverCheck()
        
        // then
        wait(for: [expectation], timeout: 0.6)
    }
    
    func test_ScoreboardViewModel_WhenOpeningGameOverCheckCalledGameIsEndOfGameFalse_ShouldNotSetShowKeepPlayingPopoverBeforePoint5Seconds() {
        // given
        let sut = getViewModelWithBasicGame()
        let game = GameIsEndOfGameMock()
        game.isEndOfGameBool = true
        sut.game = game
        
        let expectation = XCTestExpectation(description: "Value shouldn't be changed before 0.5 seconds")
        expectation.isInverted = true
        
        sut.shouldShowKeepPlayingPopup.valueChanged = { _ in
            expectation.fulfill()
        }
        
        // when
        sut.openingGameOverCheck()
        
        // then
        wait(for: [expectation], timeout: 0.4)
    }
    
    func test_ScoreboardViewModel_WhenOpeningGameOverCheckCalledGameIsEndOfGameFalse_ShouldNotSetShowKeepPlayingPopover() {
        // given
        let sut = getViewModelWithBasicGame()
        let game = GameIsEndOfGameMock()
        game.isEndOfGameBool = false
        sut.game = game
        
        let expectation = XCTestExpectation(description: "Value shouldn't be changed")
        expectation.isInverted = true
        
        sut.shouldShowKeepPlayingPopup.valueChanged = { _ in
            expectation.fulfill()
        }
        
        // when
        sut.openingGameOverCheck()
        
        // then
        wait(for: [expectation], timeout: 0.6)
    }
    
    
    // MARK: - Classes
    
    class ScoreboardViewModelViewProtocolMock: NSObject, ScoreboardViewModelViewProtocol {
        var bindViewToViewModelCalledCount = 0
        func bindViewToViewModel(dispatchQueue: Whats_The_Score.DispatchQueueProtocol) {
            bindViewToViewModelCalledCount += 1
        }
    }
    
    class ScoreboardViewModelEndGameExpectationModel: ScoreboardViewModel {
        var endGameCompletion: (() -> Void) = {}
        override func endGame() {
            endGameCompletion()
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
    var playerToEditScore: Observable<Player> = Observable(Player(name: "", position: 0))
    var playerToEdit: Observable<Player> = Observable(Player(name: "", position: 0))
    var playerToDelete: Observable<Player> = Observable(Player(name: "", position: 0))
    var shouldShowEndGamePopup: Observable<Bool> = Observable(false)
    var shouldShowKeepPlayingPopup: Observable<Bool> = Observable(false)
    var shouldGoToEndGameScreen: Observable<Bool> = Observable(false)
    var sortPreference: Observable<ScoreboardSortPreference> = Observable(.score)
    var sortedPlayers: [Player] = []
    
    var startEditingPlayerScoreAtCalledCount = 0
    var startEditingPlayerScoreAtIndex: Int?
    func startEditingPlayerScoreAt(_ index: Int) {
        startEditingPlayerScoreAtIndex = index
        startEditingPlayerScoreAtCalledCount += 1
    }
    
    var editScoreCalledCount = 0
    var editScorePlayer: Player?
    var editScoreChange: Int?
    func editScore(_ scoreChange: ScoreChange) {
        editScoreCalledCount += 1
        editScorePlayer = scoreChange.player
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
    
    var deletePlayerPlayer: Player?
    var deletePlayerCalledCount = 0
    func deletePlayer(_ player: Player) {
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
    
    func finishedEditing(_ player: Player) {}
    func endRound(withChanges changeDictionary: [Whats_The_Score.Player: Int]) {}
    func goToEndGameScreen() {}
    func keepPlayingSelected() {}
    func updateNumberOfRounds(to numberOfRounds: Int) {}
    func updateWinningScore(to winningScore: Int) {}
    func setNoEnd() {}
}
