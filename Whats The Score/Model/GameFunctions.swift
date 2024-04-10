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
        
        currentRound -= 1
        
        var endRounds = endRounds
        for i in 0..<endRounds.count {
            endRounds[i].roundNumber = i + 1
            for var scoreChange in endRounds[i].scoreChanges {
                scoreChange.position = i
            }
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
    
    func endRound(with endRoundSettings: EndRoundSettings) {
        guard let managedObjectContext else { return }
        
        let endRound = EndRound(game: self, roundNumber: endRoundSettings.roundNumber, scoreChanges: [], context: managedObjectContext)
        
        endRoundSettings.scoreChangeSettingsArray.forEach { scoreChangeSettings in
            guard players.contains(where: { $0.id == scoreChangeSettings.player.id }),
                  let player = scoreChangeSettings.player as? Player else { return }
            
            _ = ScoreChange(player: player,
                            scoreChange: scoreChangeSettings.scoreChange,
                            position: endRoundSettings.roundNumber,
                            endRound: endRound,
                            context: managedObjectContext)
            
        }
        
        currentRound += 1
    }
    
    func updateSettings(with gameEndType: GameEndType, endingScore: Int, andNumberOfRounds numberOfRounds: Int) {
        self.gameEndType = gameEndType
        self.numberOfRounds = numberOfRounds
        self.endingScore = endingScore
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
