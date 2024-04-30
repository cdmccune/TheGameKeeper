//
//  GameSettingsViewModel.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/19/24.
//

import Foundation

protocol GameSettingsViewModelProtocol {
    var gameEndType: Observable<GameEndType> { get }
    var dataValidationString: Observable<String> { get }
    var numberOfRounds: Int { get set }
    var endingScore: Int { get set }
    var gameName: String { get set }
    var game: GameProtocol { get set }
    var delegate: GameSettingsDelegate? { get }

    func setInitialValues()
    func saveChanges()
    func resetGame()
    func deleteGame()
    func gameNameChanged(to name: String)
}

class GameSettingsViewModel: GameSettingsViewModelProtocol {
    
    init(game: GameProtocol, delegate: GameSettingsDelegate? = nil) {
        self.numberOfRounds = game.numberOfRounds
        self.endingScore = game.endingScore
        self.gameName = ""
        self.game = game
        self.delegate = delegate
    }

    var numberOfRounds: Int
    var endingScore: Int
    var gameName: String
    var game: GameProtocol
    var delegate: GameSettingsDelegate?
    
    var gameEndType: Observable<GameEndType> = Observable(nil)
    var dataValidationString: Observable<String> = Observable(nil)
    
    func setInitialValues() {
        gameEndType.value = game.gameEndType
    }
    
    func saveChanges() {
        guard let gameEndType = gameEndType.value else { return }
        
        delegate?.updateGameSettings(gameEndType: gameEndType, numberOfRounds: numberOfRounds, endingScore: endingScore)
    }
    
    func resetGame() {
        delegate?.resetGame()
    }
    
    func deleteGame() {
        delegate?.deleteGame()
    }
    
    func gameNameChanged(to name: String) {
        gameName = name
       
        dataValidationString.value = name == "" ? "The game name can't be blank" : ""
    }
}
