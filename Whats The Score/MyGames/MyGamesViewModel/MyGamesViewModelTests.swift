//
//  MyGamesViewModelTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 4/11/24.
//

import XCTest
@testable import Whats_The_Score

final class MyGamesViewModelTests: XCTestCase {
    
    func test_MyGamesViewModel_WhenActiveGamesRetrieved_ShouldFilterGamesForActiveGames() {
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
    
}

class MyGamesViewModelMock: MyGamesViewModelProtocol {
    var games: [Whats_The_Score.GameProtocol] = []
    var activeGames: [Whats_The_Score.GameProtocol] = []
    var pausedGames: [Whats_The_Score.GameProtocol] = []
    var completedGames: [Whats_The_Score.GameProtocol] = []
}
