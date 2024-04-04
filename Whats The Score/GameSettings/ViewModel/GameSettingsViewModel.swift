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
    var game: Game { get set }
    var delegate: GameSettingsDelegate? { get }

    func setInitialValues()
    func saveChanges()
}

class GameSettingsViewModel: GameSettingsViewModelProtocol {
    
    init(game: Game, delegate: GameSettingsDelegate? = nil) {
        self.numberOfRounds = game.numberOfRounds
        self.endingScore = game.endingScore
        self.game = game
        self.delegate = delegate
    }

    var numberOfRounds: Int
    var endingScore: Int
    var game: Game
    var delegate: GameSettingsDelegate?
    
    var gameEndType: Observable<GameEndType> = Observable(nil)
    
    func setInitialValues() {
        gameEndType.value = game.gameEndType
    }
    
    func saveChanges() {
        guard let gameEndType = gameEndType.value else { return }
        
        game.updateSettings(with: gameEndType, endingScore: endingScore, andNumberOfRounds: numberOfRounds)
        delegate?.update(game)
    }
}
