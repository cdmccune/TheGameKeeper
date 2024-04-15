//
//  GameTabCoordinatorTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 3/20/24.
//

import XCTest
@testable import Whats_The_Score

final class GameTabCoordinatorTests: XCTestCase {
    
    // MARK: - Mock Classes
    
    class GameTabCoordinatorStartScoreboardMock: GameTabCoordinator {
        var startScoreboardCalledCount = 0
        var startScoreboardGame: GameProtocol?
        override func startScoreboard(with game: GameProtocol) {
            startScoreboardCalledCount += 1
            startScoreboardGame = game
        }
    }
    
    // MARK: - Initial Properties

    func test_GameTabCoordinator_WhenInitialiazed_ShouldSetGameSetupCoordinatorAsFirstChildCoordinator() {
        // given
        // when
        let sut = GameTabCoordinator(navigationController: RootNavigationController())
        
        // then
        XCTAssertTrue(sut.childCoordinators.first is GameSetupCoordinator)
    }
    
    func test_GameTabCoordinator_WhenInitialiazed_ShouldSetSelfAsGameSetupCoordinatorsCoordinator() {
        // given
        // when
        let sut = GameTabCoordinator(navigationController: RootNavigationController())
        
        // then
        let gameSetupCoordinator = sut.childCoordinators.first as? GameSetupCoordinator
        XCTAssertTrue(gameSetupCoordinator?.coordinator === sut)
    }
    
    func test_GameTabCoordinator_WhenInitialiazed_ShouldSetGameSetupCoordinatorsNavigationControllerAsOwnNavController() {
        // given
        // when
        let sut = GameTabCoordinator(navigationController: RootNavigationController())
        
        // then
        let gameSetupCoordinator = sut.childCoordinators.first as? GameSetupCoordinator
        XCTAssertTrue(gameSetupCoordinator?.navigationController === sut.navigationController)
    }
    
    func test_GameTabCoordinator_WhenInitialiazed_ShouldSetScoreboardCoordinatorAsSecondChildCoordinator() {
        // given
        // when
        let sut = GameTabCoordinator(navigationController: RootNavigationController())
        
        // then
        XCTAssertTrue(sut.childCoordinators[1] is ScoreboardCoordinator)
    }
    
    func test_GameTabCoordinator_WhenInitialiazed_ShouldSetSelfAsScoreboardCoordinatorsCoordinator() {
        // given
        // when
        let sut = GameTabCoordinator(navigationController: RootNavigationController())
        
        // then
        let scoreboardCoordinator = sut.childCoordinators[1] as? ScoreboardCoordinator
        XCTAssertTrue(scoreboardCoordinator?.coordinator === sut)
    }
    
    func test_GameTabCoordinator_WhenInitialized_ShouldSetScoreboardCoordinatorCoreDataStoreAsOwnCoreDataStore() {
        // given
        // when
        let coreDataStore = CoreDataStoreMock()
        let sut = GameTabCoordinatorStartScoreboardMock(navigationController: RootNavigationController(), coreDataStore: coreDataStore)
        
        // then
        let scoreboardCoordinator = sut.childCoordinators[1] as? ScoreboardCoordinator
        XCTAssertTrue(scoreboardCoordinator?.coreDataStore as? CoreDataStoreMock === coreDataStore)
    }
    
    func test_GameTabCoordinator_WhenInitialized_ShouldSetCoreDataHelperCoreDataStoreToOwnCoreDataStore() {
        // given
        let coreDataStore = CoreDataStoreMock()
        let sut = GameTabCoordinator(navigationController: RootNavigationController(), coreDataStore: coreDataStore)
        
        // when
        let gameTabCoreDataHelper = sut.coreDataHelper
        
        // then
        XCTAssertTrue(gameTabCoreDataHelper.coreDataStore === coreDataStore)
    }
    
    
    // MARK: - Start
    
