//
//  HomeTabCoordinatorTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 3/20/24.
//

import XCTest
@testable import Whats_The_Score

final class HomeTabCoordinatorTests: XCTestCase {
    
    // MARK: - Start

    func test_HomeTabCoordinator_WhenStartCalled_ShouldAddHomeViewControllerToNavigationStack() {
        // given
        let sut = HomeTabCoordinator(navigationController: RootNavigationController())
        
        // when
        sut.start()
        
        // then
        XCTAssertTrue(sut.navigationController.viewControllers.first is HomeViewController)
    }
    
    func test_HomeTabCoordinator_WhenStartCalled_ShouldSetSelfAsHomeViewControllersCoordinator() {
        // given
        let sut = HomeTabCoordinator(navigationController: RootNavigationController())
        
        // when
        sut.start()
        
        // then
        let homeVC = sut.navigationController.viewControllers.first as? HomeViewController
        XCTAssertTrue(sut === homeVC?.coordinator)
    }
    
    
    // MARK: - SetupNewGame
    
    func test_HomeTabCoordinator_WhenSetupNewGameCalled_ShouldCallCoordinatorSetupNewGame() {
        // given
        let sut = HomeTabCoordinator(navigationController: RootNavigationController())
        let coordinator = MainCoordinatorMock()
        sut.coordinator = coordinator
        
        // when
        sut.setupNewGame()
        
        // then
        XCTAssertEqual(coordinator.setupNewGameCalledCount, 1)
    }

}

class HomeTabCoordinatorMock: HomeTabCoordinator {
    var setupNewGameCalledCount = 0
    override func setupNewGame() {
        setupNewGameCalledCount += 1
    }
}
