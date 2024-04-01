//
//  GameTypeSelectionViewControllerTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 4/1/24.
//

import XCTest
@testable import Whats_The_Score

final class GameTypeSelectionViewControllerTests: XCTestCase {
    
    // MARK: - Setup

    var viewController: GameTypeSelectionViewController!
    
    override func setUp() {
        viewController = GameTypeSelectionViewController.instantiate()
    }
    
    override func tearDown() {
        viewController = nil
    }
    
    
    // MARK: - BasicButtonTapped
    
    func test_GameTypeSelectionViewController_WhenBasicButtonTappedCalled_ShouldCallCoordinatorGameTypeSelectedWithBasic() {
        // given
        let sut = viewController!
        
        let coordinator = GameSetupCoordinatorMock()
        sut.coordinator = coordinator
        
        // when
        sut.basicButtonTapped(0)
        
        // then
        XCTAssertEqual(coordinator.gameType, .basic)
        XCTAssertEqual(coordinator.gameTypeSelectedCalledCount, 1)
    }
    
    // MARK: - roundButtonTapped
    
    func test_GameTypeSelectionViewController_WhenRoundButtonTappedCalled_ShouldCallCoordinatorGameTypeSelectedWithRound() {
        // given
        let sut = viewController!
        
        let coordinator = GameSetupCoordinatorMock()
        sut.coordinator = coordinator
        
        // when
        sut.roundButtonTapped(0)
        
        // then
        XCTAssertEqual(coordinator.gameType, .round)
        XCTAssertEqual(coordinator.gameTypeSelectedCalledCount, 1)
    }

}