    func test_GameTabCoordinator_WhenStartCalledWithActiveGame_ShouldSetGameAndCallStartOnScoreboardCoordinator() {
        // given
        let sut = GameTabCoordinator(navigationController: RootNavigationController())
        let activeGame = GameMock()
        sut.activeGame = activeGame
        
        let scoreboardCoordinator = ScoreboardCoordinatorMock(navigationController: RootNavigationController())
        sut.childCoordinators = [scoreboardCoordinator]
        
        // when
        sut.start()
        
        // then
        XCTAssertEqual(scoreboardCoordinator.startCalledCount, 1)
        XCTAssertEqual(scoreboardCoordinator.game?.id, activeGame.id)
    }
    
    func test_GameTabCoordinator_WhenStartCalledNoActiveGame_ShouldCallStartOnGameSetupCoordinator() {
        
        // given
        let sut = GameTabCoordinator(navigationController: RootNavigationController())
        let gameSetupCoordinator = GameSetupCoordinatorMock()
        sut.childCoordinators = [gameSetupCoordinator]
        
        // when
        sut.start()
        
        // then
        XCTAssertEqual(gameSetupCoordinator.startCalledCount, 1)
    }
    
    
    // MARK: - StartQuickGame
    
    func test_GameTabCoordinator_WhenStartQuickGameCalled_ShouldCallGameTabCoreDataModelHelperStartQuickGame() {
        // given
        let sut = GameTabCoordinator(navigationController: RootNavigationController())
        let coreDataHelper = GameTabCoreDataHelperMock()
        sut.coreDataHelper = coreDataHelper
        
        // when
        sut.startQuickGame()
        
        // then
        XCTAssertEqual(coreDataHelper.startQuickGameCalledCount, 1)
    }
    
    func test_GameTabCoordinator_WhenStartQuickGameCalled_ShouldSetGameAsActiveGame() {
        // given
        let sut = GameTabCoordinator(navigationController: RootNavigationController())
        
        let game = GameMock()
        let coreDataHelperMock = GameTabCoreDataHelperMock()
        coreDataHelperMock.gameToReturn = game
        sut.coreDataHelper = coreDataHelperMock
        
        // when
        sut.startQuickGame()
        
        // then
        XCTAssertIdentical(game, sut.activeGame)
    }
    
    func test_GameTabCoordinator_WhenStartQuickGameCalled_ShouldCallCoordinatorGameTabGameCreated() {
        // given
        let sut = GameTabCoordinator(navigationController: RootNavigationController())
        let mainCoordinator = MainCoordinatorMock()
        sut.coordinator = mainCoordinator
        
        let game = GameMock()
        let coreDataHelperMock = GameTabCoreDataHelperMock()
        coreDataHelperMock.gameToReturn = game
        sut.coreDataHelper = coreDataHelperMock
        
        // when
        sut.startQuickGame()
        
        // then
        XCTAssertEqual(mainCoordinator.gameTabGameMadeActiveCalledCount, 1)
        XCTAssertEqual(mainCoordinator.gameTabGameMadeActiveGame?.id, game.id)
    }
    
    func test_GameTabCoordinator_WhenStartQuickGameCalled_ShouldCallStartScoreboardWithGameReturnedFromGameTabCoreDataHelper() {
        
        // given
        let sut = GameTabCoordinatorStartScoreboardMock(navigationController: RootNavigationController())
        
        let game = GameMock()
        let coreDataHelperMock = GameTabCoreDataHelperMock()
        coreDataHelperMock.gameToReturn = game
        sut.coreDataHelper = coreDataHelperMock
        
        // when
        sut.startQuickGame()
        
        // then
        XCTAssertEqual(sut.startScoreboardCalledCount, 1)
        XCTAssertEqual(sut.startScoreboardGame?.id, game.id)
    }
    
    
    // MARK: - GameSetupComplete
    
