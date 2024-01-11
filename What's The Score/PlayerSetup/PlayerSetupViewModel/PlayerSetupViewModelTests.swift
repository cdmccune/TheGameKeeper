//
//  PlayerSetupViewModelTests.swift
//  What's The Score Tests
//
//  Created by Curt McCune on 1/3/24.
//

import XCTest
@testable import What_s_The_Score

final class PlayerSetupViewModelTests: XCTestCase {
    
    func getViewModelWithDefaultSettings() -> PlayerSetupViewModel {
        let gameSettings = GameSettings(gameType: .basic,
                                        gameEndType: .none,
                                        numberOfRounds: 1,
                                        numberOfPlayers: 2)
        
        return PlayerSetupViewModel(gameSettings: gameSettings)
    }

    func test_PlayerSetupViewModel_WhenInitializedSet_ShouldSetupArrayOfPlayersWithLengthNumberOfPlayersAndCorrectNames() {
        //given
        let numberOfPlayers = Int.random(in: 1...10)
        let gameSettings = GameSettings(gameType: .round,
                                        gameEndType: .none,
                                        numberOfRounds: 0,
                                        numberOfPlayers: numberOfPlayers)
        
        //when
        let sut = PlayerSetupViewModel(gameSettings: gameSettings)
        
        //then
        XCTAssertEqual(sut.players.count, numberOfPlayers)
        XCTAssertEqual(sut.players.last?.name, "Player \(numberOfPlayers)")
    }
    
    func test_PlayerSetupViewModel_WhenPlayersIsChanged_ShouldBindViewToViewModel() {
        
        //given
        var sut = getViewModelWithDefaultSettings()
        let delegateMock = PlayerSetupViewModelDelegateMock()
        sut.delegate = delegateMock
        
        //when
        sut.players = []
        
        //then
        XCTAssertEqual(delegateMock.bindViewToViewModelCallCount, 1)
    }
    
    func test_PlayerSetupViewModel_WhenPlayerNameChangedCalledOutOfPlayerRange_ShouldDoNothing() {
        //given
        var sut = getViewModelWithDefaultSettings()
        let player = Player(name: "", position: 0)
        sut.players = [player]
        
        //when
        sut.playerNameChanged(withIndex: 1, toName: "test")
        
        //then
        XCTAssertEqual(sut.players[0], player)
    }
    
    func test_PlayerSetupViewModel_WhenPlayerNameChangedCalledInRangePlayer_ShouldChangeTheNameOfPlayer() {
        //given
        var sut = getViewModelWithDefaultSettings()
        let player = Player(name: "", position: 0)
        sut.players = [player]
        
        let testString = UUID().uuidString
        let viewDelegate = PlayerSetupViewModelDelegateMock()
        sut.delegate = viewDelegate
        
        //when
        sut.playerNameChanged(withIndex: 0, toName: testString)
        
        //then
        XCTAssertEqual(sut.players[0].name, testString)
    }
    
    func test_PlayerSetupViewModel_WhenMovePlayerAtCalledSourceOutsideRange_ShouldDoNothing() {
        //given
        var sut = getViewModelWithDefaultSettings()
        let player1 = Player(name: UUID().uuidString, position: 0)
        let player2 = Player(name: UUID().uuidString, position: 0)
        let players = [player1, player2]
        sut.players = players
        
        //when
        sut.movePlayerAt(4, to: 0)

        
        //then
        XCTAssertEqual(sut.players, players)
    }
    
    func test_PlayerSetupViewModel_WhenMovePlayerAtCalledDestinationOutsideRange_ShouldDoNothing() {
        //given
        var sut = getViewModelWithDefaultSettings()
        let player1 = Player(name: UUID().uuidString, position: 0)
        let player2 = Player(name: UUID().uuidString, position: 0)
        let players = [player1, player2]
        sut.players = players
        
        //when
        sut.movePlayerAt(0, to: 5)

        
        //then
        XCTAssertEqual(sut.players, players)
    }
    
    func test_PlayerSetupViewModel_WhenMovePlayerAtCalledInRange_ShouldChangePlayersPostionsInArrayAndPositionValue() {
        //given
        var sut = getViewModelWithDefaultSettings()
        
        let player1Name = UUID().uuidString
        let player1 = Player(name: player1Name, position: 0)
        
        let player2Name = UUID().uuidString
        let player2 = Player(name: player2Name, position: 1)
        
        let players = [player1, player2]
        sut.players = players
        
        //when
        sut.movePlayerAt(0, to: 1)
        
        //then
        XCTAssertEqual(sut.players[0].name, player2Name)
        XCTAssertEqual(sut.players[0].position, 0)
        XCTAssertEqual(sut.players[1].name, player1Name)
        XCTAssertEqual(sut.players[1].position, 1)
    }

}

struct PlayerSetupPlayerCoordinatorMock: PlayerSetupPlayerCoordinator {
    var players: [Player]
    
    var playerNameChangedIndex: Int?
    var playerNameChangedName: String?
    mutating func playerNameChanged(withIndex index: Int, toName name: String) {
        self.playerNameChangedIndex = index
        self.playerNameChangedName = name
    }
    
    var movePlayerAtSourceRow: Int?
    var movePlayerAtDestinationRow: Int?
    var movePlayerAtCalledCount: Int = 0
    mutating func movePlayerAt(_ sourceRowIndex: Int, to destinationRowIndex: Int) {
        self.movePlayerAtSourceRow = sourceRowIndex
        self.movePlayerAtDestinationRow = destinationRowIndex
        self.movePlayerAtCalledCount += 1
    }
}

class PlayerSetupViewModelDelegateMock: NSObject, PlayerSetupViewModelProtocol {
    var bindViewToViewModelCallCount = 0
    func bindViewToViewModel() {
        bindViewToViewModelCallCount += 1
    }
}
