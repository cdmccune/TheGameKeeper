//
//  GameSetupViewModelTests.swift
//  What's The Score Tests
//
//  Created by Curt McCune on 12/30/23.
//

import XCTest
@testable import Whats_The_Score

final class GameSetupViewModelTests: XCTestCase {
    
    func test_GameSetupViewModel_WhenSetInitialValuesCalled_ShouldSetValuesCorrectly() {
        // given
        let sut = GameSetupViewModel()
        
        sut.gameType.value = .round
        sut.gameEndType.value = .score
        sut.numberOfRounds.value = 10
        sut.endingScore.value = 10
        sut.numberOfPlayers.value = 10
        
        // when
        sut.setInitialValues()
        
        // then
        XCTAssertEqual(sut.gameType.value, .basic)
        XCTAssertEqual(sut.gameEndType.value, GameEndType.none)
        XCTAssertNil(sut.numberOfRounds.value)
        XCTAssertNil(sut.endingScore.value)
        XCTAssertEqual(sut.numberOfPlayers.value, 2)
    }

}

class GameSetupViewModelMock: GameSetupViewModel {
    var setInitialValuesCalledCount = 0
    override func setInitialValues() {
        setInitialValuesCalledCount += 1
    }
}
