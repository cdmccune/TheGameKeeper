//
//  PlayerSetupViewModel.swift
//  What's The Score
//
//  Created by Curt McCune on 1/3/24.
//

import Foundation

struct PlayerSetupViewModel {
    var gameSettings: GameSettings {
        didSet {
            
        }
    }
    var players: [Player] = []
    weak var delegate: PlayerSetupViewModelProtocol?
    
//    private func getPlayersFromGameSettings() -> [Player] {
//        
//    }
}

protocol PlayerSetupViewModelProtocol: NSObject {
//    func bindViewToGameSettings(with gameSettings: GameSettings)
}
