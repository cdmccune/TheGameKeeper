//
//  PlayerSetupViewModel.swift
//  What's The Score
//
//  Created by Curt McCune on 1/3/24.
//

import Foundation

class PlayerSetupViewModel: PlayerSetupViewModelProtocol {
    
    init(game: GameProtocol) {
        self.game = game
    }
    
    var game: GameProtocol
    weak var delegate: PlayerSetupViewModelViewProtocol? {
        didSet {
            delegate?.bindViewToViewModel()
        }
    }
    
    
    // MARK: - Functions
    
    func playerNameChanged(withIndex index: Int, toName name: String) {
        game.playerNameChanged(withIndex: index, toName: name)
        delegate?.reloadTableViewCell(index: index)
    }
    
    func movePlayerAt(_ sourceRowIndex: Int, to destinationRowIndex: Int) {
        game.movePlayerAt(sourceRowIndex, to: destinationRowIndex)
        delegate?.bindViewToViewModel()
    }
    
    func addPlayer() {
        game.addPlayer()
        delegate?.bindViewToViewModel()
    }
    
    func randomizePlayers() {
        game.randomizePlayers()
        delegate?.bindViewToViewModel()
    }
    
    func deletePlayerAt(_ index: Int) {
        game.deletePlayerAt(index)
        delegate?.bindViewToViewModel()
    }
}

protocol PlayerSetupViewModelViewProtocol: NSObject {
    func bindViewToViewModel()
    func reloadTableViewCell(index: Int)
}

protocol PlayerSetupViewModelProtocol {
    var game: GameProtocol {get set}
    var delegate: PlayerSetupViewModelViewProtocol? {get set}
    
    func playerNameChanged(withIndex index: Int, toName name: String)
    func movePlayerAt(_ sourceRowIndex: Int, to destinationRowIndex: Int)
    func addPlayer()
    func randomizePlayers()
    func deletePlayerAt(_ index: Int)
}
