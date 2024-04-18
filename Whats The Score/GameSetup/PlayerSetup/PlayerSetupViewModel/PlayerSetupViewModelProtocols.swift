//
//  PlayerSetupViewModelProtocol.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/18/24.
//

import Foundation

protocol PlayerSetupViewModelProtocol {
    var coordinator: GameSetupCoordinator? { get set }
    var delegate: PlayerSetupViewModelViewProtocol? {get set}
    var players: [PlayerSettings] { get set }
    
    func playerNameChanged(withIndex index: Int, toName name: String)
    func movePlayerAt(_ sourceRowIndex: Int, to destinationRowIndex: Int)
    func addPlayer()
    func randomizePlayers()
    func deletePlayerAt(_ index: Int)
    func playersSetup()
}

protocol PlayerSetupViewModelViewProtocol: NSObject {
    func bindViewToViewModel()
    func reloadTableViewCell(index: Int)
}
