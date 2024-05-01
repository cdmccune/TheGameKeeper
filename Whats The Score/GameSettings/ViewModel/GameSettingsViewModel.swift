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
    func gameEndQuantityChanged(to gameEndQuantity: Int)
    func gameEndTypeChanged(toRawValue rawValue: Int)
    func validateGameSettings()
}

class GameSettingsViewModel: GameSettingsViewModelProtocol {
    
    init(game: GameProtocol, delegate: GameSettingsDelegate? = nil) {
        self.numberOfRounds = game.numberOfRounds
        self.endingScore = game.endingScore
        self.gameName = game.name
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
    
    func gameEndQuantityChanged(to gameEndQuantity: Int) {
        
        switch gameEndType.value {
        case .round:
            numberOfRounds = gameEndQuantity
        case .score:
            endingScore = gameEndQuantity
        default:
            break
        }
        
        validateGameSettings()
    }
    
    func gameNameChanged(to name: String) {
        gameName = name
        validateGameSettings()
    }

    func gameEndTypeChanged(toRawValue rawValue: Int) {
        gameEndType.value = GameEndType(rawValue: rawValue) ?? GameEndType.none
         validateGameSettings()
    }
    
    func validateGameSettings() {
        if gameName == "" {
            dataValidationString.value = "The game name can't be blank"
        } else if gameEndType.value == .score && endingScore <= game.winningPlayers.first?.score ?? 0 {
            dataValidationString.value = "Winning score must be more than \(game.winningPlayers.first?.score ?? 0)"
        } else if gameEndType.value == .round && numberOfRounds <= game.currentRound {
            dataValidationString.value = "# of rounds must be at least \(game.currentRound)"
        } else {
             dataValidationString.value = ""
        }
    }
}
