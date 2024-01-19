//
//  PlayerSetupViewModelTests.swift
//  What's The Score Tests
//
//  Created by Curt McCune on 1/3/24.
//

import XCTest
@testable import Whats_The_Score

final class PlayerSetupViewModelTests: XCTestCase {
    
    func getViewModelWithDefaultSettings() -> PlayerSetupViewModel {
        let game = Game(gameType: .basic,
                                        gameEndType: .none,
                                        numberOfRounds: 1,
                                        numberOfPlayers: 2)
        
        return PlayerSetupViewModel(game: game)
    }

    // MARK: - DidSet
    
    func test_PlayerSetupViewModel_WhenDelegateChanged_ShouldCallDelegateBindViewToViewModel() {
        // given
        let sut = getViewModelWithDefaultSettings()
        let delegateMock = PlayerSetupViewModelViewProtocolMock()
        
        // when
        sut.delegate = delegateMock
        
        // then
        XCTAssertEqual(delegateMock.bindViewToViewModelCallCount, 1)
    }
    
    
    // MARK: - Player Name Changed
    
    func test_PlayerSetupViewModel_WhenPlayerNameChangedCalled_ShouldCallGamePlayerNameChanged() {
        // given
        let sut = getViewModelWithDefaultSettings()
        let index = Int.random(in: 0...5)
        let newName = UUID().uuidString
        
        let gameMock = GameMock()
        sut.game = gameMock
        
        // when
        sut.playerNameChanged(withIndex: index, toName: newName)
        
        // then
        XCTAssertEqual(gameMock.playerNameChangedCalledCount, 1)
        XCTAssertEqual(gameMock.playerNameChangedIndex, index)
        XCTAssertEqual(gameMock.playerNameChangedName, newName)
    }
    
    func test_PlayerSetupViewModel_WhenPlayerNameChangedCalled_ShouldCallReloadTableViewCellWithIndex() {
        // given
        let sut = getViewModelWithDefaultSettings()
        
        let viewDelegate = PlayerSetupViewModelViewProtocolMock()
        sut.delegate = viewDelegate
        
        // when
        sut.playerNameChanged(withIndex: 0, toName: "")
        
        // then
        XCTAssertEqual(viewDelegate.reloadTableViewCellIndex, 0)
        XCTAssertEqual(viewDelegate.reloadTableViewCellCalledCount, 1)
    }
    
    
    // MARK: - Move Player At
    
    func test_PlayerSetupViewModel_WhenMovePlayerAtCalled_ShouldCallGameMovePlayerAt() {
        // given
        let sut = getViewModelWithDefaultSettings()
        
        let gameMock = GameMock()
        sut.game = gameMock
        
        let sourceRowIndex = Int.random(in: 0...10)
        let destinationRowIndex = Int.random(in: 0...10)
        
        // when
        sut.movePlayerAt(sourceRowIndex, to: destinationRowIndex)
        
        // then
        XCTAssertEqual(gameMock.movePlayerAtSourceRowIndex, sourceRowIndex)
        XCTAssertEqual(gameMock.movePlayerAtDestinationRowIndex, destinationRowIndex)
    }
 
    func test_PlayerSetupViewModel_WhenMovePlayerAtCalled_ShouldCallViewDelegateBindViewModelToView() {
        // given
        let sut = getViewModelWithDefaultSettings()
        
        let viewDelegateMock = PlayerSetupViewModelViewProtocolMock()
        sut.delegate = viewDelegateMock
        let bindCount = viewDelegateMock.bindViewToViewModelCallCount
        
        // when
        sut.movePlayerAt(0, to: 1)
        
        // then
        XCTAssertEqual(viewDelegateMock.bindViewToViewModelCallCount, bindCount + 1)
    }
    
    
    // MARK: - Add Player
    
    func test_PlayerSetupViewModel_WhenAddPlayerCalled_ShouldCallGameAddPlayer() {
        // given
        let sut = getViewModelWithDefaultSettings()
        
        let gameMock = GameMock()
        sut.game = gameMock
        
        // when
        sut.addPlayer()
        
        // then
        XCTAssertEqual(gameMock.addPlayerCalledCount, 1)
    }

