//
//  Game.swift
//  What's The Score
//
//  Created by Curt McCune on 12/30/23.
//

import Foundation

protocol GameProtocol {
    var gameType: GameType { get set }
    var gameEndType: GameEndType { get set }
    var numberOfRounds: Int { get set }
    var currentRound: Int { get set }
    var endingScore: Int { get set }
    var players: [PlayerProtocol] { get set }
    var winningPlayers: [PlayerProtocol] { get }
    var historySegments: [GameHistorySegment] { get set }
    var id: UUID { get }
    
    mutating func playerNameChanged(withIndex index: Int, toName name: String)
    mutating func movePlayerAt(_ sourceRowIndex: Int, to destinationRowIndex: Int)
    mutating func addPlayer()
    mutating func randomizePlayers()
    mutating func deletePlayerAt(_ index: Int)
    mutating func editScore(scoreChange: ScoreChange)
    mutating func endRound(_ endRound: EndRound)
    mutating func resetGame()
    mutating func editScoreChange(_ newScoreChange: ScoreChange)
    mutating func editEndRound(_ newEndRound: EndRound)
    
    func isEqualTo(game: GameProtocol) -> Bool
    func isEndOfGame() -> Bool
}

struct Game: GameProtocol {
    
    // MARK: - Initialization
    
    init(basicGameWithPlayers players: [PlayerProtocol]) {
        self.gameType = .basic
        self.gameEndType = .none
        self.currentRound = 1
        self.players = players
        self.numberOfRounds = 2
        self.endingScore = 10
    }
    
    init(gameType: GameType,
         gameEndType: GameEndType,
         numberOfRounds: Int = 2,
         currentRound: Int = 1,
         endingScore: Int = 10,
         numberOfPlayers: Int) {
        self.gameType = gameType
        self.gameEndType = gameEndType
        self.numberOfRounds = numberOfRounds
        self.currentRound = currentRound
        self.endingScore = endingScore
        
        var players = [Player]()
        for i in 0..<numberOfPlayers {
            players.append(Player(name: "", position: i))
        }
        self.players = players
    }
    
    
    // MARK: - Properties
    
    var id: UUID = UUID()
    var gameType: GameType
    var gameEndType: GameEndType
    var numberOfRounds: Int
    var currentRound: Int
    var endingScore: Int
    
    var players: [PlayerProtocol]
    var historySegments: [GameHistorySegment] = []
    
    var winningPlayers: [PlayerProtocol] {
        let sortedPlayers = players.sorted { $0.score>$1.score }
        return players.filter { $0.score == (sortedPlayers.first?.score ?? 0) }
    }
    
    
    // MARK: - Mutating Functions
    
    mutating func playerNameChanged(withIndex index: Int, toName name: String) {
        guard players.indices.contains(index) else { return }
        players[index].name = name
    }
    
    mutating func movePlayerAt(_ sourceRowIndex: Int, to destinationRowIndex: Int) {
        guard players.indices.contains(sourceRowIndex),
              players.indices.contains(destinationRowIndex) else { return }
        
        let playerToMove = players[sourceRowIndex]
        players.remove(at: sourceRowIndex)
        players.insert(playerToMove, at: destinationRowIndex)
        players.setPositions()
    }
    
    mutating func addPlayer() {
        players.append(Player(name: "", position: players.indices.upperBound))
    }
    
    mutating func randomizePlayers() {
        players.shuffle()
        players.setPositions()
    }
    
    mutating func deletePlayerAt(_ index: Int) {
        guard players.indices.contains(index) else {
            return
        }
        
        players.remove(at: index)
        players.setPositions()
    }
    
    mutating func editScore(scoreChange: ScoreChange) {
        guard let index = players.firstIndex(where: { $0.id == scoreChange.playerID }) else { return }
        
        players[index].scoreChanges.append(scoreChange)
        let historySegment = GameHistorySegment.scoreChange(scoreChange)
        
        historySegments.append(historySegment)
    }
    
    mutating func endRound(_ endRound: EndRound) {
        
        endRound.scoreChangeArray.forEach { scoreChange in
            if let index = players.firstIndex(where: { $0.id == scoreChange.playerID }) {
                players[index].scoreChanges.append(scoreChange)
            }
        }
        
        let historySegment = GameHistorySegment.endRound(endRound)
        historySegments.append(historySegment)
        
        currentRound += 1
    }
    
    mutating func resetGame() {
        for i in 0..<players.count {
            players[i].scoreChanges = []
        }
        
        currentRound = 1
        
        historySegments = []
    }
    
    mutating func editScoreChange(_ newScoreChange: ScoreChange) {
        let gameHistorySegment = GameHistorySegment.scoreChange(newScoreChange)
        
        if let playerIndex = players.firstIndex(where: { $0.id == newScoreChange.playerID }),
        let scoreChangeIndex = historySegments.firstIndex(of: gameHistorySegment),
        case .scoreChange(let scoreChangeOriginal) = historySegments[scoreChangeIndex] {
            
            historySegments[scoreChangeIndex] = .scoreChange(newScoreChange)
            
            if let scoreChangeIndex = players[playerIndex].scoreChanges.firstIndex(of: newScoreChange) {
                players[playerIndex].scoreChanges[scoreChangeIndex] = (newScoreChange)
            }
        }
    }
    
    mutating func editEndRound(_ newEndRound: EndRound) {
        let gameHistorySegment = GameHistorySegment.endRound(newEndRound)
        
        // Find the end round history object
        if let endRoundIndex = historySegments.firstIndex(of: gameHistorySegment),
           case .endRound(let oldEndRound) = historySegments[endRoundIndex] {
            
            // Go through and adjust the appropriate players score
            newEndRound.scoreChangeArray.forEach { newScoreChange in
                if let indexOfOldScoreChange = oldEndRound.scoreChangeArray.firstIndex(of: newScoreChange),
                   let playerIndex = players.firstIndex(where: { $0.id == newScoreChange.playerID }) {
                    
                    if let scoreChangeIndex = players[playerIndex].scoreChanges.firstIndex(of: newScoreChange) {
                        players[playerIndex].scoreChanges[scoreChangeIndex] = (newScoreChange)
                    }
                }
            }
            
            // Set the history object to new changes
            historySegments[endRoundIndex] = gameHistorySegment
        }
    }
    
    // MARK: - Non-Mutating Functions
    
    func isEqualTo(game: GameProtocol) -> Bool {
        game.id == self.id
    }
    
    func isEndOfGame() -> Bool {
        switch gameEndType {
        case .none:
            return false
        case .round:
            return currentRound > numberOfRounds
        case .score:
            return players.contains { $0.score >= endingScore }
        }
    }
}

enum GameType: Int, CaseIterable {
    case basic = 0
    case round = 1
}

enum GameEndType: Int, CaseIterable {
    case none = 0
    case round = 1
    case score = 2
}
