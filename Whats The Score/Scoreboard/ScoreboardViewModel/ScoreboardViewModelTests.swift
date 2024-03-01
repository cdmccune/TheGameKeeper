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
    
    func test_ScoreboardViewModel_WhenEditPlayerScoreAtCalledInRange_ShouldUpdatePlayerScoreToNewValue() {
        // given
        let sut = getViewModelWithBasicGame()
        let startingScore = Int.random(in: 0...10)
        sut.game.players = [Player(name: "", position: 0, score: startingScore)]
        
        let scoreToAdd = Int.random(in: -10...10)
        
        // when
        sut.editPlayerScoreAt(0, byAdding: scoreToAdd)
        
        // then
        XCTAssertEqual(sut.game.players.first?.score, startingScore + scoreToAdd)
    }
    
    func test_ScoreboardViewModel_WhenEditPlayerScoreAtCalledInRange_ShouldCallBindViewToViewModel() {
        // given
        let sut = getViewModelWithBasicGame()
        sut.game.players = [Player(name: "", position: 0)]
        let viewModelViewDelegate = ScoreboardViewModelViewProtocolMock()
        sut.delegate = viewModelViewDelegate
        
        let previousBindCount = viewModelViewDelegate.bindViewToViewModelCalledCount
        
        // when
        sut.editPlayerScoreAt(0, byAdding: 0)
        
        // then
        XCTAssertEqual(viewModelViewDelegate.bindViewToViewModelCalledCount, previousBindCount + 1)
    }
    
    func test_ScoreboardViewModel_WhenEditPlayerScoreAtCalled_ShouldCallIsEndOfGame() {
        // given
        let sut = ScoreboardViewModelIsEndOfGameEndGameMock(game: GameMock())
        sut.game.players = [Player(name: "", position: 0)]
        
        // when
        sut.editPlayerScoreAt(0, byAdding: 0)
        
        // then
        XCTAssertEqual(sut.isEndOfGameCalledCount, 1)
    }
    
    func test_ScoreboardViewModel_WhenEditPlayerScoreAtCalledIsEndOfGameTrue_ShouldCallEndGameAfterOneSecond() {
        
        // given
        let sut = ScoreboardViewModelEndGameExpectationModel(game: GameMock())
        sut.isEndOfGameBool = true
        
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
        let sut = ScoreboardViewModelEndGameExpectationModel(game: GameMock())
        sut.isEndOfGameBool = true
        
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
        let sut = ScoreboardViewModelEndGameExpectationModel(game: GameMock())
        sut.dispatchQueue = DispatchQueueMainMock()
        sut.isEndOfGameBool = false
    
        
        sut.endGameCompletion = {
            XCTFail("End game shouldn't be called")
        }
        
        // when
        sut.endRound(withChanges: [:])
    }
    
    
    // MARK: - EditScore
    
    func test_ScoreboardViewModel_WhenEditCalledWithPlayerNotInGame_ShouldNotChangePlayers() {
        // given
        let sut = getViewModelWithBasicGame()
        let players = [Player(name: UUID().uuidString, position: 0)]
        sut.game.players = players
        
        let editPlayer = Player(name: "", position: 0)
        
        // when
        sut.editScore(for: editPlayer, by: 1)
        
        // then
        XCTAssertEqual(players, sut.game.players)
    }
    
    func test_ScoreboardViewModel_WhenEditCalledWithPlayerInGame_ShouldCallEditPlayerScoreAtWithIndexAndChange() {
        
        class ScoreboardViewModelEditPlayerScoreAtMock: ScoreboardViewModel {
            var editPlayerScoreAtCalledCount = 0
            override func editPlayerScoreAt(_ index: Int, byAdding change: Int) {
                editPlayerScoreAtCalledCount += 1
            }
        }
        
        // given
        let sut = ScoreboardViewModelEditPlayerScoreAtMock(game: Game(gameType: .basic, gameEndType: .none, numberOfPlayers: 0))
        
        let player1 = Player(name: "", position: 0)
        let player2 = Player(name: UUID().uuidString, position: 0)
        let player3 = Player(name: "", position: 0)
        let players = [player1, player2, player3]
        sut.game.players = players
        
        let scoreChange = Int.random(in: -10...10)
        
        let playerToEdit = Int.random(in: 0...2)
        
        // when
        sut.editScore(for: players[playerToEdit], by: scoreChange)
        
        // then
        XCTAssertEqual(sut.editPlayerScoreAtCalledCount, 1)
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
    
    func test_ScoreboardViewModel_WhenEndRoundCalled_ShouldAddTheScoresToThePlayers() {
        // given
        let sut = getViewModelWithBasicGame()
        
        let startingScore = Int.random(in: 1...100)
        let players = Array(0...9).map { index in Player(name: "", position: index, score: startingScore) }
        sut.game.players = players
        
        var dictionaryToSend: [Player: Int] = [:]
        players.forEach { dictionaryToSend[$0] = Int.random(in: 1...1000) }
        
        // when
        sut.endRound(withChanges: dictionaryToSend)
        
        // then
        
        sut.game.players.forEach { player in
            XCTAssertEqual(player.score, (dictionaryToSend[player] ?? 0) + startingScore)
        }
    }
    
    func test_ScoreboardViewModel_WhenEndRoundCalled_ShouldIncrementGameCurrentRound() {
        // given
        let sut = getViewModelWithBasicGame()
        let currentRound = Int.random(in: 0...5)
        sut.game.currentRound = currentRound
        
        // when
        sut.endRound(withChanges: [:])
        
        // then
        XCTAssertEqual(sut.game.currentRound, currentRound + 1)
    }
    
    func test_ScoreboardViewModel_WhenEndRoundCalled_ShouldCallBindViewToViewModel() {
        // given
        let sut = getViewModelWithBasicGame()
        
        let viewDelegate = ScoreboardViewModelViewProtocolMock()
        sut.delegate = viewDelegate
        
        let bindViewToViewModelCalledCount = viewDelegate.bindViewToViewModelCalledCount
        
        // when
        sut.endRound(withChanges: [:])
        
        // then
        XCTAssertEqual(viewDelegate.bindViewToViewModelCalledCount, bindViewToViewModelCalledCount + 1)
    }
    
    
    func test_ScoreboardViewModel_WhenEndRoundCalled_ShouldCallIsEndOfGame() {
        // given
        let sut = ScoreboardViewModelIsEndOfGameEndGameMock(game: GameMock())
        
        // when
        sut.endRound(withChanges: [:])
        
        // then
        XCTAssertEqual(sut.isEndOfGameCalledCount, 1)
    }
    
    func test_ScoreboardViewModel_WhenEndRoundCalledIsEndOfGameTrue_ShouldCallEndGameAfterOneSecond() {
        
        // given
        let sut = ScoreboardViewModelEndGameExpectationModel(game: GameMock())
        sut.isEndOfGameBool = true
        
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
        sut.isEndOfGameBool = true
        
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
        sut.isEndOfGameBool = false
    
        
        sut.endGameCompletion = {
            XCTFail()
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
    
    func test_ScoreboardViewModel_WhenResetGameCalled_ShouldSetAllPlayersScoresToZero() {
        // given
        let sut = getViewModelWithBasicGame()
        let players = Array(repeating: Player(name: "", position: 0, score: Int.random(in: 1...10)), count: 5)
        sut.game.players = players
        
        // when
        sut.resetGame()
        
        // then
        sut.game.players.forEach { player in
            XCTAssertEqual(player.score, 0)
        }
    }
    
    func test_ScoreboardViewModel_WhenResetGameCalled_ShouldSetTheCurrentRoundTo1() {
        // given
        let sut = getViewModelWithBasicGame()
        sut.game.currentRound = 5
        
        // when
        sut.resetGame()
        
        // then
        XCTAssertEqual(sut.game.currentRound, 1)
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
    
    
    // MARK: - IsEndOfGameCheck
    
    func test_ScoreboardViewModel_WhenIsEndOfGameCheckCalledNoneEndGameType_ShouldReturnFalse() {
        // given
        let sut = getViewModelWithBasicGame()
        sut.game.gameEndType = .none
        
        // when
        let isEndOfGame = sut.isEndOfGame()
        
        // then
        XCTAssertFalse(isEndOfGame)
    }
    
    func test_ScoreboardViewModel_WhenIsEndOfGameCheckCalledRoundEndGameTypeCurrentRoundLessThanGameNumberOfRounds_ShouldReturnFalse() {
        // given
        let sut = getViewModelWithBasicGame()
        sut.game.gameEndType = .round
        sut.game.currentRound = 0
        sut.game.numberOfRounds = 4
        
        // when
        let isEndOfGame = sut.isEndOfGame()
        
        // then
        XCTAssertFalse(isEndOfGame)
    }
    
    func test_ScoreboardViewModel_WhenIsEndOfGameCheckCalledRoundEndGameTypeCurrentRoundEqualToGameNumberOfRounds_ShouldReturnFalse() {
        // given
        let sut = getViewModelWithBasicGame()
        sut.game.gameEndType = .round
        sut.game.currentRound = 4
        sut.game.numberOfRounds = 4
        
        // when
        let isEndOfGame = sut.isEndOfGame()
        
        // then
        XCTAssertFalse(isEndOfGame)
    }
    
    func test_ScoreboardViewModel_WhenIsEndOfGameCheckCalledScoreEndGameTypePlayersDontHaveEqualOrMoreThanEndingScore_ShouldReturnFalse() {
        // given
        let sut = getViewModelWithBasicGame()
        sut.game.gameEndType = .score
        sut.game.players = [Player(name: "", position: 0, score: 10)]
        sut.game.endingScore = 100
        
        // when
        let isEndOfGame = sut.isEndOfGame()
        
        // then
        XCTAssertFalse(isEndOfGame)
    }
    
    func test_ScoreboardViewModel_WhenIsEndOfGameCheckCalledScoreEndGameTypePlayersDontHaveEqualOrMoreThanWinningScore_ShouldReturnTrue() {
        // given
        let sut = getViewModelWithBasicGame()
        sut.game.gameEndType = .score
        sut.game.players = [Player(name: "", position: 0, score: 100)]
        sut.game.endingScore = 100
        
        // when
        let isEndOfGame = sut.isEndOfGame()
        
        // then
        XCTAssertTrue(isEndOfGame)
    }
    
    
    // MARK: - Classes
    
    class ScoreboardViewModelViewProtocolMock: NSObject, ScoreboardViewModelViewProtocol {
        var bindViewToViewModelCalledCount = 0
        func bindViewToViewModel(dispatchQueue: Whats_The_Score.DispatchQueueProtocol) {
            bindViewToViewModelCalledCount += 1
        }
    }
    
    class ScoreboardViewModelIsEndOfGameEndGameMock: ScoreboardViewModel {
        var isEndOfGameBool = false
        var isEndOfGameCalledCount = 0
        
        override func isEndOfGame() -> Bool {
            isEndOfGameCalledCount += 1
            return isEndOfGameBool
        }
        
        var endGameCalledCount = 0
        override func endGame() {
            endGameCalledCount += 1
        }
    }
    
    class ScoreboardViewModelEndGameExpectationModel: ScoreboardViewModelIsEndOfGameEndGameMock {
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
    var sortPreference: Observable<ScoreboardSortPreference> = Observable(.score)
    var sortedPlayers: [Player] = []
    
    var startEditingPlayerScoreAtCalledCount = 0
    var startEditingPlayerScoreAtIndex: Int?
    func startEditingPlayerScoreAt(_ index: Int) {
        startEditingPlayerScoreAtIndex = index
        startEditingPlayerScoreAtCalledCount += 1
    }
    
    var editPlayerScoreAtCalledCount = 0
    var editPlayerScoreAtIndex: Int?
    var editPlayerScoreAtChange: Int?
    func editPlayerScoreAt(_ index: Int, byAdding change: Int) {
        editPlayerScoreAtCalledCount += 1
        editPlayerScoreAtIndex = index
        editPlayerScoreAtChange = change
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
    
    func editScore(for player: Player, by change: Int) {
    }
    
    func finishedEditing(_ player: Player) {
    }
    
    func endRound(withChanges changeDictionary: [Whats_The_Score.Player: Int]) {}
}
