//
//  PlayerSetupViewModel.swift
//  What's The Score
//
//  Created by Curt McCune on 1/3/24.
//

import Foundation

class PlayerSetupViewModel: PlayerSetupViewModelProtocol {
    
    var players: [PlayerProtocol] = []
    weak var coordinator: GameSetupCoordinator?
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
        
        
        let player = players.remove(at: sourceRowIndex)
        players.insert(player, at: destinationRowIndex)
        delegate?.bindViewToViewModel()
    }
    
    func addPlayer() {
        players.append(Player(name: "", position: 0))
        delegate?.bindViewToViewModel()
    }
    
    func randomizePlayers() {
        players.shuffle()
        delegate?.bindViewToViewModel()
    }
    
    func deletePlayerAt(_ index: Int) {
        guard players.indices.contains(index) else { return }
        players.remove(at: index)
        delegate?.bindViewToViewModel()
    }
    
    func playersSetup() {
        coordinator?.playersSetup(players)
    }
}

protocol PlayerSetupViewModelViewProtocol: NSObject {
    func bindViewToViewModel()
    func reloadTableViewCell(index: Int)
}

protocol PlayerSetupViewModelProtocol {
    var coordinator: GameSetupCoordinator? { get set }
    var delegate: PlayerSetupViewModelViewProtocol? {get set}
    var players: [PlayerProtocol] { get set }
    
    func playerNameChanged(withIndex index: Int, toName name: String)
    func movePlayerAt(_ sourceRowIndex: Int, to destinationRowIndex: Int)
    func addPlayer()
    func randomizePlayers()
    func deletePlayerAt(_ index: Int)
    func playersSetup()
}
