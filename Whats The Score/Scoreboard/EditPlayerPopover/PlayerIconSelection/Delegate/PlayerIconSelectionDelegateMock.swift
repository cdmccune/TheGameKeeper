//
//  PlayerIconSelectionDelegateMock.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 4/19/24.
//

import Foundation
@testable import Whats_The_Score

class PlayerIconSelectionDelegateMock: PlayerIconSelectionDelegate {
    var newIconSelectedCalledCount = 0
    var newIconSelectedIcon: PlayerIcon?
    func newIconSelected(icon: PlayerIcon) {
        newIconSelectedCalledCount += 1
        newIconSelectedIcon = icon
    }
}
