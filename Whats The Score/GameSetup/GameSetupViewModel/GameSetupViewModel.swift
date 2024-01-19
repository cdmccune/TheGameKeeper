//
//
//  GameSetupViewModel.swift
//  What's The Score
//
//  Created by Curt McCune on 12/30/23.
//

import Foundation

struct GameSetupViewModel {
    var game: Game {
        didSet {
            delegate?.bindViewToGame(with: game)
        }
    }
    
    weak var delegate: GameSetupViewModelProtocol? {
        didSet {
            delegate?.bindViewToGame(with: game)
        }
    }
    
}

protocol GameSetupViewModelProtocol: NSObject {
    func bindViewToGame(with game: Game)
}
