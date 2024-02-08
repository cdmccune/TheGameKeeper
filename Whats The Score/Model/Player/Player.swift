//
//  Player.swift
//  What's The Score
//
//  Created by Curt McCune on 1/9/24.
//

import Foundation

struct Player {
    init(name: String, position: Int, score: Int = 0, id: UUID = UUID()) {
        self._name = name
        self.position = position
        self.score = score
        self.id = id
        
    }
    
    private var _name: String = ""
    var position: Int
    var score: Int
    var id: UUID
    
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
}

extension Player: Equatable {}
func == (rhs: Player, lhs: Player) -> Bool {
    return rhs.id == lhs.id
}
