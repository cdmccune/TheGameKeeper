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
        
        // when
        sut.editPlayerScoreAt(0, byAdding: 0)
        
        // then
        XCTAssertEqual(viewModelViewDelegate.bindViewToViewModelCalledCount, 1)
    }
    

    class ScoreboardViewModelViewProtocolMock: NSObject, ScoreboardViewModelViewProtocol {
        var bindViewToViewModelCalledCount = 0
        func bindViewToViewModel(dispatchQueue: Whats_The_Score.DispatchQueueProtocol) {
            bindViewToViewModelCalledCount += 1
        }
    }
}

class ScoreboardViewModelMock: ScoreboardViewModelProtocol {
    init(game: GameProtocol) {
        self.game = game
    }
    
    init() {
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
}
