//
//  PlayerSettings.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/8/24.
//

import Foundation

struct PlayerSettings {
    var name: String
    var icon: PlayerIcon
    var id: UUID?
}

extension PlayerSettings: Equatable {}
func == (lhs: PlayerSettings, rhs: PlayerSettings) -> Bool {
    if let lhsID = lhs.id, let rhsID = rhs.id {
        return lhsID == rhsID
    } else {
        return lhs.name == rhs.name
    }
}
