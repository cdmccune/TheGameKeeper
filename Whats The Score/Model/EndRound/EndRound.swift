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
    var scoreChanges: [ScoreChangeProtocol] { get }
}

class EndRound: NSManagedObject, EndRoundProtocol {
    
    convenience init(roundNumber: Int, scoreChanges: [ScoreChange], context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = UUID()
        self.roundNumber_ = Int64(roundNumber)
        self.scoreChanges_ = Set(scoreChanges)
    }
    
    
    @NSManaged public var id: UUID
    @NSManaged private var roundNumber_: Int64
    @NSManaged private var scoreChanges_: Set<ScoreChange>
    
    var roundNumber: Int {
        get {
            Int(truncatingIfNeeded: roundNumber_)
        }
        set {
            roundNumber_ = Int64(newValue)
        }
    }
    
    var scoreChanges: [ScoreChangeProtocol] {
        Array(scoreChanges_).sorted { $0.player.position < $1.player.position }
    }
}
