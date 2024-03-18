//
//  ArrayExtensions.swift
//  Whats The Score
//
//  Created by Curt McCune on 1/16/24.
//

import Foundation

extension Array where Element == PlayerProtocol {
    mutating func setPositions() {
        for position in self.indices {
            self[position].position = position
        }
    }
}

extension Array where Element == GameHistorySegment {
    func getIndexOfElement(withID id: UUID) -> Index? {
        return self.firstIndex(where: { $0.id == id })
    }
}
