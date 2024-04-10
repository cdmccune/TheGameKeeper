//
//  Player.swift
//  What's The Score
//
//  Created by Curt McCune on 1/9/24.
//

import Foundation
import CoreData

protocol PlayerProtocol {
    var name: String { get set }
    var score: Int { get }
    var id: UUID { get }
    var position: Int { get set }
    var scoreChanges: [ScoreChangeProtocol] { get }
    func getScoreThrough(_ scoreChange: ScoreChangeProtocol) -> Int
}

class Player: NSManagedObject, PlayerProtocol {
    
    convenience init(game: Game, name: String, position: Int, context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = UUID()
        self.name = name
        self.position = position
        self.game = game
        self.scoreChanges_ = []
    }
    
    @NSManaged public var id: UUID
    @NSManaged public var game: Game
    @NSManaged private var scoreChanges_: Set<ScoreChange>
    @NSManaged public var name: String
    @NSManaged private var position_: Int64
    
    var position: Int {
        get {
            return Int(truncatingIfNeeded: position_)
        }
        set {
            position_ = Int64(newValue)
        }
    }
    
    var score: Int {
        scoreChanges.reduce(0) { partialResult, scoreChange in
            partialResult + scoreChange.scoreChange
        }
    }
    
    var scoreChanges: [ScoreChangeProtocol] {
        return Array(scoreChanges_).sorted { $0.position < $1.position }
    }
    
    
    func getScoreThrough(_ scoreChange: ScoreChangeProtocol) -> Int {
        if let index = scoreChanges.firstIndex(where: { $0.id == scoreChange.id }) {
            let scoreChangesUpUntilPoint = scoreChanges[0...index]
            return scoreChangesUpUntilPoint.reduce(0) { partialResult, scoreChange in
                partialResult + scoreChange.scoreChange
            }
        } else {
            return 0
        }
    }
}

extension Player {
    @objc(addScoreChanges_Object:)
    @NSManaged public func addToScoreChanges_(_ value: ScoreChange)
}
