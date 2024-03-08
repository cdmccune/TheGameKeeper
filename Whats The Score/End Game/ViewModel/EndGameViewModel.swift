//
//  EndGameViewModel.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/8/24.
//

import Foundation

protocol EndGameViewModelProtocol {
    var game: GameProtocol { get set }
    var losingPlayers: [Player] { get }
}

class EndGameViewModel: EndGameViewModelProtocol {
    init(game: GameProtocol) {
        self.game = game
    }
    
    var game: GameProtocol
    var losingPlayers: [Player] {
        var losingPlayers = game.players
        game.winningPlayers.forEach {
            if let index = losingPlayers.firstIndex(of: $0) {
                losingPlayers.remove(at: index)
            }
        }
        losingPlayers.sort { $0.score > $1.score }
        
        return losingPlayers
    }
}
