//
//  PlayerSetupViewModel.swift
//  What's The Score
//
//  Created by Curt McCune on 1/3/24.
//

import Foundation

struct PlayerSetupViewModel: PlayerSetupPlayerCoordinator {
    
    init(gameSettings: GameSettings) {
        self.gameSettings = gameSettings
        
        var players: [Player] = []
        for i in 0..<gameSettings.numberOfPlayers {
            players.append(Player(name: "",
                                  position: i))
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
    
    
    mutating func playerNameChanged(withIndex index: Int, toName name: String) {
        guard players.indices.contains(index) else { return }
        
        players[index].name = name
    }
}

protocol PlayerSetupViewModelProtocol: NSObject {
    func bindViewToViewModel()
}

protocol PlayerSetupPlayerCoordinator {
    var players: [Player] {get set}
    mutating func playerNameChanged(withIndex index: Int, toName name: String)
}

