//
//  ScoreboardViewModelMock.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 4/9/24.
//

import Foundation
@testable import Whats_The_Score

class ScoreboardViewModelMock: NSObject, ScoreboardViewModelProtocol {
    
    init(game: GameProtocol) {
        self.game = game
    }
    
    override init() {
        self.game = GameMock()
    }
    
    var coreDataStore: CoreDataStoreProtocol = CoreDataStoreMock()
    var game: GameProtocol
    var delegate: ScoreboardViewModelViewProtocol?
    weak var coordinator: ScoreboardCoordinator?
    var playerToDelete: Observable<PlayerProtocol> = Observable(PlayerMock())
    var sortPreference: Observable<ScoreboardSortPreference> = Observable(.score)
    var sortedPlayers: [PlayerProtocol] = []
    
    var startEditingPlayerScoreAtCalledCount = 0
    var startEditingPlayerScoreAtIndex: Int?
    func startEditingPlayerScoreAt(_ index: Int) {
        startEditingPlayerScoreAtIndex = index
        startEditingPlayerScoreAtCalledCount += 1
    }
    
    var editScoreCalledCount = 0
    var editScorePlayerID: UUID?
    var editScorePlayerName: String?
    var editScoreChange: Int?
    func editScore(_ scoreChange: ScoreChangeSettings) {
        editScoreCalledCount += 1
        editScoreChange = scoreChange.scoreChange
    }
    
    var addPlayerCalledCount = 0
    func addPlayer() {
        addPlayerCalledCount += 1
    }
    
    var endGameCalledCount = 0
    func endGame() {
        endGameCalledCount += 1
    }
    
    var startEditingPlayerAtCalledCount = 0
    var startEditingPlayerAtIndex: Int?
    func startEditingPlayerAt(_ index: Int) {
        startEditingPlayerAtCalledCount += 1
        startEditingPlayerAtIndex = index
    }
    
    var startDeletingPlayerAtCalledCount = 0
    var startDeletingPlayerAtIndex: Int?
    func startDeletingPlayerAt(_ index: Int) {
        startDeletingPlayerAtCalledCount += 1
        startDeletingPlayerAtIndex = index
    }
    
    var deletePlayerPlayer: PlayerProtocol?
    var deletePlayerCalledCount = 0
    func deletePlayer(_ player: PlayerProtocol) {
        self.deletePlayerPlayer = player
        self.deletePlayerCalledCount += 1
    }
    
    var resetGameCalledCount = 0
    func resetGame() {
        resetGameCalledCount += 1
    }
    
    var openingGameOverCheckCalledCount = 0
    func openingGameOverCheck() {
        openingGameOverCheckCalledCount += 1
    }
    
    var showGameHistoryCalledCount = 0
    func showGameHistory() {
        showGameHistoryCalledCount += 1
    }
    
    var showGameSettingsCalledCount = 0
    func showGameSettings() {
        showGameSettingsCalledCount += 1
    }
    
    var showEndRoundPopoverCalledCount = 0
    func showEndRoundPopover() {
        showEndRoundPopoverCalledCount += 1
    }
    
    func finishedEditing(_ player: PlayerProtocol, toNewName name: String) {}
    func endRound(_ endRound: EndRoundSettings) {}
    func goToEndGameScreen() {}
    func keepPlayingSelected() {}
    func updateNumberOfRounds(to numberOfRounds: Int) {}
    func updateWinningScore(to winningScore: Int) {}
    func setNoEnd() {}
    func updateFromHistory() {}
    func updateGameSettings(gameEndType: GameEndType, numberOfRounds endingScore: Int, endingScore numberOfRounds: Int) {}
}
