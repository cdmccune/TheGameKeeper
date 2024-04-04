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
    var scoreChanges: [ScoreChange] { get set }
    var hasDefaultName: Bool { get }
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
    
    @NSManaged public var game: Game?
    @NSManaged public var player: Player?
    
    private var _name: String = ""
    var position: Int = 0
    var score: Int {
                scoreChanges.reduce(0) { partialResult, scoreChange in
                    partialResult + scoreChange.scoreChange
                }
            }
    var id: UUID = UUID()
    var scoreChanges = [ScoreChange]()
    
    var name: String {
        get {
            _name.isEmpty ? "Player \(position + 1)" : _name
        }
        
        set {
            _name = newValue
        }
    }
    
    var hasDefaultName: Bool {
            _name.isEmpty
    }
    
    
    func getScoreThrough(_ scoreChange: ScoreChange) -> Int {
        if let index = scoreChanges.firstIndex(of: scoreChange) {
            let scoreChangesUpUntilPoint = scoreChanges[0...index]
            return scoreChangesUpUntilPoint.reduce(0) { partialResult, scoreChange in
                partialResult + scoreChange.scoreChange
            }
        } else {
            return 0
        }
    }
}

//extension Player: Equatable {}
//func == (rhs: Player, lhs: Player) -> Bool {
//    return rhs.id == lhs.id
//}
