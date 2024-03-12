//
//  GameHistoryViewModel.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/11/24.
//

import Foundation

protocol GameHistoryViewModelProtocol {
    var game: GameProtocol { get set }
}

class GameHistoryViewModel: GameHistoryViewModelProtocol {
    init(game: GameProtocol) {
        self.game = game
    }
    
    var game: GameProtocol
}
