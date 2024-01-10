//
//  Player.swift
//  What's The Score
//
//  Created by Curt McCune on 1/9/24.
//

import Foundation

struct Player {
    init(name: String, position: Int) {
        self._name = name
        self.position = position
    }
    
    private var _name: String = ""
    var position: Int
    
    var name: String {
        get {
            _name.isEmpty ? "Player \(position + 1)" : _name
        }
        
        set {
            _name = newValue
        }
    }
}

extension Player: Equatable {}
func ==(rhs: Player, lhs: Player) -> Bool {
    return rhs.name == lhs.name && rhs.position == lhs.position
}
