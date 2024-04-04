//
//  ScoreChange.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/11/24.
//

import Foundation
import CoreData

// enum GameHistorySegment {
//    case scoreChange(ScoreChange, PlayerProtocol)
//    case endRound(EndRound, [PlayerProtocol])
//    
//    var id: UUID {
//        switch self {
//        case .scoreChange(let scoreChange, _):
//            return scoreChange.id
//        case .endRound(let endRound, _):
//            return endRound.id
//        }
//    }
// }
//
// extension GameHistorySegment: Equatable {
// }
// func == (lhs: GameHistorySegment, rhs: GameHistorySegment) -> Bool {
//    return lhs.id == rhs.id
// }

protocol ScoreChangeProtocol {
    var endRound: EndRound? { get set }
    var game: Game? { get set }
    var player: Player { get set }
    var scoreChange: Int { get set }
    var id: UUID { get set }
}

class ScoreChange: NSManagedObject, ScoreChangeProtocol {
    
    convenience init(player: Player, context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = UUID()
        self.player = player
    }
    
//    init(player: PlayerProtocol, scoreChange: Int) {
//        self.playerID = player.id
//        self.playerName = player.name
//        self.scoreChange = scoreChange
//    }
    
//    static func getBlankScoreChange() -> ScoreChange {
//        return ScoreChange(player: Player.getBasicPlayer(), scoreChange: 0)
//    }
    
    @NSManaged public var endRound: EndRound?
    @NSManaged public var game: Game?
    @NSManaged public var player: Player
    @NSManaged public var scoreChange_: Int64
    @NSManaged public var id: UUID
    
    var scoreChange: Int {
        get {
            return Int(truncatingIfNeeded: scoreChange_)
        }
        set {
            scoreChange_ = Int64(newValue)
        }
    }
}

//extension ScoreChange: Equatable {}
//func == (lhs: ScoreChange, rhs: ScoreChange) -> Bool {
//    return lhs.id == rhs.id
//}

