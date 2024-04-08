//
//  GameFunctions.swift
//  What's The Score
//
//  Created by Curt McCune on 12/30/23.
//

import Foundation
import CoreData

extension Game {
    
    // MARK: - Functions
    
    func changeName(of player: PlayerProtocol, to name: String) {
        guard var playerToUpdateName = players.first(where: { $0.id == player.id }) else { return }
        
        playerToUpdateName.name = name
    }
    
    func movePlayerAt(_ sourceRowIndex: Int, to destinationRowIndex: Int) {
//        guard players.indices.contains(sourceRowIndex),
//              players.indices.contains(destinationRowIndex) else { return }
//        
//        let playerToMove = players[sourceRowIndex]
//        players.remove(at: sourceRowIndex)
//        players.insert(playerToMove, at: destinationRowIndex)
//        players.setPositions()
    }
    
    func addPlayer(withName name: String) {
        guard let managedObjectContext else { return }
        _ = Player(game: self, name: name, position: players.count, context: managedObjectContext)
    }
//    
    func randomizePlayers() {
//        players.shuffle()
//        players.setPositions()
    }
//    
    func deletePlayer(_ player: PlayerProtocol) {
        guard let playerObject = player as? Player else { return }
        removeFromPlayers_(playerObject)
        
        var playersToSetPosition = players
        playersToSetPosition.setPositions()
        
//        guard players.indices.contains(index) else {
//            return
//        }
//        
//        let player = players[index]
//        
//        players.remove(at: index)
//        players.setPositions()
//        
//        
////        // Cycle backwards through history so deleting one won't affect other indices
////        historySegments.enumerated().reversed().forEach { (segmentIndex, segment) in
////            
////            // Check if history segment is score change
////            if case .scoreChange(_, let segmentPlayer) = segment {
////                
////                // Remove segment from history if it's players
////                if player.id == segmentPlayer.id {
////                    historySegments.remove(at: segmentIndex)
////                }
////            } else if case .endRound(var endRound, var players) = segment {
////                
////                // Remove players and score changes from end round segment
////                players.removeAll { $0.id == player.id }
////                endRound.scoreChangeArray.removeAll { $0.playerID == player.id }
////                
////                // Set EndRound segment to values with player removed
////                historySegments[segmentIndex] = GameHistorySegment.endRound(endRound, players)
////            }
////        }
    }
    
    func editScore(scoreChange: ScoreChangeProtocol) {
//        guard let index = players.firstIndex(where: { $0.id == scoreChange.playerID }) else { return }
//        
//        players[index].scoreChanges.append(scoreChange)
////        let historySegment = GameHistorySegment.scoreChange(scoreChange, players[index])
////        
////        historySegments.append(historySegment)
    }
    
    func endRound(_ endRound: EndRoundProtocol) {
//
//        var playersInThisRound: [PlayerProtocol] = []
//        
//        endRound.scoreChangeArray.forEach { scoreChange in
//            if let index = players.firstIndex(where: { $0.id == scoreChange.playerID }) {
//                players[index].scoreChanges.append(scoreChange)
//                playersInThisRound.append(players[index])
//            } else {
//                fatalError("Player not found")
//            }
//        }
//        
////        let historySegment = GameHistorySegment.endRound(endRound, playersInThisRound)
////        historySegments.append(historySegment)
//        
//        currentRound += 1
    }
    
    func updateSettings(with gameEndType: GameEndType, endingScore: Int, andNumberOfRounds numberOfRounds: Int) {
        self.gameEndType = gameEndType
        self.numberOfRounds = numberOfRounds
        self.endingScore = endingScore
    }
    
    func deleteHistorySegmentAt(index: Int) {
////        guard historySegments.indices.contains(index) else { return }
////        
////        let historySegmentToRemove = historySegments[index]
////        
////        // Remove History Segment from game
////        historySegments.remove(at: index)
////        
////        if case .scoreChange(let scoreChange, var player) = historySegmentToRemove {
////            // Remove scoreChange from player
////            player.scoreChanges.removeAll { $0 == scoreChange }
////            
////        } else if case .endRound(let endRound, _) = historySegmentToRemove {
////            
////            // Set New Round Numbers For End Round Segments
////            var endRoundCount = 1
////            historySegments.enumerated().forEach { (index, segment) in
////                if case .endRound(var newEndRound, let endRoundPlayers) = segment {
////                    newEndRound.roundNumber = endRoundCount
////                    historySegments[index] = GameHistorySegment.endRound(newEndRound, endRoundPlayers)
////                    
////                    endRoundCount += 1
////                }
////            }
////            
////            // Set new current round number
////            self.currentRound = endRoundCount
////            
////            // For each score change that needs to be deleted
////            endRound.scoreChangeArray.forEach { endRoundScoreChange in
////                
////                // If it is tied to player in array and player has score change
////                if var player = players.first(where: { $0.id == endRoundScoreChange.playerID }),
////                   let indexOfScoreChangeToRemove = player.scoreChanges.firstIndex(of: endRoundScoreChange) {
////                    
////                    // Delete the score change
////                    player.scoreChanges.remove(at: indexOfScoreChangeToRemove)
////                }
////            }
////        }
//        
//       
    }
    
