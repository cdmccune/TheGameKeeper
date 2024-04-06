//
//  GameTabCoordinatorTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 3/20/24.
//

import XCTest
@testable import Whats_The_Score

final class GameTabCoordinatorTests: XCTestCase {
    
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
    
    
    func test_GameTabCoordinator_WhenInitialiazed_ShouldSetGameSetupCoordinatorsNavigationControllerAsOwnNavController() {
        // given
        // when
        let sut = GameTabCoordinator(navigationController: RootNavigationController())
        
        // then
        let gameSetupCoordinator = sut.childCoordinators.first as? GameSetupCoordinator
        XCTAssertTrue(gameSetupCoordinator?.navigationController === sut.navigationController)
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
    
    func test_GameTabCoordinator_WhenStartCalled_ShouldCallStartOnGameSetupCoordinator() {
        
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
    
    class GameTabCoordinatorGameSetupCompleteMock: GameTabCoordinator {
        var gameSetupCompleteGameType: GameType?
        var gameSetupCompletePlayers: [PlayerProtocol]?
        var gameSetupCompleteCalledCount = 0
        override func gameSetupComplete(withGameType gameType: GameType, gameEndType: GameEndType, gameEndQuantity: Int, andPlayers players: [PlayerProtocol]) {
            gameSetupCompleteGameType = gameType
            gameSetupCompletePlayers = players
            gameSetupCompleteCalledCount += 1
        }
    }
    
    func test_GameTabCoordinator_WhenStartQuickGameCalled_ShouldCallGameSetupCompleteWithBasicGameType() {
        // given
        let sut = GameTabCoordinatorGameSetupCompleteMock(navigationController: RootNavigationController())
        
        // when
        sut.startQuickGame()
        
        // then
        XCTAssertEqual(sut.gameSetupCompleteGameType, .basic)
        XCTAssertEqual(sut.gameSetupCompleteCalledCount, 1)
    }
    
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
    
//    func test_GameTabCoordinator_WhenStartQuickGameCalled_ShouldCallGameSetupWithTwoPlayersPlayer1And2WithCorrectPositions() {
//        // given
//        let sut = GameTabCoordinatorGameSetupCompleteMock(navigationController: RootNavigationController())
//        
//        // when
//        sut.startQuickGame()
//        
//        // then
//        XCTAssertEqual(sut.gameSetupCompletePlayers?.count, 2)
//        XCTAssertEqual(sut.gameSetupCompletePlayers?[0].position, 0)
//        XCTAssertEqual(sut.gameSetupCompletePlayers?[1].position, 1)
//        XCTAssertEqual(sut.gameSetupCompletePlayers?[0].name, "Player 1")
//        XCTAssertEqual(sut.gameSetupCompletePlayers?[1].name, "Player 2")
//    }
    
    
    // MARK: - GameSetupComplete
    
//    func test_GameTabCoordinator_WhenGameSetupCompleteCalled_ShouldSetGamePropertyOfScoreboardCoordinatorWithPropertiesFromGameSetupComplete() {
//        // given
//        let sut = GameTabCoordinator(navigationController: RootNavigationController())
//        
//        let gameType = GameType.allCases.randomElement()!
//        let gameEndType = GameEndType.allCases.randomElement()!
//        let players = [PlayerMock()]
//        
//        // when
//        sut.gameSetupComplete(withGameType: gameType,
//                              gameEndType: gameEndType,
//                              gameEndQuantity: 0,
//                              andPlayers: players)
//        
//        // then
//        let scoreboardCoordinator = sut.childCoordinators.last as? ScoreboardCoordinator
//        XCTAssertEqual(scoreboardCoordinator?.game?.gameType, gameType)
//        XCTAssertEqual(scoreboardCoordinator?.game?.gameEndType, gameEndType)
//        XCTAssertEqual(scoreboardCoordinator?.game?.players as? [PlayerMock], players)
//    }
//    
//    func test_GameTabCoordinator_WhenGameSetupCompleteCalledGameEndTypeRound_ShouldSetScoreboardCoordinatorGameNumberOfRoundsToGameEndQuantity() {
//        // given
//        let sut = GameTabCoordinator(navigationController: RootNavigationController())
//        
//        let gameEndQuantity = Int.random(in: 1...1000)
//        
//        // when
//        sut.gameSetupComplete(withGameType: .basic,
//                              gameEndType: .round,
//                              gameEndQuantity: gameEndQuantity,
//                              andPlayers: [])
//        
//        // then
//        let scoreboardCoordinator = sut.childCoordinators.last as? ScoreboardCoordinator
//        XCTAssertEqual(scoreboardCoordinator?.game?.numberOfRounds, gameEndQuantity)
//    }
//    
//    func test_GameTabCoordinator_WhenGameSetupCompleteCalledGameEndTypeScore_ShouldSetScoreboardCoordinatorGameEndingScoreToGameEndQuantity() {
//        // given
//        let sut = GameTabCoordinator(navigationController: RootNavigationController())
//        
//        let gameEndQuantity = Int.random(in: 1...1000)
//        
//        // when
//        sut.gameSetupComplete(withGameType: .basic,
//                              gameEndType: .score,
//                              gameEndQuantity: gameEndQuantity,
//                              andPlayers: [])
//        
//        // then
//        let scoreboardCoordinator = sut.childCoordinators.last as? ScoreboardCoordinator
//        XCTAssertEqual(scoreboardCoordinator?.game?.endingScore, gameEndQuantity)
//    }
//    
//    func test_GameTabCoordinator_WhenGameSetupCompleteCalled_ShouldCallStartOnScoreboardCoordinator() {
//        
//        let scoreboardCoordinatorMock = ScoreboardCoordinatorMock(navigationController: RootNavigationController())
//        
//        // given
//        let sut = GameTabCoordinator(navigationController: RootNavigationController())
//        sut.childCoordinators[1] = scoreboardCoordinatorMock
//        
//        // when
//        sut.gameSetupComplete(withGameType: .basic, gameEndType: .none, gameEndQuantity: 0, andPlayers: [])
//        
//        // then
//        XCTAssertEqual(scoreboardCoordinatorMock.startCalledCount, 1)
//    }
    
    
    // MARK: - ShowGameEndScreen
    
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
//        XCTAssertTrue(endGameVC?.viewModel.game.isEqualTo(game: game) ?? false)
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
    
    
    // MARK: - GoToScoreboard
    
    func test_GameTabCoordinator_WhenGoToScoreboardCalled_ShouldSetScoreboardCoordinatorGameToGame() {
        // given
        let sut = GameTabCoordinator(navigationController: RootNavigationController())
        let game = GameMock()
        
        // when
        sut.goToScoreboard(forGame: game)
        
        // then
        let scoreboardCoordinator = sut.childCoordinators.first { $0 is ScoreboardCoordinator } as? ScoreboardCoordinator
        
//        XCTAssertTrue(scoreboardCoordinator?.game?.isEqualTo(game: game) ?? false)
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

}
