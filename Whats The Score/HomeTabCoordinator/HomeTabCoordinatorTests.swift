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
    
    func test_HomeTabCoordinator_WhenStartCalled_ShouldSetActiveGameOnHomeVCActiveGame() {
        // given
        let sut = HomeTabCoordinator(navigationController: RootNavigationController())
        let activeGame = GameMock()
        sut.activeGame = activeGame
        
        // when
        sut.start()
        
        // then
        let homeVC = sut.navigationController.viewControllers.first as? HomeViewController
        XCTAssertEqual(homeVC?.activeGame?.id, activeGame.id)
    }
    
    func test_HomeTabCoordinator_WhenStartCalledHasActiveGameError_ShouldCallShowActiveGameError() {
        class HomeTabCoordinatorShowActiveGameErrorMock: HomeTabCoordinator {
            var showActiveGameErrorError: CoreDataStoreError?
            var showActiveGameErrorCalledCount = 0
            override func showActiveGameError(_ error: CoreDataStoreError) {
                showActiveGameErrorError = error
                showActiveGameErrorCalledCount += 1
            }
        }
        
        // given
        let sut = HomeTabCoordinatorShowActiveGameErrorMock(navigationController: RootNavigationController())
        
        let errorDescription = UUID().uuidString
        let error = CoreDataStoreError.dataError(description: errorDescription)
        sut.activeGameError = error
        
        // when
        sut.start()
        
        // then
        XCTAssertEqual(sut.showActiveGameErrorCalledCount, 1)
        if case CoreDataStoreError.dataError(let description) = sut.showActiveGameErrorError! {
            XCTAssertEqual(description, errorDescription)
        } else {
            XCTFail("Error should be sent in function")
        }
    }

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
    
    func test_HomeTabCoordinator_WhenSetupQuickGameCalled_ShouldCallCoordinatorsSetupQuickGame() {
        // given
        let sut = HomeTabCoordinator(navigationController: RootNavigationController())
        let coordinator = MainCoordinatorMock()
        sut.coordinator = coordinator
        
        // when
        sut.setupQuickGame()
        
        // then
        XCTAssertEqual(coordinator.setupQuickGameCalledCount, 1)
    }
    
    
    // MARK: - PlayActiveGame
    
    func test_HomeTabCoordinator_WhenPlayActiveGameCalled_ShouldCallMainCoordinatorPlayActiveGame() {
        // given
        let sut = HomeTabCoordinator(navigationController: RootNavigationController())
        let coordinator = MainCoordinatorMock()
        sut.coordinator = coordinator
        
        // when
        sut.playActiveGame()
        
        // then
        XCTAssertEqual(coordinator.playActiveGameCalledCount, 1)
    }
    
    
    // MARK: - ShowActiveGameError
    
    func test_HomeTabCoordinator_WhenShowActiveGameErrorCalled_ShouldPresentAlertControllerOnTopViewControllerAfterDelayOfPoint25() {
        // given
        let sut = HomeTabCoordinator(navigationController: RootNavigationController())
        let viewController = ViewControllerPresentMock()
        sut.navigationController.viewControllers = [viewController]
        
        let dispatchQueueMock = DispatchQueueMainMock()
        sut.dispatchQueue = dispatchQueueMock
        
        // when
        sut.showActiveGameError(CoreDataStoreError.dataError(description: ""))
        
        // then
        
        XCTAssertEqual(dispatchQueueMock.asyncAfterDelay, 0.25)
        XCTAssertEqual(dispatchQueueMock.asyncAfterCalledCount, 1)
        XCTAssertEqual(viewController.presentCalledCount, 1)
    }
    
    func test_HomeTabCoordinator_WhenShowActiveGameErrorCalled_ShouldPresentAlertControllerOnTopViewControllerWithAlertControllerTitleErrorMessageErrorDescription() {
        // given
        let sut = HomeTabCoordinator(navigationController: RootNavigationController())
        let viewController = ViewControllerPresentMock()
        sut.navigationController.viewControllers = [viewController]
        
        let dispatchQueueMock = DispatchQueueMainMock()
        sut.dispatchQueue = dispatchQueueMock
        
        let errorDescription = UUID().uuidString
        let error = CoreDataStoreError.dataError(description: errorDescription)
        
        // when
        sut.showActiveGameError(error)
        
        // then
        let alertVC = viewController.presentViewController as? UIAlertController
        XCTAssertNotNil(alertVC)
        XCTAssertEqual(alertVC?.title, "Error")
        XCTAssertEqual(alertVC?.message, errorDescription)
    }
    
    func test_HomeTabCoordinator_WhenShowActiveGameErrorCalled_ShouldAddOkActionToAlertControllerPresented() {
        // given
        let sut = HomeTabCoordinator(navigationController: RootNavigationController())
        let viewController = ViewControllerPresentMock()
        sut.navigationController.viewControllers = [viewController]
        
        let dispatchQueueMock = DispatchQueueMainMock()
        sut.dispatchQueue = dispatchQueueMock
        
        // when
        sut.showActiveGameError(CoreDataStoreError.dataError(description: ""))
        
        // then
        let alertVC = viewController.presentViewController as? UIAlertController
        XCTAssertEqual(alertVC?.actions.first?.title, "OK")
    }

}

class HomeTabCoordinatorMock: HomeTabCoordinator {
    var setupNewGameCalledCount = 0
    override func setupNewGame() {
        setupNewGameCalledCount += 1
    }
    
    var setupQuickGameCalledCount = 0
    override func setupQuickGame() {
        setupQuickGameCalledCount += 1
    }
    
    var playActiveGameCalledCount = 0
    override func playActiveGame() {
        playActiveGameCalledCount += 1
    }
}