    func test_GameTabCoordinator_WhenGameSetupCompleteCalled_ShouldCallGameTabCoreDataHelperWithSameSettings() {
        // given
        let sut = GameTabCoordinator(navigationController: RootNavigationController())
        
        let coreDataHelper = GameTabCoreDataHelperMock()
        sut.coreDataHelper = coreDataHelper
        
        let gameType = GameType.allCases.randomElement()!
        let gameEndType = GameEndType.allCases.randomElement()!
        let gameEndQuantity = Int.random(in: 3...10)
        let playerName = UUID().uuidString
        let playerSettings = [PlayerSettings(name: playerName)]
        let gameName = UUID().uuidString
        
        // when
        sut.gameSetupComplete(withGameType: gameType, gameEndType: gameEndType, gameEndQuantity: gameEndQuantity, players: playerSettings, andName: gameName)
        
        // then
        XCTAssertEqual(coreDataHelper.initializeGameGameType, gameType)
        XCTAssertEqual(coreDataHelper.initializeGameGameEndType, gameEndType)
        XCTAssertEqual(coreDataHelper.initializeGameGameEndQuantity, gameEndQuantity)
        XCTAssertEqual(coreDataHelper.initializeGamePlayerSettings, playerSettings)
        XCTAssertEqual(coreDataHelper.initializeGameName, gameName)
        XCTAssertEqual(coreDataHelper.initializeGameCalledCount, 1)
    }
    
    func test_GameTabCoordinator_WhenGameSetupCompleteCalled_ShouldSetGameAsActiveGame() {
        // given
        let sut = GameTabCoordinator(navigationController: RootNavigationController())
        
        let game = GameMock()
        let coreDataHelperMock = GameTabCoreDataHelperMock()
        coreDataHelperMock.gameToReturn = game
        sut.coreDataHelper = coreDataHelperMock
        
        // when
        sut.gameSetupComplete(withGameType: .basic, gameEndType: .none, gameEndQuantity: 0, players: [], andName: "")
        
        // then
        XCTAssertIdentical(game, sut.activeGame)
    }
    
    func test_GameTabCoordinator_WhenGameSetupCompleteCalled_ShouldCallCoordinatorGameTabGameCreated() {
        // given
        let sut = GameTabCoordinator(navigationController: RootNavigationController())
        let mainCoordinator = MainCoordinatorMock()
        sut.coordinator = mainCoordinator
        
        let game = GameMock()
        let coreDataHelperMock = GameTabCoreDataHelperMock()
        coreDataHelperMock.gameToReturn = game
        sut.coreDataHelper = coreDataHelperMock
        
        // when
        sut.gameSetupComplete(withGameType: .basic, gameEndType: .none, gameEndQuantity: 0, players: [], andName: "")
        
        // then
        XCTAssertEqual(mainCoordinator.gameTabGameMadeActiveCalledCount, 1)
        XCTAssertEqual(mainCoordinator.gameTabGameMadeActiveGame?.id, game.id)
    }
    
    func test_GameTabCoordinator_WhenGameSetupCompleteCalled_ShouldCallStartScoreboardWithGameFromCoreDataHelper() {
        // given
        let sut = GameTabCoordinatorStartScoreboardMock(navigationController: RootNavigationController())
        
        let game = GameMock()
        let coreDataHelperMock = GameTabCoreDataHelperMock()
        coreDataHelperMock.gameToReturn = game
        sut.coreDataHelper = coreDataHelperMock
        
        // when
        sut.gameSetupComplete(withGameType: .basic, gameEndType: .none, gameEndQuantity: 0, players: [], andName: "")
        
        // then
        XCTAssertEqual(sut.startScoreboardCalledCount, 1)
        XCTAssertEqual(sut.startScoreboardGame?.id, game.id)
    }

    
    // MARK: - StartScoreboard
    
    func test_GameTabCoordinator_WhenStartScoreboardCalled_ShouldCallStartOnScoreboardCoordinator() {
        
        let scoreboardCoordinatorMock = ScoreboardCoordinatorMock(navigationController: RootNavigationController())
        
        // given
        let sut = GameTabCoordinator(navigationController: RootNavigationController())
        sut.childCoordinators[1] = scoreboardCoordinatorMock
        
        // when
        sut.startScoreboard(with: GameMock())
        
        // then
        XCTAssertEqual(scoreboardCoordinatorMock.startCalledCount, 1)
    }
    
