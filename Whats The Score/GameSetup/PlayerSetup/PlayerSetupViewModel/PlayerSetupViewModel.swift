//
//  PlayerSetupViewModel.swift
//  What's The Score
//
//  Created by Curt McCune on 1/3/24.
//

import Foundation

class PlayerSetupViewModel: PlayerSetupViewModelProtocol {
    
    var players: [PlayerSettings] = []
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
        coordinator?.showAddPlayerPopover(withPlayerSettings: PlayerSettings(name: "", icon: .alien), andDelegate: self)
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

extension PlayerSetupViewModel: EditPlayerPopoverDelegateProtocol {
    func finishedEditing(_ player: PlayerSettings) {
        players.append(player)
        delegate?.bindViewToViewModel()
    }
}
