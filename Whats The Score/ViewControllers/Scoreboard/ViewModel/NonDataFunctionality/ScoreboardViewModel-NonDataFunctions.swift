//
//  ScoreboardViewModel-NonDataFunctions.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/9/24.
//

import Foundation

extension ScoreboardViewModel {
    
    func addPlayer() {
        let playerToAdd = PlayerSettings(name: "", icon: getRandomIcon())
        coordinator?.showEditPlayerPopover(withPlayer: playerToAdd, andDelegate: self)
        coreDataStore.saveContext()
        delegate?.bindViewToViewModel(dispatchQueue: DispatchQueue.main)
    }
    
    private func getRandomIcon() -> PlayerIcon {
        let filteredIcons = PlayerIcon.allCases.filter { icon in
            !game.players.contains { player in
                player.icon == icon
            }
        }
        
        if let filteredRandomIcon = filteredIcons.randomElement() {
            return filteredRandomIcon
        } else if let randomIcon = PlayerIcon.allCases.randomElement() {
            return randomIcon
        } else {
            fatalError("No Icons")
        }
    }
    
    func startEditingPlayerScoreAt(_ index: Int) {
        guard sortedPlayers.indices.contains(index) else { return }
        
        let player = sortedPlayers[index]
        coordinator?.showEditPlayerScorePopover(withScoreChange: ScoreChangeSettings(player: player), andDelegate: self)
    }
    
    func startEditingPlayerAt(_ index: Int) {
        guard sortedPlayers.indices.contains(index) else { return }
        let player = sortedPlayers[index]
        let playerSettings = PlayerSettings(name: player.name, icon: player.icon, id: player.id)
        coordinator?.showEditPlayerPopover(withPlayer: playerSettings, andDelegate: self)
        
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
        
        var scoreChangeSettingsArray = [ScoreChangeSettings]()
        for player in game.players {
            scoreChangeSettingsArray.append(ScoreChangeSettings(player: player))
        }
        let endRoundSettings = EndRoundSettings(scoreChangeSettingsArray: scoreChangeSettingsArray, roundNumber: game.currentRound)
        
        coordinator?.showEndRoundPopover(withEndRound: endRoundSettings, andDelegate: self)
        
        //        coordinator?.showEndRoundPopover(withGame: game, andDelegate: self)
    }
    
    func endGame() {
        coordinator?.showEndGamePopover(withGame: game, andDelegate: self)
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
