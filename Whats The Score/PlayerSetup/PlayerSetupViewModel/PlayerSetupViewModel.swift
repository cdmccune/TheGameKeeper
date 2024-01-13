//
//  PlayerSetupViewModel.swift
//  What's The Score
//
//  Created by Curt McCune on 1/3/24.
//

import Foundation
//#error("Next need to make the tableview reload only the correct cell when renaming players bc of keyboard glitch")
struct PlayerSetupViewModel: PlayerSetupPlayerCoordinator {
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
    weak var delegate: PlayerSetupViewModelProtocol? {
        didSet {
            delegate?.bindViewToViewModel()
        }
    }
    
    
    mutating func playerNameChanged(withIndex index: Int, toName name: String) {
        guard players.indices.contains(index) else { return }
        
        players[index].name = name
        delegate?.reloadTableViewCell(index: index)
    }
    
    mutating func movePlayerAt(_ sourceRowIndex: Int, to destinationRowIndex: Int) {
        guard players.indices.contains(sourceRowIndex),
              players.indices.contains(destinationRowIndex) else { return }
        
        var newPlayersArray = players
        newPlayersArray.swapAt(sourceRowIndex, destinationRowIndex)
        
        for position in newPlayersArray.indices {
            newPlayersArray[position].position = position
        }
        
        players = newPlayersArray
        delegate?.bindViewToViewModel()
    }
}

protocol PlayerSetupViewModelProtocol: NSObject {
    func bindViewToViewModel()
    func reloadTableViewCell(index: Int)
}

protocol PlayerSetupPlayerCoordinator {
    var players: [Player] {get set}
    mutating func playerNameChanged(withIndex index: Int, toName name: String)
    mutating func movePlayerAt(_ sourceRowIndex: Int, to destinationRowIndex: Int)
}

