//
//  PlayerSettings.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/8/24.
//

import Foundation

struct PlayerSettings {
    var name: String
}

extension PlayerSettings: Equatable {}
func == (lhs: PlayerSettings, rhs: PlayerSettings) -> Bool {
    return lhs.name == rhs.name
}
