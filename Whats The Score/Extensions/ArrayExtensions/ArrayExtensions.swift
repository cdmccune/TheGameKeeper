//
//  ArrayExtensions.swift
//  Whats The Score
//
//  Created by Curt McCune on 1/16/24.
//

import Foundation

extension Array where Element == Player {
    mutating func setPositions() {
        for position in self.indices {
            self[position].position = position
        }
    }
}
