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
    
    func test_HomeTabCoordinator_WhenSetupNewGameCalled_ShouldCallPauseCurrentGame() {
        // given
        let sut = HomeTabCoordinatorPauseCurrentGameMock(navigationController: RootNavigationController())
        
        // when
        sut.setupNewGame()
        
        // then
        XCTAssertEqual(sut.pauseCurrentGameCalledCount, 1)
    }
    
    func test_HomeTabCoordinator_WhenSetupNewGameCalled_PauseGameCompletionCalled_ShouldCallCoordinatorSetupNewGame() {
        // given
        let sut = HomeTabCoordinatorPauseCurrentGameMock(navigationController: RootNavigationController())
        sut.completionShouldBeCalled = true
        let coordinator = MainCoordinatorMock()
        sut.coordinator = coordinator
        
        // when
        sut.setupNewGame()
        
        // then
        XCTAssertEqual(coordinator.setupNewGameCalledCount, 1)
    }
    
    func test_HomeTabCoordinator_WhenSetupNewGameCalled_PauseGameCompletionNotCalled_ShouldNotCallCoordinatorSetupNewGame() {
        // given
        let sut = HomeTabCoordinatorPauseCurrentGameMock(navigationController: RootNavigationController())
        sut.completionShouldBeCalled = false
        let coordinator = MainCoordinatorMock()
        sut.coordinator = coordinator
        
        // when
        sut.setupNewGame()
        
        // then
        XCTAssertEqual(coordinator.setupNewGameCalledCount, 0)
    }
    
    
    // MARK: - QuickGame
    
    func test_HomeTabCoordinator_WhenSetupQuickGameCalled_ShouldCallPauseCurrentGame() {
        // given
        let sut = HomeTabCoordinatorPauseCurrentGameMock(navigationController: RootNavigationController())
        
        // when
        sut.setupNewGame()
        
        // then
        XCTAssertEqual(sut.pauseCurrentGameCalledCount, 1)
    }
    
    func test_HomeTabCoordinator_WhenSetupQuickGameCalled_PauseCompletionCalled_ShouldCallCoordinatorsSetupQuickGame() {
        // given
        let sut = HomeTabCoordinatorPauseCurrentGameMock(navigationController: RootNavigationController())
        sut.completionShouldBeCalled = true
        let coordinator = MainCoordinatorMock()
        sut.coordinator = coordinator
        
        // when
        sut.setupQuickGame()
        
        // then
        XCTAssertEqual(coordinator.setupQuickGameCalledCount, 1)
    }

    func test_HomeTabCoordinator_WhenSetupQuickGameCalled_PauseCompletionNotCalled_ShouldNotCallCoordinatorsSetupQuickGame() {
        // given
        let sut = HomeTabCoordinatorPauseCurrentGameMock(navigationController: RootNavigationController())
        sut.completionShouldBeCalled = false
        let coordinator = MainCoordinatorMock()
        sut.coordinator = coordinator
        
        // when
        sut.setupQuickGame()
        
        // then
        XCTAssertEqual(coordinator.setupQuickGameCalledCount, 0)
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
        XCTAssertIdentical(myGamesVC?.viewModel.coordinator, sut)
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

    func test_HomeTabCoordinator_WhenPauseCurrentGameCalled_ThereIsCurrentActiveGame_ShouldDisplayAlertOnTopViewController() {
        // given
        let sut = HomeTabCoordinator(navigationController: RootNavigationController())
        let viewController = ViewControllerPresentMock()
        sut.navigationController.viewControllers = [viewController]

        let gameName = UUID().uuidString
        let game = GameMock(name: gameName)
        sut.activeGame = game
        
        let dispatchQueueMock = DispatchQueueMainMock()
        sut.dispatchQueue = dispatchQueueMock
        
        // when
        sut.pauseCurrentGame()
        
        // then
        let alertController = viewController.presentViewController as? UIAlertController
        XCTAssertEqual(viewController.presentCalledCount, 1)
        XCTAssertNotNil(alertController)
        XCTAssertEqual(alertController?.title, "Pause Game")
        XCTAssertEqual(alertController?.message, "Do you want to pause your current game: \(gameName)?")
    }

    func test_HomeTabCoordinator_WhenPauseCurrentGameCalled_ThereIsCurrentActiveGame_ShouldPresentAlertWithTwoActions() {
        // given
        let sut = HomeTabCoordinator(navigationController: RootNavigationController())
        let viewController = ViewControllerPresentMock()
        sut.navigationController.viewControllers = [viewController]

        let gameName = UUID().uuidString
        let game = GameMock(name: gameName)
        sut.activeGame = game

        let dispatchQueueMock = DispatchQueueMainMock()
        sut.dispatchQueue = dispatchQueueMock

        // when
        sut.pauseCurrentGame()

        // then
        let alertController = viewController.presentViewController as? UIAlertController
        XCTAssertEqual(alertController?.actions.count, 2)
    }

    func test_HomeTabCoordinator_WhenPauseCurrentGameCalled_ThereIsCurrentActiveGame_ShouldPresentAlertWithNoActionWithNilHandler() {
        // given
        let sut = HomeTabCoordinator(navigationController: RootNavigationController())
        let viewController = ViewControllerPresentMock()
        sut.navigationController.viewControllers = [viewController]

        let gameName = UUID().uuidString
        let game = GameMock(name: gameName)
        sut.activeGame = game

        let dispatchQueueMock = DispatchQueueMainMock()
        sut.dispatchQueue = dispatchQueueMock

        // when
        sut.pauseCurrentGame()

        // then
        let alertController = viewController.presentViewController as? UIAlertController
        let noAction = alertController?.actions.first as? TestableUIAlertAction
        XCTAssertNotNil(noAction)
        XCTAssertEqual(noAction?.title, "No")
        XCTAssertNil(noAction?.handler)
    }

    func test_HomeTabCoordinator_WhenPauseCurrentGameCalled_ThereIsCurrentActiveGame_ShouldPresentAlertWithYesAction() {
        // given
        let sut = HomeTabCoordinator(navigationController: RootNavigationController())
        let viewController = ViewControllerPresentMock()
        sut.navigationController.viewControllers = [viewController]

        let gameName = UUID().uuidString
        let game = GameMock(name: gameName)
        sut.activeGame = game

        let dispatchQueueMock = DispatchQueueMainMock()
        sut.dispatchQueue = dispatchQueueMock

        // when
        sut.pauseCurrentGame()

        // then
        let alertController = viewController.presentViewController as? UIAlertController
        let yesAction = alertController?.actions.last
        XCTAssertNotNil(yesAction)
        XCTAssertEqual(yesAction?.title, "Yes")
    }
    
    func test_HomeTabCoordinator_WhenPauseCurrentGameCalledActiveGame_YesActionSelected_ShouldCallCoreDataHelperPauseGameWithGame() {
        // given
        let sut = HomeTabCoordinator(navigationController: RootNavigationController())
        let viewController = ViewControllerPresentMock()
        sut.navigationController.viewControllers = [viewController]
        
        let coreDataHelper = HomeTabCoordinatorCoreDataHelperMock()
        sut.coreDataHelper = coreDataHelper
        
        let game = GameMock()
        sut.activeGame = game
        
        // when
        sut.pauseCurrentGame()
        let yesAction = (viewController.presentViewController as? UIAlertController)?.actions.last as? TestableUIAlertAction
        yesAction?.handler?(UIAlertAction())
        
        // then
        XCTAssertEqual(coreDataHelper.pauseGameCalledCount, 1)
        XCTAssertEqual(coreDataHelper.pauseGameGame?.id, game.id)
    }
    
    func test_HomeTabCoordinator_WhenPauseCurrentGameCalledActiveGame_YesActionSelected_ShouldCallCoreDataHelperMakeGameActiveWithActiveGame() {
        // given
        let sut = HomeTabCoordinator(navigationController: RootNavigationController())
        let viewController = ViewControllerPresentMock()
        sut.navigationController.viewControllers = [viewController]
        
        let coreDataHelper = HomeTabCoordinatorCoreDataHelperMock()
        sut.coreDataHelper = coreDataHelper
        
        let game = GameMock()
        sut.activeGame = game
        let gameToMakeActive = GameMock()
        
        // when
        sut.pauseCurrentGame(andOpenGame: gameToMakeActive)
        let yesAction = (viewController.presentViewController as? UIAlertController)?.actions.last as? TestableUIAlertAction
        yesAction?.handler?(UIAlertAction())
        
        // then
        XCTAssertEqual(coreDataHelper.makeGameActiveCalledCount, 1)
        XCTAssertIdentical(coreDataHelper.makeGameActiveGame, gameToMakeActive)
    }
    
    func test_HomeTabCoordinator_WhenPauseCurrentGameCalledActiveGame_YesActionSelected_ShouldSetActiveGameToNewGameBeforeCallingStart() {
        
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
        let viewController = ViewControllerPresentMock()
        sut.navigationController.viewControllers = [viewController]
        
        let game = GameMock()
        sut.activeGame = game
        let gameToMakeActive = GameMock()
        
        // when
        sut.pauseCurrentGame(andOpenGame: gameToMakeActive)
        let yesAction = (viewController.presentViewController as? UIAlertController)?.actions.last as? TestableUIAlertAction
        yesAction?.handler?(UIAlertAction())
        
        // then
        XCTAssertEqual(sut.startCalledCount, 1)
        XCTAssertIdentical(sut.startActiveGame, gameToMakeActive)
    }
    
    func test_HomeTabCoordinator_WhenPauseCurrentGameCalledActiveGame_YesActionSelected_ShouldCallCompletion() {
        // given
        let sut = HomeTabCoordinator(navigationController: RootNavigationController())
        let viewController = ViewControllerPresentMock()
        sut.navigationController.viewControllers = [viewController]
        
        let coreDataHelper = HomeTabCoordinatorCoreDataHelperMock()
        sut.coreDataHelper = coreDataHelper
        
        let game = GameMock()
        sut.activeGame = game
        let gameToMakeActive = GameMock()
        
        let expectation = XCTestExpectation(description: "completion should be called")
        
        // when
        sut.pauseCurrentGame(andOpenGame: gameToMakeActive) {
            expectation.fulfill()
        }
        let yesAction = (viewController.presentViewController as? UIAlertController)?.actions.last as? TestableUIAlertAction
        yesAction?.handler?(UIAlertAction())
        
        // then
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_HomeTabCoordinator_WhenPauseCurrentGameCalled_NoActiveGame_ShouldCallCoreDataHelperMakeCurrentGameActiveOnNewGame() {
        // given
        let sut = HomeTabCoordinatorMock(navigationController: RootNavigationController())
        let coreDataHelper = HomeTabCoordinatorCoreDataHelperMock()
        sut.coreDataHelper = coreDataHelper
        
        let game = GameMock()
        
        // when
        sut.pauseCurrentGame(andOpenGame: game)
        
        // then
        XCTAssertEqual(coreDataHelper.makeGameActiveCalledCount, 1)
        XCTAssertIdentical(coreDataHelper.makeGameActiveGame, game)
    }
    
    func test_HomeTabCoordinator_WhenPauseCurrentGameCalled_NoActiveGame_ShouldSetActiveGameToNewGameBeforeCallingStart() {
        
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
        
        let game = GameMock()
        
        // when
        sut.pauseCurrentGame(andOpenGame: game)
        
        // then
        XCTAssertEqual(sut.startCalledCount, 1)
        XCTAssertIdentical(sut.startActiveGame, game)
    }
    
    func test_HomeTabCoordinator_WhenPauseCurrentGameCalled_NoActiveGame_ShouldCallCompletion() {
        // given
        let sut = HomeTabCoordinator(navigationController: RootNavigationController())
        let expectation = XCTestExpectation(description: "completion should be called")
        
        // when
        sut.pauseCurrentGame {
            expectation.fulfill()
        }
        
        // then
        wait(for: [expectation], timeout: 0.1)
    }

    // MARK: - reopenNonActiveGame
    
    func test_HomeTabCoordinator_WhenReopenNonActiveGameCalled_ShouldCallPauseCurrentGameWithNewGameToOpen() {
        // given
        let sut = HomeTabCoordinatorPauseCurrentGameMock(navigationController: RootNavigationController())
        let newGame = GameMock()
        
        // when
        sut.reopenNonActiveGame(newGame)
        
        // then
        XCTAssertEqual(sut.pauseCurrentGameCalledCount, 1)
        XCTAssertIdentical(sut.pauseCurrentGameNewGame, newGame)
    }
    
    func test_HomeTabCoordinator_WhenReopenNonActiveGameCalledPauseCompletionCalled_ShouldCallCoordinatorHomeTabGameMadeActive() {
        // given
        let sut = HomeTabCoordinatorPauseCurrentGameMock(navigationController: RootNavigationController())
        sut.completionShouldBeCalled = true
        let coordinator = MainCoordinatorMock()
        sut.coordinator = coordinator
        
        let game = GameMock()
        
        // when
        sut.reopenNonActiveGame(game)
        
        // then
        XCTAssertEqual(coordinator.homeTabGameMadeActiveCalledCount, 1)
        XCTAssertIdentical(coordinator.homeTabGameMadeActiveGame, game)
    }
    
    func test_HomeTabCoordinator_WhenReopenNonActiveGameCalledPauseCompletionNotCalled_ShouldNotCallCoordinatorHomeTabGameMadeActiveWhenCompletionCalled() {
        // given
        let sut = HomeTabCoordinatorPauseCurrentGameMock(navigationController: RootNavigationController())
        sut.completionShouldBeCalled = false
        let coordinator = MainCoordinatorMock()
        sut.coordinator = coordinator
        
        let game = GameMock()
        
        // when
        sut.reopenNonActiveGame(game)
        
        // then
        XCTAssertEqual(coordinator.homeTabGameMadeActiveCalledCount, 0)
    }
    
    
    // MARK: - PlayGameAgain
    
    func test_HomeTabCoordinator_WhenPlayGameAgainCalled_ShouldCallPauseCurrentGame() {
        // given
        let sut = HomeTabCoordinatorPauseCurrentGameMock(navigationController: RootNavigationController())
        
        // when
        sut.playGameAgain(GameMock())
        
        // then
        XCTAssertEqual(sut.pauseCurrentGameCalledCount, 1)
    }
    
    func test_HomeTabCoordinator_WhenPlayGameAgainCalled_PauseCurrentGameCompletionCalled_ShouldCallCoordinatorPlayGameAgainWithGame() {
        // given
        let sut = HomeTabCoordinatorPauseCurrentGameMock(navigationController: RootNavigationController())
        sut.completionShouldBeCalled = true
        let coordinator = MainCoordinatorMock()
        sut.coordinator = coordinator

        let game = GameMock()
        
        // when
        sut.playGameAgain(game)
        
        // then
        XCTAssertEqual(coordinator.playGameAgainCalledCount, 1)
        XCTAssertIdentical(coordinator.playGameAgainGame, game)
    }
    
    func test_HomeTabCoordinator_WhenPlayGameAgainCalled_PauseCurrentGameCompletionNotCalled_ShouldCallCoordinatorPlayGameAgainWithGame() {
        // given
        let sut = HomeTabCoordinatorPauseCurrentGameMock(navigationController: RootNavigationController())
        sut.completionShouldBeCalled = false
        let coordinator = MainCoordinatorMock()
        sut.coordinator = coordinator

        let game = GameMock()
        
        // when
        sut.playGameAgain(game)
        
        // then
        XCTAssertEqual(coordinator.playGameAgainCalledCount, 0)
    }
    
    
    // MARK: - HomeTabCoordinator
    
    func test_HomeTabCoordinator_WhenShowGameReportFor_ShouldPushEndGameViewControllerOnNavigationController() {
        // given
        let navigationController = RootNavigationControllerPushMock()
        let sut = HomeTabCoordinator(navigationController: navigationController)
        
        // when
        sut.showGameReportFor(game: GameMock())
        
        // then
        XCTAssertEqual(navigationController.pushViewControllerCount, 1)
        XCTAssertTrue(navigationController.pushedViewController is EndGameViewController)
    }
    
    
    // MARK: - showGameReportFor
    
    func test_HomeTabCoordinator_WhenShowGameReportFor_ShouldSetEndGameVCsCoordinatorAsSelf() {
        // given
        let navigationController = RootNavigationControllerPushMock()
        let sut = HomeTabCoordinator(navigationController: navigationController)
        
        // when
        sut.showGameReportFor(game: GameMock())
        
        // then
        let endGameVC = navigationController.pushedViewController as? EndGameViewController
        XCTAssertIdentical(endGameVC?.coordinator, sut)
    }    
    
    func test_HomeTabCoordinator_WhenShowGameReportFor_ShouldSetEndGameVCsViewModelWithGame() {
        // given
        let navigationController = RootNavigationControllerPushMock()
        let sut = HomeTabCoordinator(navigationController: navigationController)
        let game = GameMock()
        
        // when
        sut.showGameReportFor(game: game)
        
        // then
        let endGameVC = navigationController.pushedViewController as? EndGameViewController
        XCTAssertNotNil(endGameVC?.viewModel)
        XCTAssertIdentical(endGameVC?.viewModel.game, game)
    }
    
    
    // MARK: - DeleteActiveGame
    
    func test_HomeTabCoordinator_WhenDeleteActiveGame_ShouldCallCoreDataDeleteGameWithActiveGame() {
        // given
        let sut = HomeTabCoordinator(navigationController: RootNavigationController())
        let coreDataHelper = HomeTabCoordinatorCoreDataHelperMock()
        sut.coreDataHelper = coreDataHelper
        let game = GameMock()
        sut.activeGame = game
        
        // when
        sut.deleteActiveGame()
        
        // then
        XCTAssertEqual(coreDataHelper.deleteGameCalledCount, 1)
        XCTAssertIdentical(coreDataHelper.deleteGameGame, game)
    }
    
    func test_HomeTabCoordinator_WhenDeleteActiveGameCalled_ShouldSetOwnActiveGameToNil() {
        // given
        let sut = HomeTabCoordinator(navigationController: RootNavigationController())
        sut.activeGame = GameMock()
        
        // when
        sut.deleteActiveGame()
        
        // then
        XCTAssertNil(sut.activeGame)
    }
    
    func test_HomeTabCoordinator_WhenDeleteActiveGameCalled_ShouldSetActiveGameOfRootViewControllerIfIsHomeViewControllerToNilAndThenCallViewDidLoad() {
        class HomeViewControllerViewDidLoadMock: HomeViewController {
            var viewDidLoadCalledCount = 0
            var viewDidLoadActiveGame: GameProtocol? = GameMock()
            override func viewDidLoad() {
                viewDidLoadCalledCount += 1
                viewDidLoadActiveGame = activeGame
            }
        }
        
        
        // given
        let sut = HomeTabCoordinator(navigationController: RootNavigationController())
        let homeVC = HomeViewControllerViewDidLoadMock()
        homeVC.activeGame = GameMock()
        sut.navigationController.viewControllers = [homeVC]
        
        // when
        sut.deleteActiveGame()
        
        // then
        XCTAssertNil(homeVC.viewDidLoadActiveGame)
        XCTAssertEqual(homeVC.viewDidLoadCalledCount, 1)
    }
    
    func test_HomeTabCoordinator_WhenDeleteActiveGameCalled_ShouldCallCoordinatorActiveGameDeleted() {
        // given
        let sut = HomeTabCoordinator(navigationController: RootNavigationController())
        let coordinator = MainCoordinatorMock()
        sut.coordinator = coordinator
        
        // when
        sut.deleteActiveGame()
        
        // then
        XCTAssertEqual(coordinator.homeTabActiveGameDeletedCalledCount, 1)
    }
    
    
    // MARK: - DeleteNonActiveGame
    
    func test_HomeTabCoordinator_WhenDeleteNonActiveGameCalled_ShouldCallCoreDataHelperDeleteGameWithGame() {
        // given
        let sut = HomeTabCoordinator(navigationController: RootNavigationController())
        let coreDataHelper = HomeTabCoordinatorCoreDataHelperMock()
        sut.coreDataHelper = coreDataHelper
        let game = GameMock()
        
        // when
        sut.deleteNonActiveGame(game)
        
        // then
        XCTAssertEqual(coreDataHelper.deleteGameCalledCount, 1)
        XCTAssertIdentical(coreDataHelper.deleteGameGame, game)
    }
    
    
    class HomeTabCoordinatorPauseCurrentGameMock: HomeTabCoordinator {
        var pauseCurrentGameCalledCount = 0
        var pauseCurrentGameNewGame: GameProtocol?
        var completionShouldBeCalled: Bool = false
        override func pauseCurrentGame(andOpenGame newGame: GameProtocol? = nil, completion: @escaping () -> Void) {
            pauseCurrentGameCalledCount += 1
            pauseCurrentGameNewGame = newGame
            if completionShouldBeCalled {
                completion()
            }
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
    
    var reopenNonActiveGameCalledCount = 0
    var reopenNonActiveGameGame: GameProtocol?
    override func reopenNonActiveGame(_ game: GameProtocol) {
        self.reopenNonActiveGameCalledCount += 1
        self.reopenNonActiveGameGame = game
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
    
    var deleteActiveGameCalledCount = 0
    override func deleteActiveGame() {
        deleteActiveGameCalledCount += 1
    }
    
    var deleteNonActiveGameCalledCount = 0
    var deleteNonActiveGameGame: GameProtocol?
    override func deleteNonActiveGame(_ game: GameProtocol) {
        deleteNonActiveGameCalledCount += 1
        deleteNonActiveGameGame = game
    }
}
