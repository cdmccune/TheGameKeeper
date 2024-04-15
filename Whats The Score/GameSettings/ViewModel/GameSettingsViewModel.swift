//
//  GameSettingsViewModel.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/19/24.
//

import Foundation

protocol GameSettingsViewModelProtocol {
    var gameEndType: Observable<GameEndType> { get }
    var numberOfRounds: Int { get set }
    var endingScore: Int { get set }
    var game: GameProtocol { get set }
    var delegate: GameSettingsDelegate? { get }

    func setInitialValues()
    func saveChanges()
    func deleteGame()
}

class GameSettingsViewModel: GameSettingsViewModelProtocol {
    
    init(game: GameProtocol, delegate: GameSettingsDelegate? = nil) {
        self.numberOfRounds = game.numberOfRounds
        self.endingScore = game.endingScore
        self.game = game
        self.delegate = delegate
    }

    var numberOfRounds: Int
    var endingScore: Int
    var game: GameProtocol
    var delegate: GameSettingsDelegate?
    
    var gameEndType: Observable<GameEndType> = Observable(nil)
    
    func setInitialValues() {
        gameEndType.value = game.gameEndType
    }
    
    func saveChanges() {
        guard let gameEndType = gameEndType.value else { return }
        
        delegate?.updateGameSettings(gameEndType: gameEndType, numberOfRounds: numberOfRounds, endingScore: endingScore)
    }
    
    func deleteGame() {
        delegate?.deleteGame()
    }
}
