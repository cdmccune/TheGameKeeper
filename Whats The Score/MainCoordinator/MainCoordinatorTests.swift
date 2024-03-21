//
//  MainCoordinatorTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 3/20/24.
//

import XCTest
@testable import Whats_The_Score

final class MainCoordinatorTests: XCTestCase {
    
    // MARK: - Start

    func test_MainCoordinator_WhenStartCalled_ShouldSetChildCoordinatorsToHomeTabCoordinatorAndGameTabCoordinator() {
        // given
        let sut = MainCoordinator()
        
        // when
        sut.start()
        
        // then
        XCTAssertTrue(sut.childCoordinators.first is HomeTabCoordinator)
        XCTAssertTrue(sut.childCoordinators[1] is GameTabCoordinator)
    }
    
    func test_MainCoordinator_WhenStartCalled_ShouldSetFirstTabbarViewControllerToHomeTabCoordinatorNavigationController() {
        // given
        let sut = MainCoordinator()
        
        // when
        sut.start()
        
        // then
        XCTAssertTrue(sut.tabbarController.viewControllers?.first === sut.childCoordinators.first?.navigationController)
    }
    
    func test_MainCoordinator_WhenStartCalled_ShouldSetHomeTabbarCoordinatorTabbarItemToHomeWithCorrectImage() {
        // given
        let sut = MainCoordinator()
        
        // when
        sut.start()
        
        // then
        let tabbarItem = sut.childCoordinators.first?.navigationController.tabBarItem
        XCTAssertEqual(tabbarItem?.image, UIImage(systemName: "house"))
        XCTAssertEqual(tabbarItem?.title, "Home")
    }
    
    func test_MainCoordinator_WhenStartCalled_ShouldSetSecondTabbarViewControllerToGameTabCoordinatorNavigationController() {
        // given
        let sut = MainCoordinator()
        
        // when
        sut.start()
        
        // then
        XCTAssertTrue(sut.tabbarController.viewControllers?[1] === sut.childCoordinators[1].navigationController)
    }
    
    func test_MainCoordinator_WhenStartCalled_ShouldSetGameTabbarCoordinatorTabbarItemToGameWithCorrectImage() {
        // given
        let sut = MainCoordinator()
        
        // when
        sut.start()
        
        // then
        let tabbarItem = sut.childCoordinators[1].navigationController.tabBarItem
        XCTAssertEqual(tabbarItem?.image, UIImage(systemName: "dice"))
        XCTAssertEqual(tabbarItem?.title, "Game")
    }
    
    func test_MainCoordinator_WhenStartCalled_ShouldCallStartOnHomeTabCoordinator() {
        
        class HomeTabCoordinatorMock: HomeTabCoordinator {
            var startCalledCount = 0
            override func start() {
                startCalledCount += 1
            }
        }
        
        // given
        let sut = MainCoordinator()
        sut.homeTabbarCoordinatorType = HomeTabCoordinatorMock.self
        
        // when
        sut.start()
        
        // then
        let homeTabCoordinatorMock = sut.childCoordinators.first as? HomeTabCoordinatorMock
        XCTAssertEqual(homeTabCoordinatorMock?.startCalledCount, 1)
    }
    
    func test_MainCoordinator_WhenStartCalled_ShouldCallSelfAsHomeTabCoordinatorCoordinator() {
        
        class HomeTabCoordinatorMock: HomeTabCoordinator {
            var startCalledCount = 0
            override func start() {
                startCalledCount += 1
            }
        }
        
        // given
        let sut = MainCoordinator()
        
        // when
        sut.start()
        
        // then
        let homeTabCoordinatorMock = sut.childCoordinators.first as? HomeTabCoordinator
        XCTAssertTrue(homeTabCoordinatorMock?.coordinator === sut)
    }

    
    func test_MainCoordinator_WhenStartCalled_ShouldCallStartOnGameTabCoordinator() {
        
        class GameTabCoordinatorMock: GameTabCoordinator {
            var startCalledCount = 0
            override func start() {
                startCalledCount += 1
            }
        }
        
        // given
        let sut = MainCoordinator()
        sut.gameTabbarCoordinatorType = GameTabCoordinatorMock.self
        
        // when
        sut.start()
        
        // then
        let gameTabCoordinatorMock = sut.childCoordinators[1] as? GameTabCoordinatorMock
        XCTAssertEqual(gameTabCoordinatorMock?.startCalledCount, 1)
    }
    
    
    // MARK: - SetupNewGame

    func test_MainCoordinator_WhenSetupNewGameCalled_ShouldSelectGameTab() {
        // given
        let sut = MainCoordinator()
        sut.start()
        
        // when
        sut.setupNewGame()
        
        // then
        XCTAssertEqual(sut.tabbarController.selectedIndex, 1)
    }
}
