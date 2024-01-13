//
//
//  GameSetupViewModel.swift
//  What's The Score
//
//  Created by Curt McCune on 12/30/23.
//

import Foundation

struct GameSetupViewModel {
    var gameSettings: GameSettings {
        didSet {
            delegate?.bindViewToGameSettings(with: gameSettings)
        }
    }
    
    weak var delegate: GameSetupViewModelProtocol? {
        didSet {
            delegate?.bindViewToGameSettings(with: gameSettings)
        }
    }
    
}

protocol GameSetupViewModelProtocol: NSObject {
    func bindViewToGameSettings(with gameSettings: GameSettings)
}
