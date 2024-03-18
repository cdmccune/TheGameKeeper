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
        
        let player = players[index]
        
        players.remove(at: index)
        players.setPositions()
        
        // Cycle backwards throughg history so deleting one wont affect other indices
        historySegments.enumerated().reversed().forEach { (segmentIndex, segment) in
            
            // Check if history segment is score change
            if case .scoreChange(let scoreChange, let segmentPlayer) = segment {
                
                // Remove segment from history if it's players
                if player.id == segmentPlayer.id {
                    historySegments.remove(at: segmentIndex)
                }
            }
        }
    }
    
    mutating func editScore(scoreChange: ScoreChange) {
        guard let index = players.firstIndex(where: { $0.id == scoreChange.playerID }) else { return }
        
        players[index].scoreChanges.append(scoreChange)
        let historySegment = GameHistorySegment.scoreChange(scoreChange, players[index])
        
        historySegments.append(historySegment)
    }
    
    mutating func endRound(_ endRound: EndRound) {
        
        var playersInThisRound: [PlayerProtocol] = []
        
        endRound.scoreChangeArray.forEach { scoreChange in
            if let index = players.firstIndex(where: { $0.id == scoreChange.playerID }) {
                players[index].scoreChanges.append(scoreChange)
                playersInThisRound.append(players[index])
            } else {
                fatalError("Player not found")
            }
        }
        
        let historySegment = GameHistorySegment.endRound(endRound, playersInThisRound)
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
        
        if let playerIndex = players.firstIndex(where: { $0.id == newScoreChange.playerID }),
           let scoreChangeIndex = historySegments.getIndexOfElement(withID: newScoreChange.id),
           case .scoreChange(let scoreChangeOriginal, let player) = historySegments[scoreChangeIndex] {
            
            guard let scoreChangeIndex = players[playerIndex].scoreChanges.firstIndex(of: newScoreChange) else {
                fatalError("Score change not found")
            }
            
            players[playerIndex].scoreChanges[scoreChangeIndex] = (newScoreChange)
            historySegments[scoreChangeIndex] = .scoreChange(newScoreChange, players[playerIndex])
        }
    }
    
    mutating func editEndRound(_ newEndRound: EndRound) {
        
        var playerInEndRoundArray = [PlayerProtocol]()
        
        // Loop through new score changes
        newEndRound.scoreChangeArray.forEach { newScoreChange in
            // find player index for player in new scoreChange
            guard let playerIndex = players.firstIndex(where: { $0.id == newScoreChange.playerID }) else {
                fatalError("Player not in player array")
            }
            
            var player = players[playerIndex]
            
            // Append player to players in this endRound array
            playerInEndRoundArray.append(player)
            
            // Find the index of score change in player
            guard let playerScoreChangeIndex = player.scoreChanges.firstIndex(of: newScoreChange) else {
                fatalError("Score change not in player score change array")
            }
            
            // Set player ScoreChange to new value
            player.scoreChanges[playerScoreChangeIndex] = newScoreChange
        }
        
        // Find the end round history object
        guard let endRoundIndex = historySegments.getIndexOfElement(withID: newEndRound.id) else {
            fatalError("EndRound object not found")
        }
        
        // Set the history object to new changes
        let newGameHistorySegment = GameHistorySegment.endRound(newEndRound, playerInEndRoundArray)
        historySegments[endRoundIndex] = newGameHistorySegment
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
