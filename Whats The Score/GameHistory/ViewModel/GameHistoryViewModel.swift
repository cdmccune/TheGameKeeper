//
//  GameHistoryViewModel.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/11/24.
//

import Foundation



protocol GameHistoryViewModelProtocol: ScoreboardPlayerEditScorePopoverDelegate, EndRoundPopoverDelegateProtocol {
    var game: GameProtocol { get set }
    
    var scoreChangeToEdit: Observable<ScoreChangeProtocol> { get }
    var endRoundToEdit: Observable<EndRoundProtocol> { get }
    var shouldRefreshTableView: Observable<Bool> { get }
    var shouldShowDeleteSegmentWarningIndex: Observable<Int> { get }
    
    func didSelectRow(_ row: Int)
    func startDeletingRowAt(_ row: Int)
    func deleteRowAt(_ index: Int)
}

class GameHistoryViewModel: GameHistoryViewModelProtocol, ScoreboardPlayerEditScorePopoverDelegate, EndRoundPopoverDelegateProtocol {
    init(game: GameProtocol) {
        self.game = game
    }
    
    var game: GameProtocol
    var scoreChangeToEdit: Observable<ScoreChangeProtocol> = Observable(nil)
    var endRoundToEdit: Observable<EndRoundProtocol> = Observable(nil)
    var shouldRefreshTableView: Observable<Bool> = Observable(false)
    var shouldShowDeleteSegmentWarningIndex: Observable<Int> = Observable(nil)
    
    
    func didSelectRow(_ row: Int) {
        
        guard game.gameType == .basic ? game.scoreChanges.indices.contains(row) : game.endRounds.indices.contains(row) else { return }
        
        switch game.gameType {
        case .basic:
            scoreChangeToEdit.value = game.scoreChanges[row]
        case .round:
            endRoundToEdit.value = game.endRounds[row]
        }
    }
    
    func startDeletingRowAt(_ row: Int) {
        guard game.gameType == .basic ? game.scoreChanges.indices.contains(row) : game.endRounds.indices.contains(row) else { return }
        
        shouldShowDeleteSegmentWarningIndex.value = row
    }
    
    func deleteRowAt(_ index: Int) {
        game.deleteHistorySegmentAt(index: index)
        shouldRefreshTableView.value = true
    }
    
    func editScore(_ scoreChange: ScoreChangeProtocol) {
        game.editScoreChange(scoreChange)
        
        shouldRefreshTableView.value = true
    }
    
    func endRound(_ endRound: EndRoundProtocol) {
        game.editEndRound(endRound)
        
        shouldRefreshTableView.value = true
    }
}
