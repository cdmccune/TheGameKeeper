//
//  PlayerSetupViewModel.swift
//  What's The Score
//
//  Created by Curt McCune on 1/3/24.
//

import Foundation

struct PlayerSetupViewModel {
    
    init(gameSettings: GameSettings) {
        self.gameSettings = gameSettings
        
        var players: [Player] = []
        for i in 0..<gameSettings.numberOfPlayers {
            players.append(Player(name: "Player \(i+1)"))
        }
        
        self.players = players
    }
    
    var gameSettings: GameSettings
    var players: [Player] {
        didSet {
            delegate?.bindViewToViewModel()
        }
    }
    weak var delegate: PlayerSetupViewModelProtocol?
}

protocol PlayerSetupViewModelProtocol: NSObject {
    func bindViewToViewModel()
}
