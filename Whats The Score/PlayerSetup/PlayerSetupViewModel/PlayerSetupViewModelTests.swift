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
    
    // MARK: - Init

    func test_PlayerSetupViewModel_WhenInitializedSet_ShouldSetupArrayOfPlayersWithLengthNumberOfPlayersAndCorrectNames() {
        // given
        let numberOfPlayers = Int.random(in: 1...10)
        let game = Game(gameType: .round,
                                        gameEndType: .none,
                                        numberOfRounds: 0,
                                        numberOfPlayers: numberOfPlayers)
        
        // when
        let sut = PlayerSetupViewModel(game: game)
        
        // then
        XCTAssertEqual(sut.players.count, numberOfPlayers)
        XCTAssertEqual(sut.players.last?.name, "Player \(numberOfPlayers)")
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
    
    func test_PlayerSetupViewModel_WhenPlayerNameChangedCalledOutOfPlayerRange_ShouldDoNothing() {
        // given
        let sut = getViewModelWithDefaultSettings()
        let player = Player(name: "", position: 0)
        sut.players = [player]
        
        // when
        sut.playerNameChanged(withIndex: 1, toName: "test")
        
        // then
        XCTAssertEqual(sut.players[0], player)
    }
    
    func test_PlayerSetupViewModel_WhenPlayerNameChangedCalledInRangePlayer_ShouldChangeTheNameOfPlayer() {
        // given
        let sut = getViewModelWithDefaultSettings()
        let player = Player(name: "", position: 0)
        sut.players = [player]
        
        let testString = UUID().uuidString
        
        // when
        sut.playerNameChanged(withIndex: 0, toName: testString)
        
        // then
        XCTAssertEqual(sut.players[0].name, testString)
    }
    
    func test_PlayerSetupViewModel_WhenPlayerNameChangedCalledInRange_ShouldCallReloadTableViewCellWithIndex() {
        // given
        let sut = getViewModelWithDefaultSettings()
        let player = Player(name: "", position: 0)
        sut.players = [player]
        
        let viewDelegate = PlayerSetupViewModelViewProtocolMock()
        sut.delegate = viewDelegate
        
        // when
        sut.playerNameChanged(withIndex: 0, toName: "")
        
        // then
        XCTAssertEqual(viewDelegate.reloadTableViewCellIndex, 0)
        XCTAssertEqual(viewDelegate.reloadTableViewCellCalledCount, 1)
    }
    
    
    // MARK: - Move Player At
    
    func test_PlayerSetupViewModel_WhenMovePlayerAtCalledSourceOutsideRange_ShouldDoNothing() {
        // given
        let sut = getViewModelWithDefaultSettings()
        let player1 = Player(name: UUID().uuidString, position: 0)
        let player2 = Player(name: UUID().uuidString, position: 0)
        let players = [player1, player2]
        sut.players = players
        
        // when
        sut.movePlayerAt(4, to: 0)

        
        // then
        XCTAssertEqual(sut.players, players)
    }
    
    func test_PlayerSetupViewModel_WhenMovePlayerAtCalledDestinationOutsideRange_ShouldDoNothing() {
        // given
        let sut = getViewModelWithDefaultSettings()
        let player1 = Player(name: UUID().uuidString, position: 0)
        let player2 = Player(name: UUID().uuidString, position: 0)
        let players = [player1, player2]
        sut.players = players
        
        // when
        sut.movePlayerAt(0, to: 5)

        
        // then
        XCTAssertEqual(sut.players, players)
    }
    
    func test_PlayerSetupViewModel_WhenMovePlayerAtCalledInRange_ShouldChangePlayersPostionsInArrayAndPositionValue() {
        // given
        let sut = getViewModelWithDefaultSettings()
        
        let player1Name = UUID().uuidString
        let player1 = Player(name: player1Name, position: 0)
        
        let player2Name = UUID().uuidString
        let player2 = Player(name: player2Name, position: 1)
        
        let player3Name = UUID().uuidString
        let player3 = Player(name: player3Name, position: 2)
        
        let players = [player1, player2, player3]
        sut.players = players
        
        // when
        sut.movePlayerAt(2, to: 0)
        
        // then
        XCTAssertEqual(sut.players[0].name, player3Name)
        XCTAssertEqual(sut.players[0].position, 0)
        XCTAssertEqual(sut.players[1].name, player1Name)
        XCTAssertEqual(sut.players[1].position, 1)
        XCTAssertEqual(sut.players[2].name, player2Name)
        XCTAssertEqual(sut.players[2].position, 2)
    }
    
    func test_PlayerSetupViewModel_WhenMovePlayerAtCalledInRange_ShouldCallViewDelegateBindViewModelToView() {
        // given
        let sut = getViewModelWithDefaultSettings()
        
        let player1 = Player(name: "", position: 0)
        let player2 = Player(name: "", position: 1)
        let players = [player1, player2]
        sut.players = players
        
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
        let sut = getViewModelWithDefaultSettings()
        let player = Player(name: "", position: 0)
        let players = Array(repeating: player, count: Int.random(in: 1...5))
        sut.players = players
        
        // when
        sut.addPlayer()
        
        // then
        XCTAssertEqual(sut.players.count, players.indices.upperBound + 1)
        XCTAssertTrue(sut.players.last?.hasDefaultName ?? false)
        XCTAssertEqual(sut.players.last?.position, players.indices.upperBound)
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
    
    func test_PlayerSetupViewModel_WhenRandomizePlayersCalled_ShouldRandomizePlayersAndSetTheirPositions() {
        // given
        let sut = getViewModelWithDefaultSettings()
        
        var players = [Player]()
        for i in 1...5 {
            players.append(Player(name: "\(i)", position: 0))
        }
        sut.players = players
        
        // when
        sut.randomizePlayers()
        
        // then
        XCTAssertNotEqual(sut.players, players)
        
        for player in players {
            XCTAssertNotNil(sut.players.first(where: { $0.name == player.name }))
        }
        
        for (index, player) in sut.players.enumerated() {
            XCTAssertEqual(player.position, index)
        }
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
    
    func test_PlayerSetupViewModel_WhenDeletePlayerAtCalledOutOfRange_ShouldNotAffectPlayersOrCallBindViewToViewModel() {
        // given
        let sut = getViewModelWithDefaultSettings()
        let viewModelDelegate = PlayerSetupViewModelViewProtocolMock()
        sut.delegate = viewModelDelegate
        let callCount = viewModelDelegate.bindViewToViewModelCallCount
        
        let player = Player(name: "", position: 0)
        sut.players = [player]
        
        // when
        sut.deletePlayerAt(1)
        
        // then
        XCTAssertEqual([player], sut.players)
        XCTAssertEqual(viewModelDelegate.bindViewToViewModelCallCount, callCount)
    }
    
    func test_PlayerSetupViewModel_WhenDeletePlayerAtCalled_ShouldRemovePlayerFromIndexAndCallBindViewToViewModelAndSetPositions() {
        // given
        let sut = getViewModelWithDefaultSettings()
        let viewModelDelegate = PlayerSetupViewModelViewProtocolMock()
        sut.delegate = viewModelDelegate
        let callCount = viewModelDelegate.bindViewToViewModelCallCount
        
        
        let player1 = Player(name: UUID().uuidString, position: 0)
        let player2 = Player(name: UUID().uuidString, position: 0)
        let player3 = Player(name: UUID().uuidString, position: 0)
        var players = [player1, player2, player3]
        sut.players = [player1, player2, player3]
        let playerToRemoveIndex = Int.random(in: 0...2)
        
        // when
        sut.deletePlayerAt(playerToRemoveIndex)
        players.remove(at: playerToRemoveIndex)
        players.setPositions()
        
        // then
        XCTAssertEqual(viewModelDelegate.bindViewToViewModelCallCount, callCount+1)
        XCTAssertEqual(sut.players, players)
        for (index, player) in sut.players.enumerated() {
            XCTAssertEqual(player.position, index)
        }
    }

    
    // MARK: - End of Class
}

class PlayerSetupViewModelMock: PlayerSetupViewModelProtocol {
    var players: [Player] = []
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
