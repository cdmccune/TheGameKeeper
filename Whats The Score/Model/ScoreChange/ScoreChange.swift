//
//  ScoreChange.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/11/24.
//

import Foundation
import CoreData

class ScoreChange: NSManagedObject, ScoreChangeProtocol {
    
    convenience init(player: Player, scoreChange: Int, position: Int, game: Game? = nil, endRound: EndRound? = nil, context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = UUID()
        self.player_ = player
        self.game = game
        self.endRound = endRound
        self.scoreChange = scoreChange
        self.position = position
    }
    
    @NSManaged public var endRound: EndRound?
    @NSManaged public var game: Game?
    @NSManaged public var id: UUID
    @NSManaged private var scoreChange_: Int64
    @NSManaged private var player_: Player
    @NSManaged private var position_: Int64
    
    var scoreChange: Int {
        get {
            return Int(truncatingIfNeeded: scoreChange_)
        }
        set {
            scoreChange_ = Int64(newValue)
        }
    }
    
    var player: PlayerProtocol {
        player_
    }
    
    var position: Int {
        get {
            return Int(truncatingIfNeeded: position_)
        }
        set {
            position_ = Int64(newValue)
        }
    }
}
