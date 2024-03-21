//
//  PlayerSetupViewModelTests.swift
//  What's The Score Tests
//
//  Created by Curt McCune on 1/3/24.
//

import XCTest
@testable import Whats_The_Score

final class PlayerSetupViewModelTests: XCTestCase {
    
    func getViewModel(withPlayerCount playerCount: Int = 0) -> PlayerSetupViewModel {
        var players = [PlayerProtocol]()
        for _ in 0..<playerCount {
            players.append(PlayerMock())
        }
        let viewModel = PlayerSetupViewModel()
        viewModel.players = players
        return viewModel
    }

    // MARK: - DidSet
    
    func test_PlayerSetupViewModel_WhenDelegateChanged_ShouldCallDelegateBindViewToViewModel() {
        // given
        let sut = getViewModel()
        let delegateMock = PlayerSetupViewModelViewProtocolMock()
        
        // when
        sut.delegate = delegateMock
        
        // then
        XCTAssertEqual(delegateMock.bindViewToViewModelCallCount, 1)
    }
    
    
    // MARK: - Player Name Changed
    
    func test_PlayerSetupViewModel_WhenPlayerNameChangedCalled_ShouldChangePlayersNameAtIndex() {
        // given
        let sut = getViewModel(withPlayerCount: 6)
        let index = Int.random(in: 0...5)
        let newName = UUID().uuidString
        
        // when
        sut.playerNameChanged(withIndex: index, toName: newName)
        
        // then
        XCTAssertEqual(sut.players[index].name, newName)
    }
    
    func test_PlayerSetupViewModel_WhenPlayerNameChangedCalledInRange_ShouldCallReloadTableViewCellWithIndex() {
        // given
        let sut = getViewModel(withPlayerCount: 1)
        
        let viewDelegate = PlayerSetupViewModelViewProtocolMock()
        sut.delegate = viewDelegate
        
        // when
        sut.playerNameChanged(withIndex: 0, toName: "")
        
        // then
        XCTAssertEqual(viewDelegate.reloadTableViewCellIndex, 0)
        XCTAssertEqual(viewDelegate.reloadTableViewCellCalledCount, 1)
    }
    
    
    // MARK: - Move Player At
    
    func test_PlayerSetupViewModel_WhenMovePlayerAtCalled_ShouldMovePlayerToNewIndex() {
        // given
        let sut = getViewModel(withPlayerCount: 11)
        
        let sourceRowIndex = Int.random(in: 0...10)
        let destinationRowIndex = Int.random(in: 0...10)
        
        let player = sut.players[sourceRowIndex]
        
        // when
        sut.movePlayerAt(sourceRowIndex, to: destinationRowIndex)
        
        // then
        XCTAssertEqual(player.id, sut.players[destinationRowIndex].id)
    }
 
    func test_PlayerSetupViewModel_WhenMovePlayerAtCalledInRange_ShouldCallViewDelegateBindViewModelToView() {
        // given
        let sut = getViewModel(withPlayerCount: 2)
        
        let viewDelegateMock = PlayerSetupViewModelViewProtocolMock()
        sut.delegate = viewDelegateMock
        let bindCount = viewDelegateMock.bindViewToViewModelCallCount
        
        // when
        sut.movePlayerAt(0, to: 1)
        
        // then
        XCTAssertEqual(viewDelegateMock.bindViewToViewModelCallCount, bindCount + 1)
    }
    
    
    // MARK: - Add Player
    
    func test_PlayerSetupViewModel_WhenAddPlayerCalled_ShouldAddPlayerToPlayersArray() {
        // given
        let playerCount = Int.random(in: 2...10)
        let sut = getViewModel(withPlayerCount: playerCount)
        
        // when
        sut.addPlayer()
        
        // then
        XCTAssertEqual(sut.players.count, playerCount + 1)
    }

    func test_PlayerSetupViewModel_WhenAddPlayerCalled_ShouldCallBindViewToViewModel() {
        // given
        let sut = getViewModel()
        let viewDelegate = PlayerSetupViewModelViewProtocolMock()
        sut.delegate = viewDelegate
        let calledCount = viewDelegate.bindViewToViewModelCallCount
        
        // when
        sut.addPlayer()
        
        // then
        XCTAssertEqual(viewDelegate.bindViewToViewModelCallCount, calledCount + 1)
    }
    
    
    // MARK: - RandomizePlayers
    
    func test_PlayerSetupViewModel_WhenRandomizePlayersCalled_ShouldRandomizeArray() {
        
        // given
        let sut = getViewModel(withPlayerCount: 10)
        let preShuffledPlayers = sut.players
        
        // when
        sut.randomizePlayers()
        
        // then
        XCTAssertNotEqual(preShuffledPlayers as? [PlayerMock], sut.players as? [PlayerMock])
    }

    func test_PlayerSetupViewModel_WhenRandomizePlayersCalled_ShouldCallBindViewToViewModel() {
        // given
        let sut = getViewModel()
        let viewModelDelegate = PlayerSetupViewModelViewProtocolMock()
        sut.delegate = viewModelDelegate
        let callCount = viewModelDelegate.bindViewToViewModelCallCount
        
        // when
        sut.randomizePlayers()
        
        // then
        XCTAssertEqual(viewModelDelegate.bindViewToViewModelCallCount, callCount+1)
    }
    
    
    // MARK: - DeletePlayerAt
    
    func test_PlayerSetupViewModel_WhenDeletePlayerAtCalled_ShouldDeletePlayerAtIndex() {
        // given
        let sut = getViewModel(withPlayerCount: 11)
        
        var players = sut.players
        let index = Int.random(in: 0...10)
        
        // when

        sut.deletePlayerAt(index)
        
        // then
        players.remove(at: index)
        XCTAssertEqual(players as? [PlayerMock], sut.players as? [PlayerMock])
    }
    
    
    // MARK: - PlayersSetup
    
    func test_PlayerSetupViewModel_WhenPlayersSetupCalled_ShouldCallCoordinatorPlayersSetupWithPlayers() {
        // given
        let coordinatorMock = GameSetupCoordinatorMock()
        let sut = getViewModel(withPlayerCount: 5)
        sut.coordinator = coordinatorMock
        
        // when
        sut.playersSetup()
        
        // then
        XCTAssertEqual(coordinatorMock.playersSetupCalledCount, 1)
        XCTAssertEqual(coordinatorMock.playersSetupPlayers as? [PlayerMock], sut.players as? [PlayerMock])
    }
    
    // MARK: - End of Class
}

class PlayerSetupViewModelMock: PlayerSetupViewModelProtocol {
    var players: [PlayerProtocol] = []
    var delegate: PlayerSetupViewModelViewProtocol?
    var coordinator: GameSetupCoordinator? = nil
    
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
    
    var playersSetupCalledCount = 0
    func playersSetup() {
        playersSetupCalledCount += 1
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
