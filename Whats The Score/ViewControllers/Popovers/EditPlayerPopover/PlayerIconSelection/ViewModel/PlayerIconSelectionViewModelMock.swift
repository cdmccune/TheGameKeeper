//
//  PlayerIconSelectionViewModelMock.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 4/18/24.
//

import Foundation
@testable import Whats_The_Score

class PlayerIconSelectionViewModelMock: PlayerIconSelectionViewModelProtocol {
    var icons: [Whats_The_Score.PlayerIcon] = []
    var delegate: PlayerIconSelectionDelegate?
    var shouldDismiss: Observable<Bool> = Observable(nil)
    
    var iconSelectedAtRow: Int?
    var iconSelectedAtCalledCount = 0
    func iconSelectAt(row: Int) {
        iconSelectedAtRow = row
        iconSelectedAtCalledCount += 1
    }
}
