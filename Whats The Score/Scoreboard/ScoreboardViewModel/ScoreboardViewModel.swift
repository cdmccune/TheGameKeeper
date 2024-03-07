//
//  ScoreboardViewModel.swift
//  Whats The Score
//
//  Created by Curt McCune on 1/19/24.
//

import Foundation

protocol ScoreboardViewModelProtocol: ScoreboardPlayerEditScorePopoverDelegate, EditPlayerPopoverDelegateProtocol, EndRoundPopoverDelegateProtocol, EndGamePopoverDelegate, KeepPlayingPopoverDelegate {
    var game: GameProtocol { get set }
    var delegate: ScoreboardViewModelViewProtocol? { get set }
    var playerToEditScore: Observable<Player> { get set }
    var playerToEdit: Observable<Player> { get set }
    var playerToDelete: Observable<Player> { get set }
    var sortPreference: Observable<ScoreboardSortPreference> { get set }
    var shouldShowEndGamePopup: Observable<Bool> { get set }
    var shouldGoToEndGameScreen: Observable<Bool> { get set }
    var shouldShowKeepPlayingPopup: Observable<Bool> { get set }
    var sortedPlayers: [Player] { get }
    
    func startEditingPlayerAt(_ index: Int)
    func startEditingPlayerScoreAt(_ index: Int)
    func editPlayerScoreAt(_ index: Int, byAdding: Int)
    func startDeletingPlayerAt(_ index: Int)
    func deletePlayer(_ player: Player)
    func addPlayer()
    func endGame()
    func resetGame()
}

class ScoreboardViewModel: NSObject, ScoreboardViewModelProtocol, EndRoundPopoverDelegateProtocol {
    
    // MARK: - Init
    
    init(game: GameProtocol) {
        self.game = game
    }
    
    
    // MARK: - Properties
    
    var game: GameProtocol
    weak var delegate: ScoreboardViewModelViewProtocol? {
        didSet {
            delegate?.bindViewToViewModel(dispatchQueue: DispatchQueue.main)
        }
    }
    
    
    // MARK: - Observables
    
    var playerToEditScore: Observable<Player> = Observable(nil)
    var playerToEdit: Observable<Player> = Observable(nil)
    var playerToDelete: Observable<Player> = Observable(nil)
    var sortPreference: Observable<ScoreboardSortPreference> = Observable(.score)
    var shouldShowEndGamePopup: Observable<Bool> = Observable(false)
    var shouldGoToEndGameScreen: Observable<Bool> = Observable(false)
    var shouldShowKeepPlayingPopup: Observable<Bool> = Observable(false)
    
    var sortedPlayers: [Player] {
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
        self.playerToEditScore.value = player
    }
    
    func startEditingPlayerAt(_ index: Int) {
        guard sortedPlayers.indices.contains(index) else { return }
        
        let player = sortedPlayers[index]
        self.playerToEdit.value = player
    }
    
    func editPlayerScoreAt(_ index: Int, byAdding change: Int) {
        guard game.players.indices.contains(index) else { return }
        
        game.players[index].score += change
        delegate?.bindViewToViewModel(dispatchQueue: DispatchQueue.main)
        
        if game.isEndOfGame() {
            dispatchQueue.asyncAfter(deadline: .now() + 1.0) {
                self.shouldShowEndGamePopup.value = true
            }
        }
    }
    
    func startDeletingPlayerAt(_ index: Int) {
        guard sortedPlayers.indices.contains(index) else { return }
        
        let player = sortedPlayers[index]
        self.playerToDelete.value = player
    }
    
    func deletePlayer(_ player: Player) {
        game.deletePlayerAt(player.position)
        delegate?.bindViewToViewModel(dispatchQueue: DispatchQueue.main)
    }

    func addPlayer() {
        game.addPlayer()
        delegate?.bindViewToViewModel(dispatchQueue: DispatchQueue.main)
    }
    
    func endRound(withChanges changeDictionary: [Player: Int]) {
        changeDictionary.forEach { (player, scoreChange) in
            if let index = game.players.firstIndex(of: player) {
                game.players[index].score += scoreChange
            }
        }
        game.currentRound += 1
        delegate?.bindViewToViewModel(dispatchQueue: DispatchQueue.main)
        
        if game.isEndOfGame() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.endGame()
            }
        }
    }
    
    func endGame() {
        self.shouldShowEndGamePopup.value = true
    }
    
    func resetGame() {
        game.players.indices.forEach { game.players[$0].score = 0 }
        game.currentRound = 1
        delegate?.bindViewToViewModel(dispatchQueue: DispatchQueue.main)
    }
}

extension ScoreboardViewModel: ScoreboardPlayerEditScorePopoverDelegate {
    func editScore(for player: Player, by change: Int) {
        guard let index = game.players.firstIndex(of: player) else { return }
        
        editPlayerScoreAt(index, byAdding: change)
    }
}

extension ScoreboardViewModel: EditPlayerPopoverDelegateProtocol {
    func finishedEditing(_ player: Player) {
        guard let index = game.players.firstIndex(of: player) else { return }
        game.players[index] = player
        delegate?.bindViewToViewModel(dispatchQueue: DispatchQueue.main)
    }
}

extension ScoreboardViewModel: EndGamePopoverDelegate {
    func goToEndGameScreen() {
        dispatchQueue.asyncAfter(deadline: .now() + 0.5) {
            self.shouldGoToEndGameScreen.value = true
        }
    }
    
    func keepPlayingSelected() {
        guard game.isEndOfGame() else { return }
        dispatchQueue.asyncAfter(deadline: .now() + 0.5) {
            self.shouldShowKeepPlayingPopup.value = true
        }
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

protocol ScoreboardViewModelViewProtocol: NSObject {
    func bindViewToViewModel(dispatchQueue: DispatchQueueProtocol)
}
