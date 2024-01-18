//
//  PlayerSetupViewModel.swift
//  What's The Score
//
//  Created by Curt McCune on 1/3/24.
//

import Foundation

class PlayerSetupViewModel: PlayerSetupViewModelProtocol {
    
    init(gameSettings: GameSettings) {
        self.gameSettings = gameSettings
        
        var players: [Player] = []
        for position in 0..<gameSettings.numberOfPlayers {
            players.append(Player(name: "",
                                  position: position))
        }
        
        self.players = players
    }
    
    var gameSettings: GameSettings
    var players: [Player]
    weak var delegate: PlayerSetupViewModelViewProtocol? {
        didSet {
            delegate?.bindViewToViewModel()
        }
    }
    
    
    // MARK: - Functions
    
    
    func playerNameChanged(withIndex index: Int, toName name: String) {
        guard players.indices.contains(index) else { return }
        
        players[index].name = name
        delegate?.reloadTableViewCell(index: index)
    }
    
    func movePlayerAt(_ sourceRowIndex: Int, to destinationRowIndex: Int) {
        guard players.indices.contains(sourceRowIndex),
              players.indices.contains(destinationRowIndex) else { return }
        
        let playerToMove = players[sourceRowIndex]
        players.remove(at: sourceRowIndex)
        players.insert(playerToMove, at: destinationRowIndex)
        players.setPositions()
        
        delegate?.bindViewToViewModel()
    }
    
    func addPlayer() {
        players.append(Player(name: "", position: players.indices.upperBound))
        delegate?.bindViewToViewModel()
    }
    
    func randomizePlayers() {
        players.shuffle()
        delegate?.bindViewToViewModel()
    }
    
    func deletePlayerAt(_ index: Int) {
        guard players.indices.contains(index) else {
            return
        }
        
        players.remove(at: index)
        players.setPositions()
        delegate?.bindViewToViewModel()
    }
}

protocol PlayerSetupViewModelViewProtocol: NSObject {
    func bindViewToViewModel()
    func reloadTableViewCell(index: Int)
}

protocol PlayerSetupViewModelProtocol {
    var players: [Player] {get set}
    var delegate: PlayerSetupViewModelViewProtocol? {get set}
    
    func playerNameChanged(withIndex index: Int, toName name: String)
    func movePlayerAt(_ sourceRowIndex: Int, to destinationRowIndex: Int)
    func addPlayer()
    func randomizePlayers()
    func deletePlayerAt(_ index: Int)
}
