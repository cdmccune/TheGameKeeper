//
//  PlayerSetupViewModelTests.swift
//  What's The Score Tests
//
//  Created by Curt McCune on 1/3/24.
//

import XCTest
@testable import What_s_The_Score

final class PlayerSetupViewModelTests: XCTestCase {

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
    }

}
