//
//  GameHistoryViewModel.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/11/24.
//

import Foundation

protocol GameHistoryViewModelProtocol: ScoreboardPlayerEditScorePopoverDelegate, EndRoundPopoverDelegateProtocol {
    var game: GameProtocol { get set }
    
    var scoreChangeToEdit: Observable<ScoreChange> { get }
    var endRoundToEdit: Observable<EndRound> { get }
    var shouldRefreshTableView: Observable<Bool> { get }
    var shouldShowDeleteSegmentWarningIndex: Observable<Int> { get }
    
    func didSelectRow(_ row: Int)
    func startDeletingHistorySegmentAt(_ row: Int)
    func deleteHistorySegmentAt(_ index: Int)
}

class GameHistoryViewModel: GameHistoryViewModelProtocol, ScoreboardPlayerEditScorePopoverDelegate, EndRoundPopoverDelegateProtocol {
    init(game: GameProtocol) {
        self.game = game
    }
    
    var game: GameProtocol
    var scoreChangeToEdit: Observable<ScoreChange> = Observable(nil)
    var endRoundToEdit: Observable<EndRound> = Observable(nil)
    var shouldRefreshTableView: Observable<Bool> = Observable(false)
    var shouldShowDeleteSegmentWarningIndex: Observable<Int> = Observable(nil)
    
    
    func didSelectRow(_ row: Int) {
//        guard game.historySegments.indices.contains(row) else { return }
//        
//        switch game.historySegments[row] {
//        case .scoreChange(let scoreChange, _):
//            scoreChangeToEdit.value = scoreChange
//        case .endRound(let endRound, _):
//            endRoundToEdit.value = endRound
//        }
    }
    
    func startDeletingHistorySegmentAt(_ row: Int) {
//        guard game.historySegments.indices.contains(row) else { return }
        
        shouldShowDeleteSegmentWarningIndex.value = row
    }
    
    func deleteHistorySegmentAt(_ index: Int) {
//        game.deleteHistorySegmentAt(index: index)
        shouldRefreshTableView.value = true
    }
    
    func editScore(_ scoreChange: ScoreChange) {
//        game.editScoreChange(scoreChange)
        
        shouldRefreshTableView.value = true
    }
    
    func endRound(_ endRound: EndRound) {
//        game.editEndRound(endRound)
        
        shouldRefreshTableView.value = true
    }
}
