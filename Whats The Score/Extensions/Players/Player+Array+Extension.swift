//
//  Player+Array+Extension.swift
//  Whats The Score
//
//  Created by Curt on 6/1/25.
//

import Foundation

extension Array where Element == any PlayerProtocol {
    func sorted(isLowestWinning: Bool) -> [any PlayerProtocol] {
        if isLowestWinning {
            return self.sorted { $0.score < $1.score }
        } else {
            return self.sorted { $0.score > $1.score }
        }
    }
}
