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
    
    func test_PlayerSetupViewModel_WhenPlayersIsEditing_ShouldBindViewToViewModel() {
        
        class PlayerSetupViewModelDelegateMock: NSObject, PlayerSetupViewModelProtocol {
            var bindViewToViewModelCallCount = 0
            func bindViewToViewModel() {
                bindViewToViewModelCallCount += 1
            }
        }
        
        //given
        var sut = getViewModelWithDefaultSettings()
        let delegateMock = PlayerSetupViewModelDelegateMock()
        sut.delegate = delegateMock
        
        //when
        sut.players = []
        
        //then
        XCTAssertEqual(delegateMock.bindViewToViewModelCallCount, 1)
    }

}

struct PlayerSetupPlayerCoordinatorStub: PlayerSetupPlayerCoordinator {
    var players: [Player]
}
