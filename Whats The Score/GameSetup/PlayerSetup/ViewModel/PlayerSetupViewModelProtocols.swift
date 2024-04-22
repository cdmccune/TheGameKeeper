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
    
    func movePlayerAt(_ sourceRowIndex: Int, to destinationRowIndex: Int)
    func addPlayer()
    func editPlayerAt(row: Int)
    func randomizePlayers()
    func deletePlayerAt(_ index: Int)
    func playersSetup()
}

protocol PlayerSetupViewModelViewProtocol: NSObject {
    func bindViewToViewModel(dispatchQueue: DispatchQueueProtocol)
    func reloadTableViewCell(index: Int)
}
