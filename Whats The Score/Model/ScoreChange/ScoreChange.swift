//
//  ScoreChange.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/11/24.
//

import Foundation
import CoreData

//enum GameHistorySegment {
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
//}
//
//extension GameHistorySegment: Equatable {
//}
//func == (lhs: GameHistorySegment, rhs: GameHistorySegment) -> Bool {
//    return lhs.id == rhs.id
//}

class ScoreChange: NSManagedObject {
    
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
    
    var id: UUID = UUID()
    var playerID: UUID = UUID()
    var playerName: String = ""
    var scoreChange: Int = 0
}

//extension ScoreChange: Equatable {}
//func == (lhs: ScoreChange, rhs: ScoreChange) -> Bool {
//    return lhs.id == rhs.id
//}

