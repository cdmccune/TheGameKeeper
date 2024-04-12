//
//  MainCoordinatorTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 3/20/24.
//

import XCTest
@testable import Whats_The_Score

final class MainCoordinatorTests: XCTestCase {
    
    // MARK: - Properties
    
    func test_MainCoordinator_WhenCoreDataHelperInitialiazed_ShouldSetItsCoreDataStoreAsSelf() {
        // given
        let coreDataStore = CoreDataStoreMock()
        let sut = MainCoordinatorMock(coreDataStore: coreDataStore)
        
        // when
        let coreDataHelper = sut.coreDataHelper
        
        // then
        XCTAssertTrue(coreDataHelper.coreDataStore as? CoreDataStoreMock === coreDataStore)
    }
    
    
    // MARK: - Start
    
    func test_MainCoordinator_WhenStartCalled_ShouldCallCoreDataHelperGetActiveGame() {
        // given
        let sut = MainCoordinator()
        let coreDataHelper = MainCoordinatorCoreDataHelperMock()
        sut.coreDataHelper = coreDataHelper
        
        // when
        sut.start()
        
        // then
        XCTAssertEqual(coreDataHelper.getActiveGameCalledCount, 1)
    }
    
    func test_MainCoordinator_WhenStartCalledGetActiveGameReturnsGame_ShouldSetHomeTabCoordinatorActiveGame() {
        // given
        let sut = MainCoordinator()
        let coreDataHelper = MainCoordinatorCoreDataHelperMock()
        let gameToReturn = GameMock()
        coreDataHelper.getActiveGameGameToReturn = gameToReturn
        sut.coreDataHelper = coreDataHelper
        
        // when
        sut.start()
        
        // then
        let homeTabCoordinator = sut.childCoordinators.first as? HomeTabCoordinator
        XCTAssertEqual(homeTabCoordinator?.activeGame?.id, gameToReturn.id)
    }
    
    func test_MainCoordinator_WhenStartCalledGetActiveGameReturnsGame_ShouldSetGameTabCoordinatorActiveGame() {
        // given
        let sut = MainCoordinator()
        let coreDataHelper = MainCoordinatorCoreDataHelperMock()
        let gameToReturn = GameMock()
        coreDataHelper.getActiveGameGameToReturn = gameToReturn
        sut.coreDataHelper = coreDataHelper
        
        // when
        sut.start()
        
        // then
        let gameTabCoordinator = sut.childCoordinators[1] as? GameTabCoordinator
        XCTAssertEqual(gameTabCoordinator?.activeGame?.id, gameToReturn.id)
    }
    
    func test_MainCoordinator_WhenStartCalledGetActiveGameThrowsError_ShouldSetHomeTabCoordinatorActiveGameError() {
        // given
        let sut = MainCoordinator()
        let coreDataHelper = MainCoordinatorCoreDataHelperMock()
        
        let errorDescription = UUID().uuidString
        let errorToReturn = CoreDataStoreError.dataError(description: errorDescription)
        coreDataHelper.getActiveGameErrorToReturn = errorToReturn
        sut.coreDataHelper = coreDataHelper
        
        // when
        sut.start()
        
        // then
        let homeTabCoordinator = sut.childCoordinators.first as? HomeTabCoordinator
        if case CoreDataStoreError.dataError(let description) = homeTabCoordinator!.activeGameError! {
            XCTAssertEqual(description, errorDescription)
        } else {
            XCTFail("Should set error")
        }
    }

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
        // given
        let sut = MainCoordinator()
        
        // when
        sut.start()
        
