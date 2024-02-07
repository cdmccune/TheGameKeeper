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
    
    
    // MARK: - StartEditingPlayerScoreAt
    
    func test_ScoreboardViewModel_WhenStartEditingPlayerScoreAtCalledInRange_ShouldSetValueOfPlayerToEditScore() {
        // given
        let sut = getViewModelWithBasicGame()
        let name = UUID().uuidString
        let player = Player(name: name, position: 0)
        let players = [player]
        sut.game.players = players
        
        // when
        sut.startEditingPlayerScoreAt(0)
        
        // then
        XCTAssertEqual(sut.playerToEditScore.value, player)
    }
    
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
    
    
    // MARK: - ScoreboardPlayerEditPopoverEdit function
    
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
}
