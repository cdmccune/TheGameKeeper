//
//  GameEndTypeSelectionViewControllerTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 4/1/24.
//

import XCTest
@testable import Whats_The_Score

final class GameEndTypeSelectionViewControllerTests: XCTestCase {

    // MARK: - Setup

    var viewController: GameEndTypeSelectionViewController!
    
    override func setUp() {
        viewController = GameEndTypeSelectionViewController.instantiate()
    }
    
    override func tearDown() {
        viewController = nil
    }
    
    
    // MARK: - NoneButtonTapped
    
    func test_GameEndTypeSelectionViewController_WhenNoneButtonTapped_ShouldCallGameSetupCoordinatorGameEndTypeSelectedWithNoneType() {
        // given
        let sut = viewController!
        
        let coordinator = GameSetupCoordinatorMock()
        sut.coordinator = coordinator
        
        // when
        sut.noneButtonTapped(0)
        
        // then
        XCTAssertEqual(coordinator.gameEndType, GameEndType.none)
        XCTAssertEqual(coordinator.gameEndTypeSelectedCalledCount, 1)
    }
    
    
    // MARK: - RoundButtonTapped
    
    func test_GameEndTypeSelectionViewController_WhenRoundButtonTapped_ShouldCallGameSetupCoordinatorGameEndTypeSelectedWithRoundType() {
        // given
        let sut = viewController!
        
        let coordinator = GameSetupCoordinatorMock()
        sut.coordinator = coordinator
        
        // when
        sut.roundButtonTapped(0)
        
        // then
        XCTAssertEqual(coordinator.gameEndType, GameEndType.round)
        XCTAssertEqual(coordinator.gameEndTypeSelectedCalledCount, 1)
    }
    
    
    // MARK: - RoundButtonTapped
    
    func test_GameEndTypeSelectionViewController_WhenScoreButtonTapped_ShouldCallGameSetupCoordinatorGameEndTypeSelectedWithScoreType() {
        // given
        let sut = viewController!
        
        let coordinator = GameSetupCoordinatorMock()
        sut.coordinator = coordinator
        
        // when
        sut.scoreButtonTapped(0)
        
        // then
        XCTAssertEqual(coordinator.gameEndType, GameEndType.score)
        XCTAssertEqual(coordinator.gameEndTypeSelectedCalledCount, 1)
    }
    
}