        // then
        let homeTabCoordinatorMock = sut.childCoordinators.first as? HomeTabCoordinator
        XCTAssertTrue(homeTabCoordinatorMock?.coordinator === sut)
    }
    
    func test_MainCoordinator_WhenStartCalled_ShouldCallSelfAsGameTabCoordinatorCoordinator() {
        // given
        let sut = MainCoordinator()
        
        // when
        sut.start()
        
        // then
        let gameTabCoordinator = sut.childCoordinators[1] as? GameTabCoordinator
        XCTAssertTrue(gameTabCoordinator?.coordinator === sut)
    }
    
    func test_MainCoordinator_WhenStartCalled_ShouldSetHomeTabbarCoordinatorCoreDataStoreToOwnCoreDataStore() {
        // given
        let coreDataStoreMock = CoreDataStoreMock()
        let sut = MainCoordinator(coreDataStore: coreDataStoreMock)
        sut.homeTabbarCoordinatorType = HomeTabCoordinatorMock.self
        
        // when
        sut.start()
        
        // then
        let homeTabCoordinatorMock = sut.childCoordinators[0] as? HomeTabCoordinatorMock
        XCTAssertTrue(homeTabCoordinatorMock?.coreDataStore as? CoreDataStoreMock === coreDataStoreMock)
    }

    func test_MainCoordinator_WhenStartCalled_ShouldSetGameTabbarCoordinatorCoreDataStoreToOwnCoreDataStore() {
        // given
        let coreDataStoreMock = CoreDataStoreMock()
        let sut = MainCoordinator(coreDataStore: coreDataStoreMock)
        sut.gameTabbarCoordinatorType = GameTabCoordinatorMock.self
        
        // when
        sut.start()
        
        // then
        let gameTabCoordinatorMock = sut.childCoordinators[1] as? GameTabCoordinatorMock
        XCTAssertTrue(gameTabCoordinatorMock?.coreDataStore as? CoreDataStoreMock === coreDataStoreMock)
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
    
    func test_MainCoordinator_WhenSetupNewGameCalled_ShouldSetGameTabCoordinatorActiveGameToNilThenCallStart() {
        class GameTabCoordinatorStartMock: GameTabCoordinator {
            var startCalledCount = 0
            var startActiveGame: GameProtocol?
            override func start() {
                startCalledCount += 1
                startActiveGame = activeGame
            }
        }
        
        // given
        let sut = MainCoordinator()
        let gameTabCoordinator = GameTabCoordinatorStartMock(navigationController: RootNavigationController())
        sut.childCoordinators = [gameTabCoordinator]
        gameTabCoordinator.activeGame = GameMock()
        
        // when
        sut.setupNewGame()
        
        // then
        XCTAssertEqual(gameTabCoordinator.startCalledCount, 1)
        XCTAssertNil(gameTabCoordinator.startActiveGame)
    }

    func test_MainCoordinator_WhenSetupNewGameCalled_ShouldSelectGameTab() {
        // given
        let sut = MainCoordinator()
        sut.start()
        
        // when
        sut.setupNewGame()
        
        // then
        XCTAssertEqual(sut.tabbarController.selectedIndex, 1)
    }
    
    // MARK: - SetupQuickGame
    
    func test_MainCoordinator_WhenSetupQuickGameCalled_ShouldCallStartQuickGameOnGameTabCoordinator() {
        // given
        let sut = MainCoordinator()
        sut.gameTabbarCoordinatorType = GameTabCoordinatorMock.self
        sut.start()
        
        // when
        sut.setupQuickGame()
        
        // then
        let gameTabCoordinator = sut.childCoordinators.first { $0 is GameTabCoordinatorMock } as? GameTabCoordinatorMock
        XCTAssertEqual(gameTabCoordinator?.startQuickGameCalledCount, 1)
    }
    
    func test_MainCoordinator_WhenSetupQuickGameCalled_ShouldSelectGameTab() {
        // given
        let sut = MainCoordinator()
        sut.start()
        sut.setupQuickGame()
        
        // when
        sut.setupNewGame()
        
        // then
        XCTAssertEqual(sut.tabbarController.selectedIndex, 1)
    }
    
    // MARK: - PlayActiveGame

    func test_MainCoordinator_WhenPlayActiveGameCalled_ShouldSelectGameTab() {
        // given
        let sut = MainCoordinator()
        sut.start()
        
        // when
        sut.playActiveGame()
        
        // then
        XCTAssertEqual(sut.tabbarController.selectedIndex, 1)
    }
    
    
    // MARK: - GameTabGameMadeActive
    
    func test_GameTabCoordinator_WhenGameTabGameCreatedCalled_ShouldSetGameToHomeTabCoordinatorsActiveGameBeforeCallingStart() {
        class HomeTabCoordinatorStartMock: HomeTabCoordinator {
            var startCalledCount = 0
            var startActiveGame: GameProtocol?
            override func start() {
                startCalledCount += 1
                startActiveGame = activeGame
            }
        }
        
        
        // given
        let sut = MainCoordinator()
        let homeTabCoordinator = HomeTabCoordinatorStartMock(navigationController: RootNavigationController())
        sut.childCoordinators = [homeTabCoordinator]
        
        let game = GameMock()
        
        // when
        sut.gameTabGameMadeActive(game)
        
        // then
        XCTAssertEqual(homeTabCoordinator.startCalledCount, 1)
        XCTAssertEqual(homeTabCoordinator.startActiveGame?.id, game.id)
    }
    
    
    // MARK: - GameTabActiveGameCompleted
    
    func test_GameTabCoordinator_WhenGameTabActiveGameCompletedCalled_ShouldSetGameToHomeTabCoordinatorsActiveGameToNilBeforeCallingStart() {
        class HomeTabCoordinatorStartMock: HomeTabCoordinator {
            var startCalledCount = 0
            var startActiveGame: GameProtocol?
            override func start() {
                startCalledCount += 1
                startActiveGame = activeGame
            }
        }
        
        
        // given
        let sut = MainCoordinator()
        let homeTabCoordinator = HomeTabCoordinatorStartMock(navigationController: RootNavigationController())
        homeTabCoordinator.activeGame = GameMock()
        sut.childCoordinators = [homeTabCoordinator]
        
        // when
        sut.gameTabActiveGameCompleted()
        
        // then
        XCTAssertEqual(homeTabCoordinator.startCalledCount, 1)
        XCTAssertNil(homeTabCoordinator.startActiveGame)
    }
}
