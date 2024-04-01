//
//  HomeViewControllerTests.swift
//  What's The Score
//
//  Created by Curt McCune on 12/30/23.
//

import XCTest
@testable import Whats_The_Score

final class HomeViewControllerTests: XCTestCase {
    
    var viewController: HomeViewController!
    
    override func setUp() {
        let viewController = HomeViewController.instantiate()
        self.viewController = viewController
    }

    func test_HomeViewController_WhenViewLoaded_ShouldHaveNotNilForOutlets() {
        // given
        let sut = viewController!
        
        // when
        sut.loadView()
        
        // then
        XCTAssertNotNil(sut.titleLabel)
        XCTAssertNotNil(sut.quickStartButton)
        XCTAssertNotNil(sut.setupGameButton)
        
    }
    
    
    // MARK: - SetupGame
    
    func test_HomeViewController_WhenSetupGameButtonTapped_ShouldCallSetupNewGameOnCoordinator() {
        // given
        let sut = viewController!
        
        let coordinator = HomeTabCoordinatorMock(navigationController: RootNavigationController())
        
        sut.coordinator = coordinator
        
        // when
        sut.setupGameButtonTapped(4)
        
        // then
        XCTAssertEqual(coordinator.setupNewGameCalledCount, 1)
    }
    
    
    // MARK: - Quick Start
    
    func test_HomeViewController_WhenQuickStartButtonTapped_ShouldCallCoordinatorsSetupQuickGame() {
        // given
        let sut = viewController!
        
        let coordinator = HomeTabCoordinatorMock(navigationController: RootNavigationController())
        
        sut.coordinator = coordinator
        
        // when
        sut.quickStartButtonTapped(4)
        
        // then
        XCTAssertEqual(coordinator.setupQuickGameCalledCount, 1)
    }

}
