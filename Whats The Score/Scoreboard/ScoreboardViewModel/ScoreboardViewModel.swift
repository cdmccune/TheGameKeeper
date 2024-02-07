//
//  ScoreboardViewModel.swift
//  Whats The Score
//
//  Created by Curt McCune on 1/19/24.
//

import Foundation

protocol ScoreboardViewModelProtocol: ScoreboardPlayerEditScorePopoverDelegate {
    var game: GameProtocol { get set }
    var delegate: ScoreboardViewModelViewProtocol? { get set }
    var playerToEditScore: Observable<Player> { get set }
    
    func startEditingPlayerScoreAt(_ index: Int)
    func editPlayerScoreAt(_ index: Int, byAdding: Int)
    func endCurrentRound()
    func endGame()
}

class ScoreboardViewModel: NSObject, ScoreboardViewModelProtocol {
    
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
    
    var playerToEditScore: Observable<Player> = Observable(Player(name: "", position: 0))
    
    
    // MARK: - Functions
    
    func startEditingPlayerScoreAt(_ index: Int) {
        guard game.players.indices.contains(index) else { return }
        
        let player = game.players[index]
        self.playerToEditScore.value = player
    }
    
    func editPlayerScoreAt(_ index: Int, byAdding change: Int) {
        guard game.players.indices.contains(index) else { return }
        
        game.players[index].score += change
        delegate?.bindViewToViewModel(dispatchQueue: DispatchQueue.main)
    }
    
    func endCurrentRound() {
    }
    
    func endGame() {
    }
    
    
}

extension ScoreboardViewModel: ScoreboardPlayerEditScorePopoverDelegate {
    func edit(player: Player, scoreBy change: Int) {
        guard let index = game.players.firstIndex(of: player) else { return }
        
//        game.players[index].score += change
        editPlayerScoreAt(index, byAdding: change)
    }
}

protocol ScoreboardViewModelViewProtocol: NSObject {
    func bindViewToViewModel(dispatchQueue: DispatchQueueProtocol)
}
