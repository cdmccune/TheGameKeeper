//
//  EndRound.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/4/24.
//

import Foundation
import CoreData

protocol EndRoundProtocol {
    var id: UUID { get set }
    var roundNumber: Int { get set }
    var scoreChanges: Set<ScoreChange> { get set }
}

class EndRound: NSManagedObject, EndRoundProtocol {
    
    convenience init(roundNumber: Int, scoreChanges: [ScoreChange], context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = UUID()
        self.roundNumber_ = Int64(roundNumber)
        self.scoreChanges = Set(scoreChanges)
    }
    
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
    
    
    @NSManaged public var id: UUID
    @NSManaged private var roundNumber_ : Int64
    @NSManaged public var scoreChanges: Set<ScoreChange>
    
    var roundNumber: Int {
        get {
            Int(truncatingIfNeeded: roundNumber_)
        }
        set {
            roundNumber_ = Int64(newValue)
        }
    }

//    var scoreChangeArray: [ScoreChange]
}

//extension EndRound: Equatable {}
//func == (lhs: EndRound, rhs: EndRound) -> Bool {
//    return lhs.id == rhs.id
//}
