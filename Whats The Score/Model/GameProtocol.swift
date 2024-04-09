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
    
    func changeName(of player: PlayerProtocol, to name: String)
    func movePlayerAt(_ sourceRowIndex: Int, to destinationRowIndex: Int)
    func addPlayer(withName: String)
    func randomizePlayers()
    func deletePlayer(_ player: PlayerProtocol)
    func deleteEndRound(_ endRound: EndRoundProtocol)
    func deleteScoreChange( _ scoreChange: ScoreChangeProtocol)
    func changeScore(with scoreChangeSettings: ScoreChangeSettings)
    func endRound(with endRoundSettings: EndRoundSettings)
    func updateSettings(with gameEndType: GameEndType, endingScore: Int, andNumberOfRounds numberOfRounds: Int)
    func resetGame()
    func editScoreChange(_ newScoreChange: ScoreChangeSettings)
    func editEndRound(_ newEndRound: EndRoundSettings)
    func isEqualTo(game: GameProtocol) -> Bool
    
    func isEndOfGame() -> Bool
}
