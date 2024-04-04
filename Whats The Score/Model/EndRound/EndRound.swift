//
//  EndRound.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/4/24.
//

import Foundation
import CoreData

class EndRound: NSManagedObject {
//    static func getBlankEndRound() -> EndRound {
//        return EndRound(roundNumber: 0, scoreChangeArray: [])
//    }
    
//    static func getEndRoundWith(numberOfPlayers: Int) -> EndRound {
//        var scoreChanges: [ScoreChange] = []
//        for _ in 0..<numberOfPlayers {
//            scoreChanges.append(ScoreChange(player: Player.getBasicPlayer(), scoreChange: 0))
//        }
//        return EndRound(roundNumber: 0, scoreChangeArray: scoreChanges)
//    }
    
//    init(roundNumber: Int, scoreChangeArray: [ScoreChange]) {
//        self.roundNumber = roundNumber
//        self.scoreChangeArray = scoreChangeArray
//    }
    
//    init(withPlayers players: [PlayerProtocol], roundNumber: Int) {
//        self.roundNumber = roundNumber
//
//        var scoreChangeArray: [ScoreChange] = []
//        players.forEach { scoreChangeArray.append(ScoreChange(player: $0, scoreChange: 0))}
//        self.scoreChangeArray = scoreChangeArray
//    }
    
    var id: UUID = UUID()
    var roundNumber: Int = 0
    @NSManaged public var scoreChanges: Set<ScoreChange>
//    var scoreChangeArray: [ScoreChange]
}

//extension EndRound: Equatable {}
//func == (lhs: EndRound, rhs: EndRound) -> Bool {
//    return lhs.id == rhs.id
//}
