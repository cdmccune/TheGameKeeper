//
//  ScoreboardViewModel.swift
//  Whats The Score
//
//  Created by Curt McCune on 1/19/24.
//

import Foundation

protocol ScoreboardViewModelProtocol {
    var game: GameProtocol { get }
    var delegate: ScoreboardViewModelViewProtocol? { get set }
    
    func endCurrentRound()
    func endGame()
}

class ScoreboardViewModel: ScoreboardViewModelProtocol {
    init(game: GameProtocol) {
        self.game = game
    }
    
    var game: GameProtocol
    weak var delegate: ScoreboardViewModelViewProtocol?
    
    func endCurrentRound() {
    }
    
    func endGame() {
    }
    
}

protocol ScoreboardViewModelViewProtocol: NSObject {
    func bindViewToViewModel()
}