    func test_GameTabCoordinator_WhenStartScoreboardCalled_ShouldSetGameToScoreboardCoordinatorsGame() {
        // given
        let scoreboardCoordinatorMock = ScoreboardCoordinatorMock(navigationController: RootNavigationController())
        
        let sut = GameTabCoordinator(navigationController: RootNavigationController())
        sut.childCoordinators[1] = scoreboardCoordinatorMock
        
        let game = GameMock()
        
        // when
        sut.startScoreboard(with: game)
        
        // then
        XCTAssertEqual(scoreboardCoordinatorMock.game?.id, game.id)
    }
    
    // MARK: - ShowGameEndScreen
    
    func test_GameTabCoordinator_WhenShowGameEndScreenCalled_ShouldCallCoreDataHelperEndGameWithGame() {
        // given
        let sut = GameTabCoordinator(navigationController: RootNavigationController())
        let coreDataHelper = GameTabCoreDataHelperMock()
        sut.coreDataHelper = coreDataHelper
        
        let game = GameMock()
        
        // when
        sut.showEndGameScreen(forGame: game)
        
        // then
        XCTAssertEqual(coreDataHelper.endGameCalledCount, 1)
        XCTAssertEqual(coreDataHelper.endGameGame?.id, game.id)
    }
    
    func test_GameTabCoordinator_WhenShowGameEndScreenCalled_ShouldSetNavigationControllersOnlyViewControllerAsEndGameViewController() {
        // given
        let navigationController = RootNavigationController()
        let sut = GameTabCoordinator(navigationController: navigationController)
        
        // when
        sut.showEndGameScreen(forGame: GameMock())
        
        // then
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        XCTAssertTrue(navigationController.viewControllers.first is EndGameViewController)
    }
    
    func test_GameTabCoordinator_WhenShowGameEndScreenCalled_ShouldSetEndGameViewControllersViewModelWithGame() {
        // given
        let navigationController = RootNavigationController()
        let sut = GameTabCoordinator(navigationController: navigationController)
        
        let game = GameMock()
        
        // when
        sut.showEndGameScreen(forGame: game)
        
        // then
        let endGameVC = navigationController.viewControllers.first as? EndGameViewController
        XCTAssertNotNil(endGameVC?.viewModel)
        XCTAssertTrue(endGameVC?.viewModel.game.isEqualTo(game: game) ?? false)
    }
    
    func test_GameTabCoordinator_WhenShowGameEndScreenCalled_ShouldSetEndGameViewControllerCoordinatorAsSelf() {
        // given
        let navigationController = RootNavigationController()
        let sut = GameTabCoordinator(navigationController: navigationController)
        
        let game = GameMock()
        
        // when
        sut.showEndGameScreen(forGame: game)
        
        // then
        let endGameVC = navigationController.viewControllers.first as? EndGameViewController
        XCTAssertTrue(endGameVC?.coordinator === sut)
    }
    
    func test_GameTabCoordinator_WhenShowGameEndScreenCalled_ShouldCallMainCoordinatorGameTabActiveGameCompleted() {
        // given
        let sut = GameTabCoordinator(navigationController: RootNavigationController())
        let coordinator = MainCoordinatorMock()
        sut.coordinator = coordinator
        
        // when
        sut.showEndGameScreen(forGame: GameMock())
        
        // then
        XCTAssertEqual(coordinator.gameTabActiveGameCompletedCalledCount, 1)
    }
    
    
    // MARK: - GoToScoreboard
    
    func test_GameTabCoordinator_WhenGoToScoreboardCalled_ShouldCallMainCoordinatorGameTabGameMadeActiveWithGame() {
        // given
        let sut = GameTabCoordinator(navigationController: RootNavigationController())
        let mainCoordinator = MainCoordinatorMock()
        sut.coordinator = mainCoordinator
        
        let game = GameMock()
        
        // when
        sut.goToScoreboard(forGame: game)
        
        // then
        XCTAssertEqual(mainCoordinator.gameTabGameMadeActiveCalledCount, 1)
        XCTAssertIdentical(mainCoordinator.gameTabGameMadeActiveGame, game)
    }
    
