//
//  GameSetupCoordinatorTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 3/21/24.
//

import XCTest
@testable import Whats_The_Score

final class GameSetupCoordinatorTests: XCTestCase {

    // MARK: - Start
    
    func test_GameSetupCoordinator_WhenStartCalled_ShouldSetNavigationControllerViewControllerAsGameTypeSelectionViewController() {
        // given
        let navigationController = RootNavigationController()
        let sut = GameSetupCoordinator(navigationController: navigationController)
        
        // when
        sut.start()
        
        // then
        XCTAssertTrue(navigationController.viewControllers.first is GameTypeSelectionViewController)
    }
    
    func test_GameSetupCoordinator_WhenStartCalled_ShouldSetGameTypeSelectionViewControllerCoordinatorAsSelf() {
        // given
        let navigationController = RootNavigationController()
        let sut = GameSetupCoordinator(navigationController: navigationController)
        
        // when
        sut.start()
        
        // then
        let gameTypeSelectionVC = navigationController.viewControllers.first as? GameTypeSelectionViewController
        XCTAssertTrue(gameTypeSelectionVC?.coordinator === sut)
    }

    
    // MARK: - GameTypeSelected
    
    func test_GameSetupCoordinator_WhenGameTypeSelectedCalledRound_ShouldPushGameEndTypeSelectionViewController() {
        // given
        let navigationController = RootNavigationControllerPushMock()
        let sut = GameSetupCoordinator(navigationController: navigationController)
        
        // when
        sut.gameTypeSelected(.round)
        
        // then
        XCTAssertEqual(navigationController.pushViewControllerCount, 1)
        XCTAssertTrue(navigationController.pushedViewController is GameEndTypeSelectionViewController)
    }
    
    func test_GameSetupCoordinator_WhenGameTypeSelectedCalledRound_ShouldSetSelfAsGameEndTypeSelectionViewController() {
        // given
        let navigationController = RootNavigationControllerPushMock()
        let sut = GameSetupCoordinator(navigationController: navigationController)
        
        // when
        sut.gameTypeSelected(.round)
        
        // then
        let gameEndTypeSelectionVC = navigationController.pushedViewController as? GameEndTypeSelectionViewController
        XCTAssertTrue(gameEndTypeSelectionVC?.coordinator === sut)
         
    }
    
    func test_GameSetupCoordinator_WhenGameTypeSelectedCalledBasic_ShouldPushPlayerSetupViewController() {
        // given
        let navigationController = RootNavigationControllerPushMock()
        let sut = GameSetupCoordinator(navigationController: navigationController)
        
        // when
        sut.gameTypeSelected(.basic)
        
        // then
        XCTAssertEqual(navigationController.pushViewControllerCount, 1)
        XCTAssertTrue(navigationController.pushedViewController is PlayerSetupViewController)
    }
    
    
    // MARK: - GameEndTypeSelected
    
    func test_GameSetupCoordinator_WhenGameEndTypeSelectedCalledNone_ShouldPushPlayerSetupViewController() {
        // given
        let navigationController = RootNavigationControllerPushMock()
        let sut = GameSetupCoordinator(navigationController: navigationController)
        
        // when
        sut.gameEndTypeSelected(GameEndType.none)
        
        // then
        XCTAssertEqual(navigationController.pushViewControllerCount, 1)
        XCTAssertTrue(navigationController.pushedViewController is PlayerSetupViewController)
    }
    
    func test_GameSetupCoordinator_WhenGameEndTypeSelectedCalledRound_ShouldPushGameEndQuantitySelectionViewController() {
        // given
        let navigationController = RootNavigationControllerPushMock()
        let sut = GameSetupCoordinator(navigationController: navigationController)
        
        // when
        sut.gameEndTypeSelected(GameEndType.round)
        
        // then
        XCTAssertEqual(navigationController.pushViewControllerCount, 1)
        XCTAssertTrue(navigationController.pushedViewController is GameEndQuantitySelectionViewController)
    }
    
    func test_GameSetupCoordinator_WhenGameEndTypeSelectedCalledRound_ShouldSetGameEndQuantitySelectionViewControllerCoordinatorAsSelf() {
        // given
        let navigationController = RootNavigationControllerPushMock()
        let sut = GameSetupCoordinator(navigationController: navigationController)
        
        // when
        sut.gameEndTypeSelected(GameEndType.round)
        
        // then
        let gameEndQuantityVC = navigationController.pushedViewController as? GameEndQuantitySelectionViewController
        XCTAssertTrue(gameEndQuantityVC?.coordinator === sut)
    }
    
    func test_GameSetupCoordinator_WhenGameEndTypeSelectedCalledScore_ShouldPushGameEndQuantitySelectionViewController() {
        // given
        let navigationController = RootNavigationControllerPushMock()
        let sut = GameSetupCoordinator(navigationController: navigationController)
        
        // when
        sut.gameEndTypeSelected(GameEndType.score)
        
        // then
        XCTAssertEqual(navigationController.pushViewControllerCount, 1)
        XCTAssertTrue(navigationController.pushedViewController is GameEndQuantitySelectionViewController)
    }
    
    func test_GameSetupCoordinator_WhenGameEndTypeSelectedCalledScore_ShouldSetGameEndQuantitySelectionViewControllerCoordinatorAsSelf() {
        // given
        let navigationController = RootNavigationControllerPushMock()
        let sut = GameSetupCoordinator(navigationController: navigationController)
        
        // when
        sut.gameEndTypeSelected(GameEndType.score)
        
        // then
        let gameEndQuantityVC = navigationController.pushedViewController as? GameEndQuantitySelectionViewController
        XCTAssertTrue(gameEndQuantityVC?.coordinator === sut)
    }
    
    
    // MARK: - GameEndQuantitySelected
    
    func test_GameSetupCoordinator_WhenGameEndQuantitySelectedCalled_ShouldPushPlayerSetupViewController() {
        // given
        let navigationController = RootNavigationControllerPushMock()
        let sut = GameSetupCoordinator(navigationController: navigationController)
        
        // when
        sut.gameEndQuantitySelected(0)
        
        // then
        XCTAssertEqual(navigationController.pushViewControllerCount, 1)
        XCTAssertTrue(navigationController.pushedViewController is PlayerSetupViewController)
    }
    
}