    func test_PlayerSetupViewModel_WhenAddPlayerCalled_ShouldCallBindViewToViewModel() {
        // given
        let sut = getViewModelWithDefaultSettings()
        let viewDelegate = PlayerSetupViewModelViewProtocolMock()
        sut.delegate = viewDelegate
        let calledCount = viewDelegate.bindViewToViewModelCallCount
        
        // when
        sut.addPlayer()
        
        // then
        XCTAssertEqual(viewDelegate.bindViewToViewModelCallCount, calledCount + 1)
    }
    
    
    // MARK: - RandomizePlayers
    
    func test_PlayerSetupViewModel_WhenRandomizePlayersCalled_ShouldCallGameRandomizePlayers() {
        // given
        let sut = getViewModelWithDefaultSettings()
        
        let gameMock = GameMock()
        sut.game = gameMock
        
        // when
        sut.randomizePlayers()
        
        // then
        XCTAssertEqual(gameMock.randomizePlayersCalledCount, 1)
    }

    func test_PlayerSetupViewModel_WhenRandomizePlayersCalled_ShouldCallBindViewToViewModel() {
        // given
        let sut = getViewModelWithDefaultSettings()
        let viewModelDelegate = PlayerSetupViewModelViewProtocolMock()
        sut.delegate = viewModelDelegate
        let callCount = viewModelDelegate.bindViewToViewModelCallCount
        
        // when
        sut.randomizePlayers()
        
        // then
        XCTAssertEqual(viewModelDelegate.bindViewToViewModelCallCount, callCount+1)
    }
    
    
    // MARK: - DeletePlayerAt
    
    func test_PlayerSetupViewModel_WhenDeletePlayerCalled_ShouldCallGameDeletePlayer() {
        // given
        let sut = getViewModelWithDefaultSettings()
        
        let gameMock = GameMock()
        sut.game = gameMock
        let index = Int.random(in: 0...10)
        
        // when

        sut.deletePlayerAt(index)
        
        // then
        XCTAssertEqual(gameMock.deletePlayerAtCalledCount, 1)
    }
    
    // MARK: - End of Class
}

class PlayerSetupViewModelMock: PlayerSetupViewModelProtocol {
    var game: GameProtocol = Game(gameType: .basic, gameEndType: .none, numberOfRounds: 0, numberOfPlayers: 0)
    var delegate: PlayerSetupViewModelViewProtocol?
    
    var randomizePlayersCalledCount = 0
    func randomizePlayers() {
        randomizePlayersCalledCount += 1
    }
    
    var addPlayerCalledCount = 0
    func addPlayer() {
        addPlayerCalledCount += 1
    }
    
    var playerNameChangedIndex: Int?
    var playerNameChangedName: String?
    func playerNameChanged(withIndex index: Int, toName name: String) {
        self.playerNameChangedIndex = index
        self.playerNameChangedName = name
    }
    
    var movePlayerAtSourceRow: Int?
    var movePlayerAtDestinationRow: Int?
    var movePlayerAtCalledCount: Int = 0
    func movePlayerAt(_ sourceRowIndex: Int, to destinationRowIndex: Int) {
        self.movePlayerAtSourceRow = sourceRowIndex
        self.movePlayerAtDestinationRow = destinationRowIndex
        self.movePlayerAtCalledCount += 1
    }
    
    var deletePlayerAtCalledCount = 0
    func deletePlayerAt(_ index: Int) {
        deletePlayerAtCalledCount += 1
    }
}

class PlayerSetupViewModelViewProtocolMock: NSObject, PlayerSetupViewModelViewProtocol {
    
    var bindViewToViewModelCallCount = 0
    func bindViewToViewModel() {
        bindViewToViewModelCallCount += 1
    }
    
    var reloadTableViewCellIndex: Int?
    var reloadTableViewCellCalledCount = 0
    func reloadTableViewCell(index: Int) {
        reloadTableViewCellIndex = index
        reloadTableViewCellCalledCount += 1
    }
}
