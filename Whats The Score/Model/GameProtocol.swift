//
//  GameProtocol.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/5/24.
//

import Foundation

protocol GameProtocol {
    var scoreChanges: [ScoreChangeProtocol] { get }
    var endRounds: [EndRoundProtocol] { get }
    var players: [PlayerProtocol] { get }
    var winningPlayers: [PlayerProtocol] { get }
    
    var gameType: GameType { get set }
    var gameEndType: GameEndType { get set }
    var numberOfRounds: Int { get set }
    var currentRound: Int { get set }
    var endingScore: Int { get set }
    var id: UUID { get }
    
    func playerNameChanged(withIndex index: Int, toName name: String)
    func movePlayerAt(_ sourceRowIndex: Int, to destinationRowIndex: Int)
    func addPlayer()
    func randomizePlayers()
    func deletePlayerAt(_ index: Int)
    func editScore(scoreChange: ScoreChangeProtocol)
    func endRound(_ endRound: EndRoundProtocol)
    func updateSettings(with gameEndType: GameEndType, endingScore: Int, andNumberOfRounds numberOfRounds: Int)
    func resetGame()
    func editScoreChange(_ newScoreChange: ScoreChangeProtocol)
    func editEndRound(_ newEndRound: EndRoundProtocol)
    func deleteHistorySegmentAt(index: Int)
    func isEqualTo(game: GameProtocol) -> Bool
    
    func isEndOfGame() -> Bool
}
