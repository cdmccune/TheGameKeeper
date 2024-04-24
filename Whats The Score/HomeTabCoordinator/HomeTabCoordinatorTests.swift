//
//  HomeTabCoordinatorTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 3/20/24.
//

import XCTest
@testable import Whats_The_Score

final class HomeTabCoordinatorTests: XCTestCase {
    
    // MARK: - Properties
    
    func test_HomeTabCoordinator_WhenCoreDataHelperSet_ShouldSetItsCoreDataStoreToOwnCoreDataStore() {
        // given
        let coreDataStore = CoreDataStoreMock()
        let sut = HomeTabCoordinator(navigationController: RootNavigationController(), coreDataStore: coreDataStore)
        
        // when
        let coreDataHelper = sut.coreDataHelper
        
        // then
        XCTAssertTrue(sut.coreDataHelper.coreDataStore as? CoreDataStoreMock === coreDataStore)
    }
    
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
            var showErrorError: CoreDataStoreError?
            var showErrorCalledCount = 0
            override func showError(_ error: CoreDataStoreError) {
                showErrorError = error
                showErrorCalledCount += 1
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
        XCTAssertEqual(sut.showErrorCalledCount, 1)
        if case CoreDataStoreError.dataError(let description) = sut.showErrorError! {
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
    
    func test_HomeTabCoordinator_WhenSetupNewGameCalled_ShouldCallPauseCurrentGame() {
        // given
        let sut = HomeTabCoordinatorPauseCurrentGameMock(navigationController: RootNavigationController())
        
        // when
        sut.setupNewGame()
        
        // then
        XCTAssertEqual(sut.pauseCurrentGameCalledCount, 1)
    }
    
    
    // MARK: - QuickGame
    
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
    
    func test_HomeTabCoordinator_WhenSetupQuickGameCalled_ShouldCallPauseCurrentGame() {
        // given
        let sut = HomeTabCoordinatorPauseCurrentGameMock(navigationController: RootNavigationController())
        
        // when
        sut.setupNewGame()
        
        // then
        XCTAssertEqual(sut.pauseCurrentGameCalledCount, 1)
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
    
    
    // MARK: - ShowMyGames
    
    func test_HomeTabCoordinator_WhenShowMyGamesCalled_ShouldPushMyGamesViewControllerToNavigationController() {
        // given
        let navigationController = RootNavigationControllerPushMock()
        let sut = HomeTabCoordinator(navigationController: navigationController)
        
        // when
        sut.showMyGames()
        
        // then
        XCTAssertEqual(navigationController.pushViewControllerCount, 1)
        XCTAssertTrue(navigationController.pushedViewController is MyGamesViewController)
    }
    
    func test_HomeTabCoordinator_WhenShowMyGamesCalled_ShouldSetMyGamesViewModelWithCoordinatorAsSelf() {
        // given
        let navigationController = RootNavigationControllerPushMock()
        let sut = HomeTabCoordinator(navigationController: navigationController)
        
        // when
        sut.showMyGames()
        
        // then
        let myGamesVC = navigationController.pushedViewController as? MyGamesViewController
        XCTAssertNotNil(myGamesVC?.viewModel)
    }
    
    func test_HomeTabCoordinator_WhenShowMyGamesCalled_ShouldCallCoreDataHelperGetAllGames() {
        // given
        let sut = HomeTabCoordinator(navigationController: RootNavigationController())
        
        let coreDataHelper = HomeTabCoordinatorCoreDataHelperMock()
        sut.coreDataHelper = coreDataHelper
        
        // when
        sut.showMyGames()
        
        // then
        XCTAssertEqual(coreDataHelper.getAllGamesCalledCount, 1)
    }
    
    func test_HomeTabCoordinator_WhenShowMyGamesCalledHelperThrowsError_ShouldCallShowErrorWithError() {
        class HomeTabCoordinatorShowErrorMock: HomeTabCoordinator {
            var showErrorCalledCount = 0
            var showErrorError: CoreDataStoreError?
            override func showError(_ error: CoreDataStoreError) {
                showErrorCalledCount += 1
                showErrorError = error
            }
        }
        
        // given
        let sut = HomeTabCoordinatorShowErrorMock(navigationController: RootNavigationController())
        
        let coreDataHelper = HomeTabCoordinatorCoreDataHelperMock()
        sut.coreDataHelper = coreDataHelper
        
        let errorDescription = UUID().uuidString
        let error = CoreDataStoreError.dataError(description: errorDescription)
        coreDataHelper.errorToReturn = error
        
        // when
        sut.showMyGames()
        
        // then
        XCTAssertEqual(sut.showErrorCalledCount, 1)
        XCTAssertEqual(sut.showErrorError?.getDescription(), errorDescription)
    }
    
    func test_HomeTabCoordinator_WhenShowMyGamesCalledHelperReturnsGames_ShouldSetViewControllersViewModelsGamesToGames() {
        // given
        let navigationController = RootNavigationControllerPushMock()
        let sut = HomeTabCoordinator(navigationController: navigationController)
        
        let coreDataHelper = HomeTabCoordinatorCoreDataHelperMock()
        sut.coreDataHelper = coreDataHelper
        
        let gamesToReturn = [GameMock()]
        coreDataHelper.gamesToReturn = gamesToReturn
        
        // when
        sut.showMyGames()
        
        // then
        let myGamesVC = navigationController.pushedViewController as? MyGamesViewController
        XCTAssertEqual(myGamesVC?.viewModel.games[0].id, gamesToReturn[0].id)
    }
    
    
    // MARK: - ShowError
    
    func test_HomeTabCoordinator_WhenShowErrorCalled_ShouldPresentAlertControllerOnTopViewControllerAfterDelayOfPoint25() {
        // given
        let sut = HomeTabCoordinator(navigationController: RootNavigationController())
        let viewController = ViewControllerPresentMock()
        sut.navigationController.viewControllers = [viewController]
        
        let dispatchQueueMock = DispatchQueueMainMock()
        sut.dispatchQueue = dispatchQueueMock
        
        // when
        sut.showError(CoreDataStoreError.dataError(description: ""))
        
        // then
        
        XCTAssertEqual(dispatchQueueMock.asyncAfterDelay, 0.25)
        XCTAssertEqual(dispatchQueueMock.asyncAfterCalledCount, 1)
        XCTAssertEqual(viewController.presentCalledCount, 1)
    }
    
    func test_HomeTabCoordinator_WhenShowErrorCalled_ShouldPresentAlertControllerOnTopViewControllerWithAlertControllerTitleErrorMessageErrorDescription() {
        // given
        let sut = HomeTabCoordinator(navigationController: RootNavigationController())
        let viewController = ViewControllerPresentMock()
        sut.navigationController.viewControllers = [viewController]
        
        let dispatchQueueMock = DispatchQueueMainMock()
        sut.dispatchQueue = dispatchQueueMock
        
        let errorDescription = UUID().uuidString
        let error = CoreDataStoreError.dataError(description: errorDescription)
        
        // when
        sut.showError(error)
        
        // then
        let alertVC = viewController.presentViewController as? UIAlertController
        XCTAssertNotNil(alertVC)
        XCTAssertEqual(alertVC?.title, "Error")
        XCTAssertEqual(alertVC?.message, errorDescription)
    }
    
    func test_HomeTabCoordinator_WhenShowErrorCalled_ShouldAddOkActionToAlertControllerPresented() {
        // given
        let sut = HomeTabCoordinator(navigationController: RootNavigationController())
        let viewController = ViewControllerPresentMock()
        sut.navigationController.viewControllers = [viewController]
        
        let dispatchQueueMock = DispatchQueueMainMock()
        sut.dispatchQueue = dispatchQueueMock
        
        // when
        sut.showError(CoreDataStoreError.dataError(description: ""))
        
        // then
        let alertVC = viewController.presentViewController as? UIAlertController
        XCTAssertEqual(alertVC?.actions.first?.title, "OK")
    }
    
    
    // MARK: - PauseCurrentGame
    
    func test_HomeTabCoordinator_WhenPauseCurrentGameCalledActiveGameNil_ShouldNotCallCoreDataHelperPauseGame() {
        // given
        let sut = HomeTabCoordinator(navigationController: RootNavigationController())
        let coreDataHelper = HomeTabCoordinatorCoreDataHelperMock()
        sut.coreDataHelper = coreDataHelper
        
        sut.activeGame = nil
        
        // when
        sut.pauseCurrentGame()
        
        // then
        XCTAssertEqual(coreDataHelper.pauseGameCalledCount, 0)
    }
    
    func test_HomeTabCoordinator_WhenPauseCurrentGameCalledActiveGameNotNil_ShouldCallCoreDataHelperPauseGameWithGame() {
        // given
        let sut = HomeTabCoordinator(navigationController: RootNavigationController())
        let coreDataHelper = HomeTabCoordinatorCoreDataHelperMock()
        sut.coreDataHelper = coreDataHelper
        
        let game = GameMock()
        sut.activeGame = game
        
        // when
        sut.pauseCurrentGame()
        
        // then
        XCTAssertEqual(coreDataHelper.pauseGameCalledCount, 1)
        XCTAssertEqual(coreDataHelper.pauseGameGame?.id, game.id)
    }
    
    func test_HomeTabCoordinator_WhenPauseCurrentGameCalled_ShouldSetActiveGameToNil() {
        // given
        let sut = HomeTabCoordinator(navigationController: RootNavigationController())
        
        sut.activeGame = GameMock()
        
        // when
        sut.pauseCurrentGame()
        
        // then
        XCTAssertNil(sut.activeGame)
    }
    
    func test_HomeTabCoordinator_WhenPauseCurrentGameCalled_ShouldCallStartAfterSettingActiveGameNil() {
        
        class HomeTabCoordinatorStartMock: HomeTabCoordinator {
            var startCalledCount = 0
            var startActiveGame: GameProtocol?
            override func start() {
                startCalledCount += 1
                startActiveGame = activeGame
            }
        }
        
        // given
        let sut = HomeTabCoordinatorStartMock(navigationController: RootNavigationController())
        
        sut.activeGame = GameMock()
        
        // when
        sut.pauseCurrentGame()
        
        // then
        XCTAssertEqual(sut.startCalledCount, 1)
        XCTAssertNil(sut.activeGame)
    }
    
    class HomeTabCoordinatorPauseCurrentGameMock: HomeTabCoordinator {
        var pauseCurrentGameCalledCount = 0
        override func pauseCurrentGame() {
            pauseCurrentGameCalledCount += 1
        }
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
    
    var reopenPausedGameCalledCount = 0
    var reopenPausedGameGame: GameProtocol?
    override func reopenPausedGame(_ game: GameProtocol) {
        self.reopenPausedGameCalledCount += 1
        self.reopenPausedGameGame = game
    }
    
    var showMyGamesCalledCount = 0
    override func showMyGames() {
        showMyGamesCalledCount += 1
    }
    
    var showGameReportForCalledCount = 0
    var showGameReportForGame: GameProtocol?
    override func showGameReportFor(game: GameProtocol) {
        showGameReportForCalledCount += 1
        showGameReportForGame = game
    }
}
