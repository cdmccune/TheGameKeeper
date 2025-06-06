//
//  EndGameViewModel.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/8/24.
//

import Foundation

protocol EndGameViewModelProtocol {
    var game: GameProtocol { get set }
    var losingPlayers: [PlayerProtocol] { get }
}

class EndGameViewModel: EndGameViewModelProtocol {
    init(game: GameProtocol) {
        self.game = game
    }
    
    var game: GameProtocol
    var losingPlayers: [PlayerProtocol] {
        var losingPlayers = game.players
        game.winningPlayers.forEach { winningPlayer in
            if let index = losingPlayers.firstIndex(where: { $0.id == winningPlayer.id }) {
                losingPlayers.remove(at: index)
            }
        }
        losingPlayers = losingPlayers.sorted(isLowestWinning: game.lowestIsWinning)
        
        return losingPlayers
    }
}
