//
//  GameTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 1/19/24.
//

import XCTest
@testable import Whats_The_Score

final class GameTests: XCTestCase {

    // MARK: - Init
    
    func test_Game_WhenInitialized_ShouldCreatePlayersForNumberOfPlayersPropertiesWithCorrectPositions() {
        // given
        let numberOfPlayers = Int.random(in: 1...5)
        
        // when
        let sut = Game(gameType: .basic, gameEndType: .none, numberOfRounds: 0, numberOfPlayers: numberOfPlayers)
        
        // then
        XCTAssertEqual(sut.players.count, numberOfPlayers)
        for (index, players) in sut.players.enumerated() {
            XCTAssertEqual(players.position, index)
        }
    }
    
    
    // MARK: - PlayerNameChanged
    
    func test_Game_WhenPlayerNameChangedCalledOutOfPlayerRange_ShouldDoNothing() {
        // given
        let player = Player(name: UUID().uuidString, position: 0)
        var sut = Game(basicGameWithPlayers: [player])
        
        // when
        sut.playerNameChanged(withIndex: 1, toName: UUID().uuidString)
        
        // then
        XCTAssertEqual(sut.players[0], player)
    }
    
    func test_Game_WhenPlayerNameChangedCalledInRange_ShouldChangePlayerName() {
        // given
        let player = Player(name: "", position: 0)
        var sut = Game(basicGameWithPlayers: [player])
        
        // when
        let newName = UUID().uuidString
        sut.playerNameChanged(withIndex: 0, toName: newName)
        
        // then
        XCTAssertEqual(sut.players[0].name, newName)
    }
    
    
    // MARK: - MovePlayerAt
    
    func test_Game_WhenMovePlayerAtSourceCalledOutOfRange_ShouldDoNothing() {
        // given
        let player1 = Player(name: UUID().uuidString, position: 0)
        let player2 = Player(name: UUID().uuidString, position: 0)
        let players = [player1, player2]
        var sut = Game(basicGameWithPlayers: players)
        
        // when
        sut.movePlayerAt(4, to: 0)
        
        // then
        XCTAssertEqual(sut.players, players)
    }
    
    func test_Game_WhenMovePlayerAtDestinationCalledOutOfRange_ShouldDoNothing() {
        // given
        let player1 = Player(name: UUID().uuidString, position: 0)
        let player2 = Player(name: UUID().uuidString, position: 0)
        let players = [player1, player2]
        var sut = Game(basicGameWithPlayers: players)
        
        // when
        sut.movePlayerAt(0, to: 5)
        
        // then
        XCTAssertEqual(sut.players, players)
    }
    
    func test_Game_WhenMovePlayerAtCalledInRange_ShouldChangePlayersPositionAndPositionValues() {
        // given
        let player1Name = UUID().uuidString
        let player1 = Player(name: player1Name, position: 0)
        
        let player2Name = UUID().uuidString
        let player2 = Player(name: player2Name, position: 1)
        
        let player3Name = UUID().uuidString
        let player3 = Player(name: player3Name, position: 2)
        
        let players = [player1, player2, player3]
        
        var sut = Game(basicGameWithPlayers: players)
        
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
    
    
    // MARK: - AddPlayer
    
    func test_Game_WhenAddPlayerCalled_ShouldAddPlayerToPlayersArrayWithCorrectPosition() {
        // given
        let player = Player(name: "", position: 0)
        let players = Array(repeating: player, count: Int.random(in: 1...5))
        var sut = Game(basicGameWithPlayers: players)
        
        // when
        sut.addPlayer()
        
        // then
        XCTAssertEqual(sut.players.count, players.indices.upperBound + 1)
        XCTAssertTrue(sut.players.last?.hasDefaultName ?? false)
        XCTAssertEqual(sut.players.last?.position, players.indices.upperBound)
    }
    
    
    // MARK: - RandomizePlayers
    
    func test_Game_WhenRandomizeCalled_ShouldRandomizePlayersAndSetTheirPosition() {
        // given
        var players = [Player]()
        for i in 1...5 {
            players.append(Player(name: "\(i)", position: 0))
        }
        var sut = Game(basicGameWithPlayers: players)
        
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
    
    
    // MARK: - DeletePlayersAt
    
    func test_Game_WhenDeletePlayerAtCalledOutOfRange_ShouldDoNothing() {
        // given
        let player = Player(name: "", position: 0)
        var sut = Game(basicGameWithPlayers: [player])
        
        // when
        sut.deletePlayerAt(1)
        
        // then
        XCTAssertEqual([player], sut.players)
    }
    
    func test_Game_WhenDeletePlayerAtCalledInRange_ShouldRemovePlayerFromIndexAndSetPositions() {
        // given

        let player1 = Player(name: UUID().uuidString, position: 0)
        let player2 = Player(name: UUID().uuidString, position: 0)
        let player3 = Player(name: UUID().uuidString, position: 0)
        var players = [player1, player2, player3]
        
        var sut = Game(basicGameWithPlayers: players)
        let playerToRemoveIndex = Int.random(in: 0...2)
        
        // when
        sut.deletePlayerAt(playerToRemoveIndex)
        players.remove(at: playerToRemoveIndex)
        players.setPositions()
        
        // then)
        XCTAssertEqual(sut.players, players)
        for (index, player) in sut.players.enumerated() {
            XCTAssertEqual(player.position, index)
        }
    }
}

class GameMock: GameProtocol {
    
    convenience init(players: [Player]) {
        self.init()
        self.players = players
    }
    
    var gameType: GameType = .basic
    var gameEndType: GameEndType = .none
    var numberOfRounds: Int? 
    var endingScore: Int?
    var numberOfPlayers: Int = 0
    var currentRound: Int = 0
    var players: [Player] = []
    
    var playerNameChangedCalledCount = 0
    var playerNameChangedIndex: Int?
    var playerNameChangedName: String?
    func playerNameChanged(withIndex index: Int, toName name: String) {
        self.playerNameChangedCalledCount += 1
        self.playerNameChangedIndex = index
        self.playerNameChangedName = name
    }
    
    var movePlayerAtCalledCount = 0
    var movePlayerAtSourceRowIndex: Int?
    var movePlayerAtDestinationRowIndex: Int?
    func movePlayerAt(_ sourceRowIndex: Int, to destinationRowIndex: Int) {
        movePlayerAtCalledCount += 1
        movePlayerAtSourceRowIndex = sourceRowIndex
        movePlayerAtDestinationRowIndex = destinationRowIndex
    }
    
    var addPlayerCalledCount = 0
    func addPlayer() {
        addPlayerCalledCount += 1
    }
    
    var randomizePlayersCalledCount = 0
    func randomizePlayers() {
        randomizePlayersCalledCount += 1
    }
    
    var deletePlayerAtCalledCount = 0
    func deletePlayerAt(_ index: Int) {
        deletePlayerAtCalledCount += 1
    }
}
