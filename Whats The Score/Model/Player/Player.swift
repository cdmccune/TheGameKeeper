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
    var scoreChanges: Set<ScoreChange> { get set }
    func getScoreThrough(_ scoreChange: ScoreChange) -> Int
}

class Player: NSManagedObject, PlayerProtocol {
    
//    static func getBasicPlayer() -> Player {
//        return Player(name: "", position: 0)
//    }
    
//    init(name: String, position: Int, id: UUID = UUID()) {
//        self._name = name
//        self.position = position
//        self.id = id
//    }
    
    convenience init(game: Game, name: String, position: Int, context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = UUID()
        self.name = name
        self.position = position
        self.game = game
        self.scoreChanges = []
    }
    
    #warning("want to make sure the changes I make are tested, so gotta comb through the tests and figure that out. Gotta make the entities initializable with correct params. then create mocks for them with fake contexts'")
    
    @NSManaged public var id: UUID
    @NSManaged public var game: Game
    @NSManaged public var scoreChanges: Set<ScoreChange>
    @NSManaged public var name: String
    @NSManaged public var position_: Int64
    
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
    
//    var name: String {
//        get {
//            _name.isEmpty ? "Player \(position + 1)" : _name
//        }
//        
//        set {
//            _name = newValue
//        }
//    }
    
//    var hasDefaultName: Bool {
//            _name.isEmpty
//    }
    
    
    func getScoreThrough(_ scoreChange: ScoreChange) -> Int {
//        if let index = scoreChanges.firstIndex(of: scoreChange) {
//            let scoreChangesUpUntilPoint = scoreChanges[0...index]
//            return scoreChangesUpUntilPoint.reduce(0) { partialResult, scoreChange in
//                partialResult + scoreChange.scoreChange
//            }
//        } else {
            return 0
//        }
    }
}

//extension Player: Equatable {}
//func == (rhs: Player, lhs: Player) -> Bool {
//    return rhs.id == lhs.id
//}
