//
//  EndGameViewModelTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 3/8/24.
//

import XCTest
@testable import Whats_The_Score

final class EndGameViewModelTests: XCTestCase {

    // MARK: - Properties
    
    func test_EndGameViewModel_WhenLosingPlayersRead_ShouldReturnAllPlayersInGameExpectTheWinningPlayers() {
        // given
        let players: [PlayerMock] = [
            PlayerMock(),
            PlayerMock(),
            PlayerMock(),
            PlayerMock(),
            PlayerMock(),
            PlayerMock()
        ]
        
        let winningPlayers = [
            players[2],
            players[4]
        ]
        
        let game = GameMock(players: players)
        game.winningPlayers = winningPlayers
        let sut = EndGameViewModel(game: game)
        
        // when
        let losingPlayers = sut.losingPlayers
        
        // then
        var expectedLosingPlayers = players
        winningPlayers.forEach { winningPlayer in
            if let index = expectedLosingPlayers.firstIndex(where: { $0.id == winningPlayer.id }) {
                expectedLosingPlayers.remove(at: index)
            }
        }
        
        XCTAssertEqual(expectedLosingPlayers.count, sut.losingPlayers.count)
        expectedLosingPlayers.forEach { (player) in
            XCTAssertTrue(sut.losingPlayers.contains { $0.id == player.id })
        }
    }
    
    func test_EndGameViewModel_WhenLosingPlayersRead_ShouldReturnPlayersInDescendingScoreOrder() {
        // given
        let players = [
            PlayerMock(score: 1),
            PlayerMock(score: 3),
            PlayerMock(score: 2),
            PlayerMock(score: 5),
            PlayerMock(score: 4)
        ]
        
        let game = GameMock(players: players)
        
        let sut = EndGameViewModel(game: game)
        
        // when
        let losingPlayers = sut.losingPlayers
        
        // then
        let sortedLosingPlayers = players.sorted { $0.score > $1.score }
        
        XCTAssertEqual(losingPlayers as? [PlayerMock], sortedLosingPlayers)
    }

}

class EndGameViewModelMock: EndGameViewModelProtocol {
    var game: GameProtocol = GameMock()
    var losingPlayers: [PlayerProtocol] = []
}
