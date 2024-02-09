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
    var playerToEditScore: Observable<Player> = Observable(Player(name: "", position: 0))
    var playerToEdit: Observable<Player> = Observable(Player(name: "", position: 0))
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
    
    var endCurrentRoundCalledCount = 0
    func endCurrentRound() {
        endCurrentRoundCalledCount += 1
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
    
    func editScore(for player: Player, by change: Int) {
    }
    
    func finishedEditing(_ player: Player) {
    }
}
