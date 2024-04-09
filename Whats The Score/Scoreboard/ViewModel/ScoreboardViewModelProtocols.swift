//
//  ScoreboardViewModelProtocols.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/9/24.
//

import Foundation

protocol ScoreboardViewModelProtocol: ScoreboardPlayerEditScorePopoverDelegate, EditPlayerPopoverDelegateProtocol, EndRoundPopoverDelegateProtocol, EndGamePopoverDelegate, KeepPlayingPopoverDelegate, GameHistoryViewControllerDelegate, GameSettingsDelegate {
    var coreDataStore: CoreDataStoreProtocol { get set }
    var game: GameProtocol { get set }
    var delegate: ScoreboardViewModelViewProtocol? { get set }
    var coordinator: ScoreboardCoordinator? { get set }
    var playerToDelete: Observable<PlayerProtocol> { get set }
    var sortPreference: Observable<ScoreboardSortPreference> { get set }
    var sortedPlayers: [PlayerProtocol] { get }
    
    func startEditingPlayerAt(_ index: Int)
    func startEditingPlayerScoreAt(_ index: Int)
    func startDeletingPlayerAt(_ index: Int)
    func openingGameOverCheck()
    func showGameHistory()
    func showGameSettings()
    func showEndRoundPopover()
    
    func deletePlayer(_ player: PlayerProtocol)
    func addPlayer()
    func endGame()
    func resetGame()
}

protocol ScoreboardViewModelViewProtocol: NSObject {
    func bindViewToViewModel(dispatchQueue: DispatchQueueProtocol)
}
