//
//
//  GameSetupViewModel.swift
//  What's The Score
//
//  Created by Curt McCune on 12/30/23.
//

import Foundation

struct GameSetupViewModel {
    
    #warning("Need to reconfigure this, breaking down from game into the individual options. Probably using Observable.")
    
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
