//
//  EndGameViewModel.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/8/24.
//

import Foundation

protocol EndGameViewModelProtocol {
    var game: GameProtocol { get set }
    var losingPlayers: [Player] { get set }
}

class EndGameViewModel: EndGameViewModelProtocol {
    init(game: GameProtocol) {
        self.game = game
    }
    
    var game: GameProtocol
    var losingPlayers: [Player] = []
}
