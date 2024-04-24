//
//  MyGamesViewModelTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 4/11/24.
//

import XCTest
@testable import Whats_The_Score

final class MyGamesViewModelTests: XCTestCase {
    
    
    // MARK: - Properties
    
    func test_MyGamesViewModel_WhenActiveGamesRetrieved_ShouldFilterGamesForActiveGamesSortedByLastModified() {
        // Given
        let games = [
            GameMock(gameStatus: .active),
            GameMock(gameStatus: .paused),
            GameMock(gameStatus: .completed),
            GameMock(gameStatus: .active)
        ]
        let viewModel = MyGamesViewModel()
        viewModel.games = games
        
        // When
        let activeGames = viewModel.activeGames
        
        // Then
        XCTAssertEqual(activeGames.count, 2)
        XCTAssertTrue(activeGames.contains { $0.id == games[0].id })
        XCTAssertTrue(activeGames.contains { $0.id == games[3].id })
    }
    
    func test_MyGamesViewModel_WhenActiveGamesRetrieved_ShouldBeSortedByLastModified() {
        // given
        let games = [
            GameMock(gameStatus: .active, lastModified: Date(timeIntervalSince1970: 0)),
            GameMock(gameStatus: .active, lastModified: Date(timeIntervalSince1970: 1))
        ]
        let sut = MyGamesViewModel()
        sut.games = games
        
        // when
        let activeGames = sut.activeGames
        
        // then
        XCTAssertTrue(activeGames.first!.lastModified > activeGames.last!.lastModified)
    }
    
    func test_MyGamesViewModel_WhenPausedGamesRetrieved_ShouldFilterGamesForPausedGames() {
        // Given
        let games = [
            GameMock(gameStatus: .active),
            GameMock(gameStatus: .paused),
            GameMock(gameStatus: .completed),
            GameMock(gameStatus: .active)
        ]
        let viewModel = MyGamesViewModel()
        viewModel.games = games
        
        // When
        let activeGames = viewModel.pausedGames
        
        // Then
        XCTAssertEqual(activeGames.count, 1)
        XCTAssertTrue(activeGames.contains { $0.id == games[1].id })
    }
    
    func test_MyGamesViewModel_WhenPausedGamesRetrieved_ShouldBeSortedByLastModified() {
        // given
        let games = [
            GameMock(gameStatus: .paused, lastModified: Date(timeIntervalSince1970: 0)),
            GameMock(gameStatus: .paused, lastModified: Date(timeIntervalSince1970: 1))
        ]
        let sut = MyGamesViewModel()
        sut.games = games
        
        // when
        let pausedGames = sut.pausedGames
        
        // then
        XCTAssertTrue(pausedGames.first!.lastModified > pausedGames.last!.lastModified)
    }
    
    func test_MyGamesViewModel_WhenCompletedGamesRetrieved_ShouldFilterGamesForCompletedGames() {
        // Given
        let games = [
            GameMock(gameStatus: .active),
            GameMock(gameStatus: .paused),
            GameMock(gameStatus: .completed),
            GameMock(gameStatus: .active)
        ]
        let viewModel = MyGamesViewModel()
        viewModel.games = games
        
        // When
        let activeGames = viewModel.completedGames
        
        // Then
        XCTAssertEqual(activeGames.count, 1)
        XCTAssertTrue(activeGames.contains { $0.id == games[2].id })
    }
    
    func test_MyGamesViewModel_WhenCompletedGamesRetrieved_ShouldBeSortedByLastModified() {
        // given
        let games = [
            GameMock(gameStatus: .completed, lastModified: Date(timeIntervalSince1970: 0)),
            GameMock(gameStatus: .completed, lastModified: Date(timeIntervalSince1970: 1))
        ]
        let sut = MyGamesViewModel()
        sut.games = games
        
        // when
        let completedGames = sut.completedGames
        
        // then
        XCTAssertTrue(completedGames.first!.lastModified > completedGames.last!.lastModified)
    }
    
    // MARK: - DidSelectRowAt
    
    func test_MyGamesViewModel_WhenDidSelectRowAtCalledSection0_ShouldCallCoordinatorPlayActiveGame() {
        // given
        let sut = MyGamesViewModel()
        let coordinator = HomeTabCoordinatorMock(navigationController: RootNavigationController())
        sut.coordinator = coordinator
        
        // when
        sut.didSelectRowAt(IndexPath(row: 0, section: 0))
        
        // then
        XCTAssertEqual(coordinator.playActiveGameCalledCount, 1)
    }
    
    func test_MyGamesViewModel_WhenDidSelectRowAtCalledSection1GameInRange_ShouldCallCoordinatorReopenPausedGame() {
        // given
        let sut = MyGamesViewModel()
        let game = GameMock(gameStatus: .paused)
        sut.games = [game]
        let coordinator = HomeTabCoordinatorMock(navigationController: RootNavigationController())
        sut.coordinator = coordinator
        
        // when
        sut.didSelectRowAt(IndexPath(row: 0, section: 1))
        
        // then
        XCTAssertEqual(coordinator.reopenPausedGameCalledCount, 1)
        XCTAssertIdentical(coordinator.reopenPausedGameGame, game)
    }
    
    func test_MyGamesViewModel_WhenDidSelectRowAtCalledSection2GameInRange_ShouldCallCoordinatorShowGameReportForWithGame() {
        // given
        let sut = MyGamesViewModel()
        let game = GameMock(gameStatus: .completed)
        sut.games = [game]
        let coordinator = HomeTabCoordinatorMock(navigationController: RootNavigationController())
        sut.coordinator = coordinator
        
        // when
        sut.didSelectRowAt(IndexPath(row: 0, section: 2))
        
        // then
        XCTAssertEqual(coordinator.showGameReportForCalledCount, 1)
        XCTAssertIdentical(coordinator.showGameReportForGame, game)
    }
    
}

class MyGamesViewModelMock: MyGamesViewModelProtocol {
    var coordinator: HomeTabCoordinator?
    var games: [Whats_The_Score.GameProtocol] = []
    var activeGames: [Whats_The_Score.GameProtocol] = []
    var pausedGames: [Whats_The_Score.GameProtocol] = []
    var completedGames: [Whats_The_Score.GameProtocol] = []
    
    var didSelectRowAtIndexPath: IndexPath?
    var didSelectRowAtCalledCount = 0
    func didSelectRowAt(_ indexPath: IndexPath) {
        didSelectRowAtIndexPath = indexPath
        didSelectRowAtCalledCount += 1
    }
}
