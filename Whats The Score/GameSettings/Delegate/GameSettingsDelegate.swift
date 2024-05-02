//
//  GameSettingsDelegate.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/19/24.
//

import Foundation

protocol GameSettingsDelegate: AnyObject {
    func updateGameSettings(gameName: String, gameEndType: GameEndType, numberOfRounds: Int, endingScore: Int)
    func resetGame()
    func deleteGame()
}
