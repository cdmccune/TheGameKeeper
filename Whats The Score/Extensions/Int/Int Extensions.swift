//
//  Int Extensions.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/22/24.
//

import Foundation

extension Int {
    var ordinal: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
