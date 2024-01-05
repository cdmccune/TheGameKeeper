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
            players.append(Player())
        }
        
        self.players = players
    }
    
    var gameSettings: GameSettings
    var players: [Player]
    weak var delegate: PlayerSetupViewModelProtocol?
    
    #error("Working on binding the view when players change")
}

protocol PlayerSetupViewModelProtocol: NSObject {
//    func bindViewToGameSettings(with gameSettings: GameSettings)
}

