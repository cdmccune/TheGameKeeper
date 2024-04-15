//
//  GameSettingsDelegate.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/19/24.
//

import Foundation

protocol GameSettingsDelegate: AnyObject {
    func updateGameSettings(gameEndType: GameEndType, numberOfRounds: Int, endingScore: Int)
    func deleteGame()
}
