//
//  ScoreboardViewModel-NonDataFunctions.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/9/24.
//

import Foundation

extension ScoreboardViewModel {
    
    func startEditingPlayerScoreAt(_ index: Int) {
        guard sortedPlayers.indices.contains(index) else { return }
        
        let player = sortedPlayers[index]
        coordinator?.showEditPlayerScorePopover(withScoreChange: ScoreChangeSettings(player: player), andDelegate: self)
    }
    
    func startEditingPlayerAt(_ index: Int) {
        guard sortedPlayers.indices.contains(index) else { return }
        
        coordinator?.showEditPlayerPopover(withPlayer: sortedPlayers[index], andDelegate: self)
        
    }
    
    func startDeletingPlayerAt(_ index: Int) {
        guard sortedPlayers.indices.contains(index) else { return }
        
        let player = sortedPlayers[index]
        self.playerToDelete.value = player
    }
    
    func openingGameOverCheck() {
        if game.isEndOfGame() {
            coordinator?.showKeepPlayingPopover(withGame: game, andDelegate: self, delay: 0.5)
        }
    }
    
    func showGameHistory() {
        coordinator?.showGameHistory(withGame: game, andDelegate: self)
    }
    
    func showGameSettings() {
        coordinator?.showSettings(withGame: game, andDelegate: self)
    }
    
    func showEndRoundPopover() {
        coordinator?.showEndRoundPopover(withGame: game, andDelegate: self)
    }
    
}

extension ScoreboardViewModel: EndGamePopoverDelegate {
    func goToEndGameScreen() {
        coordinator?.showEndGameScreen(withGame: game, delay: 0.5)
    }
    
    func keepPlayingSelected() {
        guard game.isEndOfGame() else { return }
        coordinator?.showKeepPlayingPopover(withGame: game, andDelegate: self, delay: 0.5)
    }
}


extension ScoreboardViewModel: GameHistoryViewControllerDelegate {
    func updateFromHistory() {
        self.delegate?.bindViewToViewModel(dispatchQueue: dispatchQueue)
        if game.isEndOfGame() {
            coordinator?.showEndGamePopover(withGame: game, andDelegate: self, delay: 0.5)
        }
    }
}
