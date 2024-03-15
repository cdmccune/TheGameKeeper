//
//  Player.swift
//  What's The Score
//
//  Created by Curt McCune on 1/9/24.
//

import Foundation

protocol PlayerProtocol {
    var name: String { get set }
    var score: Int { get }
    var id: UUID { get }
    var position: Int { get set }
    var scoreChanges: [ScoreChange] { get set }
    var hasDefaultName: Bool { get }
    func getScoreThrough(_ scoreChange: ScoreChange) -> Int
}

class Player: PlayerProtocol, Hashable {
    
    static func getBasicPlayer() -> Player {
        return Player(name: "", position: 0)
    }
    
    init(name: String, position: Int, id: UUID = UUID()) {
        self._name = name
        self.position = position
        self.id = id
        
    }
    
    private var _name: String = ""
    var position: Int
    var score: Int {
                scoreChanges.reduce(0) { partialResult, scoreChange in
                    partialResult + scoreChange.scoreChange
                }
            }
    var id: UUID
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
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
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

extension Player: Equatable {}
func == (rhs: Player, lhs: Player) -> Bool {
    return rhs.id == lhs.id
}
