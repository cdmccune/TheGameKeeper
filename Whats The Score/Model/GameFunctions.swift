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
        managedObjectContext?.delete(playerObject)
        
        var playersToSetPosition = players
        playersToSetPosition.setPositions()
    }
    
    func deleteEndRound(_ endRound: EndRoundProtocol) {
        guard let endRoundObject = endRound as? EndRound else { return }
        removeFromEndRounds_(endRoundObject)
        managedObjectContext?.delete(endRoundObject)
        
        var endRounds = endRounds
        for i in 0..<endRounds.count {
            endRounds[i].roundNumber = i + 1
        }
    }
    
    func deleteScoreChange(_ scoreChange: ScoreChangeProtocol) {
        guard let scoreChangeObject = scoreChange as? ScoreChange else { return }
        removeFromScoreChanges_(scoreChangeObject)
        managedObjectContext?.delete(scoreChangeObject)
        
        var scoreChanges = scoreChanges
        for i in 0..<scoreChanges.count {
            scoreChanges[i].position = i
        }
    }
    
    func changeScore(with scoreChangeSettings: ScoreChangeSettings) {
        guard let managedObjectContext else { return }
        guard players.contains(where: { $0.id == scoreChangeSettings.player.id }),
              let player = scoreChangeSettings.player as? Player else { return }
        
        _ = ScoreChange(player: player,
                        scoreChange: scoreChangeSettings.scoreChange,
                        position: scoreChanges.count,
                        game: self,
                        context: managedObjectContext)
    }
    
    //    func editScore(scoreChange: ScoreChangeProtocol) {
    //        guard let index = players.firstIndex(where: { $0.id == scoreChange.playerID }) else { return }
//        
//        players[index].scoreChanges.append(scoreChange)
////        let historySegment = GameHistorySegment.scoreChange(scoreChange, players[index])
////        
////        historySegments.append(historySegment)
//    }
    
    func endRound(with endRoundSettings: EndRoundSettings) {
        guard let managedObjectContext else { return }
        
        let endRound = EndRound(game: self, roundNumber: 0, scoreChanges: [], context: managedObjectContext)
        
        endRoundSettings.scoreChangeSettingsArray.enumerated().forEach { (index, scoreChangeSettings) in
            guard players.contains(where: { $0.id == scoreChangeSettings.player.id }),
                  let player = scoreChangeSettings.player as? Player else { return }
            
            _ = ScoreChange(player: player,
                            scoreChange: scoreChangeSettings.scoreChange,
                            position: index,
                            endRound: endRound,
                            context: managedObjectContext)
            
        }
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
        currentRound += 1
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
        
        if let scoreChanges = scoreChanges as? [ScoreChange] {
            scoreChanges.forEach { scoreChange in
                managedObjectContext?.delete(scoreChange)
            }
        }
        
        if let endRounds = endRounds as? [EndRound] {
            endRounds.forEach { endRounds in
                managedObjectContext?.delete(endRounds)
            }
        }
        
        currentRound = 1
    }
    
    func editScoreChange(_ newScoreChange: ScoreChangeSettings) {
        guard let id = newScoreChange.scoreChangeID,
              var scoreChange = newScoreChange.player.scoreChanges.first(where: { $0.id == id }) else {
            return
        }
        
        scoreChange.scoreChange = newScoreChange.scoreChange
    }
    
    func editEndRound(_ newEndRound: EndRoundSettings) {
        
        guard let id = newEndRound.endRoundID,
              let endRound = endRounds.first(where: { $0.id == id }) else {
            return
        }
        
        newEndRound.scoreChangeSettingsArray.forEach { scoreChangeSetting in
            if var scoreChange = endRound.scoreChanges.first(where: { $0.id == scoreChangeSetting.scoreChangeID }) {
                scoreChange.scoreChange = scoreChangeSetting.scoreChange
            }
        }
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

    @objc(addEndRounds_Object:)
    @NSManaged public func addToEndRounds_(_ value: EndRound)

    @objc(removeEndRounds_Object:)
    @NSManaged public func removeFromEndRounds_(_ value: EndRound)

    @objc(addEndRounds_:)
    @NSManaged public func addToEndRounds_(_ values: NSSet)

    @objc(removeEndRounds_:)
    @NSManaged public func removeFromEndRounds_(_ values: NSSet)

}

// MARK: Generated accessors for scoreChanges
extension Game {

    @objc(addScoreChanges_Object:)
    @NSManaged public func addToScoreChanges_(_ value: ScoreChange)

    @objc(removeScoreChanges_Object:)
    @NSManaged public func removeFromScoreChanges_(_ value: ScoreChange)

    @objc(addScoreChanges_:)
    @NSManaged public func addToScoreChanges_(_ values: NSSet)

    @objc(removeScoreChanges_:)
    @NSManaged public func removeFromScoreChanges_(_ values: NSSet)

}

extension Game: Identifiable {

}
