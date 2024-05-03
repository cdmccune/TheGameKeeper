//
//  GameHistoryViewModel.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/11/24.
//

import Foundation


protocol GameHistoryViewModelProtocol: ScoreboardPlayerEditScorePopoverDelegate, EndRoundPopoverDelegateProtocol {
    var game: GameProtocol { get set }
    var coordinator: ScoreboardCoordinator? { get set }
    var coreDataStore: CoreDataStoreProtocol { get set }
    
    var shouldRefreshTableView: Observable<Bool> { get }
    var shouldShowDeleteSegmentWarningIndex: Observable<Int> { get }
    
    func didSelectRow(_ row: Int)
    func startDeletingRowAt(_ row: Int)
    func deleteRowAt(_ index: Int)
}

class GameHistoryViewModel: GameHistoryViewModelProtocol, ScoreboardPlayerEditScorePopoverDelegate, EndRoundPopoverDelegateProtocol {
    init(game: GameProtocol, coreDataStore: CoreDataStoreProtocol = CoreDataStore()) {
        self.game = game
        self.coreDataStore = coreDataStore
    }
    
    var game: GameProtocol
    var coreDataStore: CoreDataStoreProtocol
    weak var coordinator: ScoreboardCoordinator?
    
    var shouldRefreshTableView: Observable<Bool> = Observable(false)
    var shouldShowDeleteSegmentWarningIndex: Observable<Int> = Observable(nil)
    
    
    func didSelectRow(_ row: Int) {
        
        guard game.gameType == .basic ? game.scoreChanges.indices.contains(row) : game.endRounds.indices.contains(row) else { return }
        
        switch game.gameType {
        case .basic:

            let scoreChange = game.scoreChanges[row]
            let scoreChangeSettings = ScoreChangeSettings(player: scoreChange.player, scoreChange: scoreChange.scoreChange, scoreChangeID: scoreChange.id)
            
            coordinator?.showEditPlayerScorePopover(withScoreChange: scoreChangeSettings, andDelegate: self)
            
        case .round:
            
            let endRound = game.endRounds[row]
            
            var scoreChangeSettings = [ScoreChangeSettings]()
            for scoreChange in endRound.scoreChanges {
                scoreChangeSettings.append(ScoreChangeSettings(player: scoreChange.player, scoreChange: scoreChange.scoreChange, scoreChangeID: scoreChange.id))
            }
            
            let endRoundSettings = EndRoundSettings(scoreChangeSettingsArray: scoreChangeSettings, roundNumber: endRound.roundNumber, endRoundID: endRound.id)
            coordinator?.showEndRoundPopover(withEndRound: endRoundSettings, andDelegate: self)
        }
    }
    
    func startDeletingRowAt(_ row: Int) {
        guard game.gameType == .basic ? game.scoreChanges.indices.contains(row) : game.endRounds.indices.contains(row) else { return }
        
        shouldShowDeleteSegmentWarningIndex.value = row
    }
    
    
    // MARK: - Data Altering Functions
    
    func deleteRowAt(_ index: Int) {
        guard game.gameType == .basic ? game.scoreChanges.indices.contains(index) : game.endRounds.indices.contains(index) else { return }
        
        switch game.gameType {
        case .basic:
            game.deleteScoreChange(game.scoreChanges[index])
        case .round:
            game.deleteEndRound(game.endRounds[index])
        }
        
        coreDataStore.saveContext()
        shouldRefreshTableView.value = true
    }
    
    func editScore(_ scoreChange: ScoreChangeSettings) {
        game.editScoreChange(scoreChange)
        coreDataStore.saveContext()
        
        shouldRefreshTableView.value = true
    }
    
    func endRound(_ endRound: EndRoundSettings) {
        game.editEndRound(endRound)
        coreDataStore.saveContext()
        
        shouldRefreshTableView.value = true
    }
}
