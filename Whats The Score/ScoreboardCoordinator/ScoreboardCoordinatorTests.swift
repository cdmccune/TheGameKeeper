//
//  ScoreboardCoordinatorTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 3/21/24.
//

import XCTest
@testable import Whats_The_Score

final class ScoreboardCoordinatorTests: XCTestCase {
    
    // MARK: - Start

    func test_ScoreboardCoordinator_WhenStartCalledGameNil_ShouldDoNothingToNavigationCoordinator() {
        // given
        let navigationController = RootNavigationController()
        let sut = ScoreboardCoordinator(navigationController: navigationController)
        sut.game = nil
        
        // when
        sut.start()
        
        // then
        XCTAssertTrue(navigationController.viewControllers.isEmpty)
    }
    
    func test_ScoreboardCoordinator_WhenStartCalledGameNotNil_ShouldSetScoreboardViewControllerAsOnlyNavigationControllerViewController() {
        // given
        let navigationController = RootNavigationController()
        let sut = ScoreboardCoordinator(navigationController: navigationController)
        sut.game = GameMock()
        
        // when
        sut.start()
        
        // then
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        XCTAssertTrue(navigationController.viewControllers.first is ScoreboardViewController)
    }
    
    func test_ScoreboardCoordinator_WhenStartCalled_ShouldSetScoreboardViewModelWithGameEqualToItsGame() {
        // given
        let navigationController = RootNavigationController()
        let sut = ScoreboardCoordinator(navigationController: navigationController)
        let game = GameMock()
        sut.game = game
        
        // when
        sut.start()
        
        // then
        let scoreboardVC = navigationController.viewControllers.first as? ScoreboardViewController
        XCTAssertNotNil(scoreboardVC?.viewModel)
        XCTAssertTrue(scoreboardVC?.viewModel?.game.isEqualTo(game: game) ?? false)
    }

}
