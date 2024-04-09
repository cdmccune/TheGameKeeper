//
//  ScoreboardViewModel.swift
//  Whats The Score
//
//  Created by Curt McCune on 1/19/24.
//

import Foundation

protocol ScoreboardViewModelProtocol: ScoreboardPlayerEditScorePopoverDelegate, EditPlayerPopoverDelegateProtocol, EndRoundPopoverDelegateProtocol, EndGamePopoverDelegate, KeepPlayingPopoverDelegate, GameHistoryViewControllerDelegate, GameSettingsDelegate {
    var game: GameProtocol { get set }
    var delegate: ScoreboardViewModelViewProtocol? { get set }
    var coordinator: ScoreboardCoordinator? { get set }
    var playerToDelete: Observable<PlayerProtocol> { get set }
    var sortPreference: Observable<ScoreboardSortPreference> { get set }
    var sortedPlayers: [PlayerProtocol] { get }
    
    func startEditingPlayerAt(_ index: Int)
    func startEditingPlayerScoreAt(_ index: Int)
    func startDeletingPlayerAt(_ index: Int)
    func deletePlayer(_ player: PlayerProtocol)
    func addPlayer()
    func endGame()
    func resetGame()
    func openingGameOverCheck()
    func showGameHistory()
    func showGameSettings()
    func showEndRoundPopover()
}


class ScoreboardViewModel: NSObject, ScoreboardViewModelProtocol, EndRoundPopoverDelegateProtocol {
    
    // MARK: - Init
    
    init(game: GameProtocol) {
        self.game = game
    }
    
    
    // MARK: - Properties
    
    var game: GameProtocol
    weak var coordinator: ScoreboardCoordinator?
    weak var delegate: ScoreboardViewModelViewProtocol? {
        didSet {
            delegate?.bindViewToViewModel(dispatchQueue: DispatchQueue.main)
        }
    }
    
    
    // MARK: - Observables
    
    var sortPreference: Observable<ScoreboardSortPreference> = Observable(.score)
    var playerToDelete: Observable<PlayerProtocol> = Observable(nil)
    var shouldGoToEndGameScreen: Observable<Bool> = Observable(false)
    
    var sortedPlayers: [PlayerProtocol] {
        return game.players.sorted {player1, player2 in
            switch sortPreference.value ?? .score {
            case .score:
                return player1.score > player2.score
            case .position:
                return player1.position < player2.position
            }
        }
    }
    
    var dispatchQueue: DispatchQueueProtocol = DispatchQueue.main
    
    
    // MARK: - Functions
    
    func startEditingPlayerScoreAt(_ index: Int) {
        guard sortedPlayers.indices.contains(index) else { return }
        
        let player = sortedPlayers[index]
        coordinator?.showEditPlayerScorePopover(withScoreChange: ScoreChangeSettings(player: player), andDelegate: self)
    }
    
    func startEditingPlayerAt(_ index: Int) {
        guard sortedPlayers.indices.contains(index) else { return }
        
        coordinator?.showEditPlayerPopover(withPlayer: sortedPlayers[index], andDelegate: self)
        
    }
    
    func editScore(_ scoreChange: ScoreChangeSettings) {
        guard game.players.contains(where: { $0.id == scoreChange.player.id }) else { return }
    
        game.changeScore(with: scoreChange)
        delegate?.bindViewToViewModel(dispatchQueue: DispatchQueue.main)
        
        if game.isEndOfGame() {
            coordinator?.showEndGamePopover(withGame: game, andDelegate: self, delay: 1.0)
        }
    }
    
    func startDeletingPlayerAt(_ index: Int) {
        guard sortedPlayers.indices.contains(index) else { return }
        
        let player = sortedPlayers[index]
        self.playerToDelete.value = player
    }
    
    func deletePlayer(_ player: PlayerProtocol) {
        game.deletePlayer(player)
        delegate?.bindViewToViewModel(dispatchQueue: DispatchQueue.main)
    }

    func addPlayer() {
        game.addPlayer(withName: "")
        delegate?.bindViewToViewModel(dispatchQueue: DispatchQueue.main)
    }
    
    func endRound(_ endRound: EndRoundSettings) {
        game.endRound(with: endRound)
        
        delegate?.bindViewToViewModel(dispatchQueue: DispatchQueue.main)
        
        if game.isEndOfGame() {
            coordinator?.showEndGamePopover(withGame: game, andDelegate: self, delay: 1.0)
        }
    }
    
    func endGame() {
        coordinator?.showEndGamePopover(withGame: game, andDelegate: self)
    }
    
    func resetGame() {
        game.resetGame()
        delegate?.bindViewToViewModel(dispatchQueue: DispatchQueue.main)
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


extension ScoreboardViewModel: EditPlayerPopoverDelegateProtocol {
    func finishedEditing(_ player: PlayerProtocol, toNewName name: String) {
        game.changeName(of: player, to: name)
        delegate?.bindViewToViewModel(dispatchQueue: DispatchQueue.main)
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

extension ScoreboardViewModel: GameSettingsDelegate {
    func updateGameSettings(gameEndType: GameEndType, numberOfRounds: Int, endingScore: Int) {
        game.updateSettings(with: gameEndType, endingScore: endingScore, andNumberOfRounds: numberOfRounds)
        self.delegate?.bindViewToViewModel(dispatchQueue: dispatchQueue)
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

protocol ScoreboardViewModelViewProtocol: NSObject {
    func bindViewToViewModel(dispatchQueue: DispatchQueueProtocol)
}
