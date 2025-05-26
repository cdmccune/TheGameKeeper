//
//  ScoreboardViewModel-DataFunctions.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/9/24.
//

import Foundation
import CoreData


extension ScoreboardViewModel {
    func undoLastAction() {
        game.undoLastAction()
        coreDataStore.saveContext()
        delegate?.bindViewToViewModel(dispatchQueue: DispatchQueue.main)
    }
    
    func deletePlayer(_ player: PlayerProtocol) {
        game.deletePlayer(player)
        coreDataStore.saveContext()
        delegate?.bindViewToViewModel(dispatchQueue: DispatchQueue.main)
    }
}

extension ScoreboardViewModel: EditPlayerPopoverDelegateProtocol {
    
    func finishedEditing(_ player: PlayerSettings) {
        if sortedPlayers.contains(where: { $0.id == player.id }) {
            game.editPlayer(player)
        } else {
            game.addPlayer(withSettings: player)
        }
        
        
        coreDataStore.saveContext()
        delegate?.bindViewToViewModel(dispatchQueue: DispatchQueue.main)
    }
}

extension ScoreboardViewModel: ScoreboardPlayerEditScorePopoverDelegate {
    
    func editScore(_ scoreChange: ScoreChangeSettings) {
        game.changeScore(with: scoreChange)
        delegate?.bindViewToViewModel(dispatchQueue: DispatchQueue.main)
        
        coreDataStore.saveContext()
        
        if game.isEndOfGame() {
            coordinator?.showEndGamePopover(withGame: game, andDelegate: self, delay: 1.0)
        }
    }
}

extension ScoreboardViewModel: EndRoundPopoverDelegateProtocol {
    
    func endRound(_ endRound: EndRoundSettings) {
        self.game.endRound(with: endRound)
        self.coreDataStore.saveContext()
        
        self.delegate?.bindViewToViewModel(dispatchQueue: DispatchQueue.main)
        
        if game.isEndOfGame() {
            coordinator?.showEndGamePopover(withGame: game, andDelegate: self, delay: 1.0)
        }
    }
}

extension ScoreboardViewModel: GameSettingsDelegate {
    
    func updateGameSettings(gameName: String, gameEndType: GameEndType, numberOfRounds: Int, endingScore: Int, lowestIsWinning: Bool) {
        self.game.updateSettings(withGameName: gameName, gameEndType, endingScore: endingScore, andNumberOfRounds: numberOfRounds, lowestIsWinning: lowestIsWinning)
        self.coreDataStore.saveContext()
        self.delegate?.bindViewToViewModel(dispatchQueue: dispatchQueue)
    }
    
    func resetGame() {
        game.resetGame()
        coreDataStore.saveContext()
        coordinator?.gameWasReset()
        delegate?.bindViewToViewModel(dispatchQueue: DispatchQueue.main)
    }
    
    func deleteGame() {
        self.coordinator?.deleteGame()
    }
}

extension ScoreboardViewModel: KeepPlayingPopoverDelegate {
    
    func updateNumberOfRounds(to numberOfRounds: Int) {
        self.game.numberOfRounds = numberOfRounds
        self.coreDataStore.saveContext()
        self.delegate?.bindViewToViewModel(dispatchQueue: dispatchQueue)
    }
    
    func updateWinningScore(to winningScore: Int) {
        self.game.endingScore = winningScore
        self.coreDataStore.saveContext()
        self.delegate?.bindViewToViewModel(dispatchQueue: dispatchQueue)
    }
    
    func setNoEnd() {
        self.game.gameEndType = .none
        self.coreDataStore.saveContext()
        self.delegate?.bindViewToViewModel(dispatchQueue: dispatchQueue)
    }
}
