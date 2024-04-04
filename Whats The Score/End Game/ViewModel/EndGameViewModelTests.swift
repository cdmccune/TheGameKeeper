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
    
//    func test_EndGameViewModel_WhenLosingPlayersRead_ShouldReturnAllPlayersInGameExpectTheWinningPlayers() {
//        // given
//        let players: [Player] = [
////            Player(name: "", position: 0),
////            Player(name: "", position: 0),
////            Player(name: "", position: 0),
////            Player(name: "", position: 0),
////            Player(name: "", position: 0)
//        ]
//        
//        let winningPlayers = [
//            players[2],
//            players[4]
//        ]
//        
//        let game = GameMock(players: players)
//        game.winningPlayers = winningPlayers
//        let sut = EndGameViewModel(game: game)
//        
//        // when
//        let losingPlayers = sut.losingPlayers
//        
//        // then
//        var expectedLosingPlayers = players
//        winningPlayers.forEach {
//            if let index = expectedLosingPlayers.firstIndex(of: $0) {
//                expectedLosingPlayers.remove(at: index)
//            }
//        }
//        
//        XCTAssertEqual(Set(expectedLosingPlayers), Set(sut.losingPlayers as! [Player]))
//    }
    
//    func test_EndGameViewModel_WhenLosingPlayersRead_ShouldReturnPlayersInDescendingScoreOrder() {
//        // given
////        let players = [
////            Player(name: "", position: 0, score: 1),
////            Player(name: "", position: 0, score: 3),
////            Player(name: "", position: 0, score: 2),
////            Player(name: "", position: 0, score: 5),
////            Player(name: "", position: 0, score: 4)
////        ]
//        
//        let players: [Player] = [
////            Player(name: "", position: 0),
////            Player(name: "", position: 0),
////            Player(name: "", position: 0),
////            Player(name: "", position: 0),
////            Player(name: "", position: 0)
//        ]
//        
//        let game = GameMock(players: players)
//        
//        let sut = EndGameViewModel(game: game)
//        
//        // when
//        let losingPlayers = sut.losingPlayers
//        
//        // then
//        let sortedLosingPlayers = players.sorted { $0.score > $1.score }
//        
//        XCTAssertEqual(losingPlayers as? [Player], sortedLosingPlayers as? [Player])
//    }

}

class EndGameViewModelMock: EndGameViewModelProtocol {
    var game: GameProtocol = GameMock()
    var losingPlayers: [PlayerProtocol] = []
}
