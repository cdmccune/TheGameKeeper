//
//  ScoreboardViewModel-DataFunctions.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/9/24.
//

import Foundation
import CoreData


extension ScoreboardViewModel {
    
    func addPlayer() {
        game.addPlayer(withName: "")
        delegate?.bindViewToViewModel(dispatchQueue: DispatchQueue.main)
    }
    
    func deletePlayer(_ player: PlayerProtocol) {
        game.deletePlayer(player)
        delegate?.bindViewToViewModel(dispatchQueue: DispatchQueue.main)
    }
    
    func resetGame() {
        game.resetGame()
        delegate?.bindViewToViewModel(dispatchQueue: DispatchQueue.main)
    }
    
    func endGame() {
        coordinator?.showEndGamePopover(withGame: game, andDelegate: self)
    }
    
}

extension ScoreboardViewModel: EditPlayerPopoverDelegateProtocol {
    
    func finishedEditing(_ player: PlayerProtocol, toNewName name: String) {
        game.changeName(of: player, to: name)
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
        game.endRound(with: endRound)
        
        delegate?.bindViewToViewModel(dispatchQueue: DispatchQueue.main)
        
        if game.isEndOfGame() {
            coordinator?.showEndGamePopover(withGame: game, andDelegate: self, delay: 1.0)
        }
    }
}

extension ScoreboardViewModel: GameSettingsDelegate {
    
    func updateGameSettings(gameEndType: GameEndType, numberOfRounds: Int, endingScore: Int) {
        game.updateSettings(with: gameEndType, endingScore: endingScore, andNumberOfRounds: numberOfRounds)
        self.delegate?.bindViewToViewModel(dispatchQueue: dispatchQueue)
    }
}

extension ScoreboardViewModel: KeepPlayingPopoverDelegate {
    
    func updateNumberOfRounds(to numberOfRounds: Int) {
        self.game.numberOfRounds = numberOfRounds
        self.delegate?.bindViewToViewModel(dispatchQueue: dispatchQueue)
    }
    
    func updateWinningScore(to winningScore: Int) {
        self.game.endingScore = winningScore
        self.delegate?.bindViewToViewModel(dispatchQueue: dispatchQueue)
    }
    
    func setNoEnd() {
        self.game.gameEndType = .none
        self.delegate?.bindViewToViewModel(dispatchQueue: dispatchQueue)
    }
}
