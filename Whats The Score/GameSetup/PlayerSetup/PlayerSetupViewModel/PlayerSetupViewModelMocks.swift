//
//  PlayerSetupViewModelMock.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 4/18/24.
//

import Foundation
@testable import Whats_The_Score

class PlayerSetupViewModelMock: PlayerSetupViewModelProtocol {
    var players: [PlayerSettings] = []
    var delegate: PlayerSetupViewModelViewProtocol?
    weak var coordinator: GameSetupCoordinator?
    
    var randomizePlayersCalledCount = 0
    func randomizePlayers() {
        randomizePlayersCalledCount += 1
    }
    
    var addPlayerCalledCount = 0
    func addPlayer() {
        addPlayerCalledCount += 1
    }
    
    var playerNameChangedIndex: Int?
    var playerNameChangedName: String?
    func playerNameChanged(withIndex index: Int, toName name: String) {
        self.playerNameChangedIndex = index
        self.playerNameChangedName = name
    }
    
    var movePlayerAtSourceRow: Int?
    var movePlayerAtDestinationRow: Int?
    var movePlayerAtCalledCount: Int = 0
    func movePlayerAt(_ sourceRowIndex: Int, to destinationRowIndex: Int) {
        self.movePlayerAtSourceRow = sourceRowIndex
        self.movePlayerAtDestinationRow = destinationRowIndex
        self.movePlayerAtCalledCount += 1
    }
    
    var deletePlayerAtCalledCount = 0
    func deletePlayerAt(_ index: Int) {
        deletePlayerAtCalledCount += 1
    }
    
    var playersSetupCalledCount = 0
    func playersSetup() {
        playersSetupCalledCount += 1
    }
}

class PlayerSetupViewModelViewProtocolMock: NSObject, PlayerSetupViewModelViewProtocol {
    
    var bindViewToViewModelCallCount = 0
    func bindViewToViewModel() {
        bindViewToViewModelCallCount += 1
    }
    
    var reloadTableViewCellIndex: Int?
    var reloadTableViewCellCalledCount = 0
    func reloadTableViewCell(index: Int) {
        reloadTableViewCellIndex = index
        reloadTableViewCellCalledCount += 1
    }
}