    func resetGame() {
//        for i in 0..<players.count {
//            players[i].scoreChanges = []
//        }
//        
//        currentRound = 1
//        
////        historySegments = []
    }
    
    func editScoreChange(_ newScoreChange: ScoreChangeProtocol) {
//
////        if let playerIndex = players.firstIndex(where: { $0.id == newScoreChange.playerID }),
////           let scoreChangeIndex = historySegments.getIndexOfElement(withID: newScoreChange.id),
////           case .scoreChange(let scoreChangeOriginal, let player) = historySegments[scoreChangeIndex] {
////            
////            guard let scoreChangeIndex = players[playerIndex].scoreChanges.firstIndex(of: newScoreChange) else {
////                fatalError("Score change not found")
////            }
////            
////            players[playerIndex].scoreChanges[scoreChangeIndex] = (newScoreChange)
////            historySegments[scoreChangeIndex] = .scoreChange(newScoreChange, players[playerIndex])
////        }
    }
    
    func editEndRound(_ newEndRound: EndRoundProtocol) {
//
//        var playerInEndRoundArray = [PlayerProtocol]()
//        
//        // Loop through new score changes
//        newEndRound.scoreChangeArray.forEach { newScoreChange in
//            // find player index for player in new scoreChange
//            guard let playerIndex = players.firstIndex(where: { $0.id == newScoreChange.playerID }) else {
//                fatalError("Player not in player array")
//            }
//            
//            var player = players[playerIndex]
//            
//            // Append player to players in this endRound array
//            playerInEndRoundArray.append(player)
//            
//            // Find the index of score change in player
//            guard let playerScoreChangeIndex = player.scoreChanges.firstIndex(of: newScoreChange) else {
//                fatalError("Score change not in player score change array")
//            }
//            
//            // Set player ScoreChange to new value
//            player.scoreChanges[playerScoreChangeIndex] = newScoreChange
//        }
//        
////        // Find the end round history object
////        guard let endRoundIndex = historySegments.getIndexOfElement(withID: newEndRound.id) else {
////            fatalError("EndRound object not found")
////        }
////        
////        // Set the history object to new changes
////        let newGameHistorySegment = GameHistorySegment.endRound(newEndRound, playerInEndRoundArray)
////        historySegments[endRoundIndex] = newGameHistorySegment
    }
    
    // MARK: - Non-Mutating Functions
    
    func isEqualTo(game: GameProtocol) -> Bool {
        return self.id == game.id
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

// MARK: Generated accessors for players
extension Game {

    @objc(addPlayers_Object:)
    @NSManaged public func addToPlayers_(_ value: Player)

    @objc(removePlayers_Object:)
    @NSManaged public func removeFromPlayers_(_ value: Player)

    @objc(addPlayers_:)
    @NSManaged public func addToPlayers_(_ values: NSSet)

    @objc(removePlayers_:)
    @NSManaged public func removeFromPlayers_(_ values: NSSet)

}

// MARK: Generated accessors for endRounds
extension Game {

    @objc(addEndRoundsObject:)
    @NSManaged public func addToEndRounds_(_ value: EndRound)

    @objc(removeEndRoundsObject:)
    @NSManaged public func removeFromEndRounds_(_ value: EndRound)

    @objc(addEndRounds:)
    @NSManaged public func addToEndRounds_(_ values: NSSet)

    @objc(removeEndRounds:)
    @NSManaged public func removeFromEndRounds_(_ values: NSSet)

}

// MARK: Generated accessors for scoreChanges
extension Game {

    @objc(addScoreChangesObject:)
    @NSManaged public func addToScoreChanges_(_ value: ScoreChange)

    @objc(removeScoreChangesObject:)
    @NSManaged public func removeFromScoreChanges_(_ value: ScoreChange)

    @objc(addScoreChanges:)
    @NSManaged public func addToScoreChanges_(_ values: NSSet)

    @objc(removeScoreChanges:)
    @NSManaged public func removeFromScoreChanges_(_ values: NSSet)

}

extension Game: Identifiable {

}