    func test_GameTabCoordinator_WhenGoToScoreboardCalled_ShouldCallCoreDataHelperMakeGameActiveWithGame() {
        // given
        let sut = GameTabCoordinator(navigationController: RootNavigationController())
        let coreDataHelper = GameTabCoreDataHelperMock()
        sut.coreDataHelper = coreDataHelper
        
        let game = GameMock()
        
        // when
        sut.goToScoreboard(forGame: game)
        
        // then
        XCTAssertEqual(coreDataHelper.makeGameActiveCalledCount, 1)
        XCTAssertIdentical(coreDataHelper.makeGameActiveGame, game)
    }
    
    func test_GameTabCoordinator_WhenGoToScoreboardCalled_ShouldSetScoreboardCoordinatorGameToGame() {
        // given
        let sut = GameTabCoordinator(navigationController: RootNavigationController())
        let game = GameMock()
        
        // when
        sut.goToScoreboard(forGame: game)
        
        // then
        let scoreboardCoordinator = sut.childCoordinators.first { $0 is ScoreboardCoordinator } as? ScoreboardCoordinator
        
        XCTAssertTrue(scoreboardCoordinator?.game?.isEqualTo(game: game) ?? false)
    }
    
    func test_GameTabCoordinator_WhenGoToScoreboardCalled_ShouldCallScoreboardCoordinatorStart() {
        // given
        let sut = GameTabCoordinator(navigationController: RootNavigationController())
        
        let scoreboardCoordinatorMock = ScoreboardCoordinatorMock(navigationController: RootNavigationController())
        sut.childCoordinators = [scoreboardCoordinatorMock]
        
        // when
        sut.goToScoreboard(forGame: GameMock())
        
        // then
        let scoreboardCoordinator = sut.childCoordinators.first { $0 is ScoreboardCoordinator } as? ScoreboardCoordinatorMock
        XCTAssertEqual(scoreboardCoordinator?.startCalledCount, 1)
    }
    
    
    // MARK: - DeleteGame
    
    func test_GameTabCoordinator_WhenDeleteGameCalled_ShouldCallCoreDataHelperDeleteGameWithCurrentActiveGame() {
        // given
        let sut = GameTabCoordinator(navigationController: RootNavigationController())
        let coreDataHelper = GameTabCoreDataHelperMock()
        sut.coreDataHelper = coreDataHelper
        
        let game = GameMock()
        sut.activeGame = game
        
        // when
        sut.deleteGame()
        
        // then
        XCTAssertEqual(coreDataHelper.deleteGameCalledCount, 1)
    }
    
    func test_GameTabCoordinator_WhenDeleteGameCalled_ShouldCallMainCoordinatorGameTabActiveGameCompleted() {
        // given
        let sut = GameTabCoordinator(navigationController: RootNavigationController())
        let mainCoordinator = MainCoordinatorMock()
        sut.coordinator = mainCoordinator
        sut.activeGame = GameMock()
        
        // when
        sut.deleteGame()
        
        // then
        XCTAssertEqual(mainCoordinator.gameTabActiveGameCompletedCalledCount, 1)
    }
    
    func test_GameTabCoordinator_WhenDeleteGameCalled_ShouldSetActiveGameToNilBeforeCallingStartOnSelf() {
        class GameTabCoordinatorStartMock: GameTabCoordinator {
            var startCalledCount = 0
            var startGame: GameProtocol?
            override func start() {
                startCalledCount += 1
                startGame = activeGame
            }
        }
        
        // given
        let sut = GameTabCoordinatorStartMock(navigationController: RootNavigationController())
        
        let game = GameMock()
        sut.activeGame = game
        
        // when
        sut.deleteGame()
        
        // then
        XCTAssertNil(sut.startGame)
        XCTAssertEqual(sut.startCalledCount, 1)
    }
}
