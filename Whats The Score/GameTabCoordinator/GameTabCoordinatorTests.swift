//
//  GameTabCoordinatorTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 3/20/24.
//

import XCTest
@testable import Whats_The_Score

final class GameTabCoordinatorTests: XCTestCase {
    
    // MARK: - Init

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
    
    
    func test_GameTabCoordinator_WhenInitialiazed_ShouldSetGameSetupCoordinatorsNavigationControllerAsOwnNavController() {
        // given
        // when
        let sut = GameTabCoordinator(navigationController: RootNavigationController())
        
        // then
        let gameSetupCoordinator = sut.childCoordinators.first as? GameSetupCoordinator
        XCTAssertTrue(gameSetupCoordinator?.navigationController === sut.navigationController)
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
    
    
    // MARK: - GameSetupComplete
    
    func test_GameTabCoordinator_WhenGameSetupCompleteCalled_ShouldSetGamePropertyOfScoreboardCoordinatorWithPropertiesFromGameSetupComplete() {
        // given
        let sut = GameTabCoordinator(navigationController: RootNavigationController())
        
        let gameType = GameType.allCases.randomElement()!
        let gameEndType = GameEndType.allCases.randomElement()!
        let players = [PlayerMock()]
        
        // when
        sut.gameSetupComplete(withGameType: gameType,
                              gameEndType: gameEndType,
                              gameEndQuantity: 0,
                              andPlayers: players)
        
        // then
        let scoreboardCoordinator = sut.childCoordinators.last as? ScoreboardCoordinator
        XCTAssertEqual(scoreboardCoordinator?.game?.gameType, gameType)
        XCTAssertEqual(scoreboardCoordinator?.game?.gameEndType, gameEndType)
        XCTAssertEqual(scoreboardCoordinator?.game?.players as? [PlayerMock], players)
    }
    
    func test_GameTabCoordinator_WhenGameSetupCompleteCalledGameEndTypeRound_ShouldSetScoreboardCoordinatorGameNumberOfRoundsToGameEndQuantity() {
        // given
        let sut = GameTabCoordinator(navigationController: RootNavigationController())
        
        let gameEndQuantity = Int.random(in: 1...1000)
        
        // when
        sut.gameSetupComplete(withGameType: .basic,
                              gameEndType: .round,
                              gameEndQuantity: gameEndQuantity,
                              andPlayers: [])
        
        // then
        let scoreboardCoordinator = sut.childCoordinators.last as? ScoreboardCoordinator
        XCTAssertEqual(scoreboardCoordinator?.game?.numberOfRounds, gameEndQuantity)
    }
    
    func test_GameTabCoordinator_WhenGameSetupCompleteCalledGameEndTypeScore_ShouldSetScoreboardCoordinatorGameEndingScoreToGameEndQuantity() {
        // given
        let sut = GameTabCoordinator(navigationController: RootNavigationController())
        
        let gameEndQuantity = Int.random(in: 1...1000)
        
        // when
        sut.gameSetupComplete(withGameType: .basic,
                              gameEndType: .score,
                              gameEndQuantity: gameEndQuantity,
                              andPlayers: [])
        
        // then
        let scoreboardCoordinator = sut.childCoordinators.last as? ScoreboardCoordinator
        XCTAssertEqual(scoreboardCoordinator?.game?.endingScore, gameEndQuantity)
    }
    
    func test_GameTabCoordinator_WhenGameSetupCompleteCalled_ShouldCallStartOnScoreboardCoordinator() {
        
        let scoreboardCoordinatorMock = ScoreboardCoordinatorMock(navigationController: RootNavigationController())
        
        // given
        let sut = GameTabCoordinator(navigationController: RootNavigationController())
        sut.childCoordinators[1] = scoreboardCoordinatorMock
        
        // when
        sut.gameSetupComplete(withGameType: .basic, gameEndType: .none, gameEndQuantity: 0, andPlayers: [])
        
        // then
        XCTAssertEqual(scoreboardCoordinatorMock.startCalledCount, 1)
    }

}
