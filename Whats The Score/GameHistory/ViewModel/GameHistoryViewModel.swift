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
    var tableViewIndexToRefresh: Observable<Int> { get }
    
    func didSelectRow(_ row: Int)
}

class GameHistoryViewModel: GameHistoryViewModelProtocol, ScoreboardPlayerEditScorePopoverDelegate, EndRoundPopoverDelegateProtocol {
    init(game: GameProtocol) {
        self.game = game
    }
    
    var game: GameProtocol
    var scoreChangeToEdit: Observable<ScoreChange> = Observable(nil)
    var endRoundToEdit: Observable<EndRound> = Observable(nil)
    var tableViewIndexToRefresh: Observable<Int> = Observable(nil)
    
    
    func didSelectRow(_ row: Int) {
        guard game.historySegments.indices.contains(row) else { return }
        
        switch game.historySegments[row] {
        case .scoreChange(let scoreChange, _):
            scoreChangeToEdit.value = scoreChange
        case .endRound(let endRound, _):
            endRoundToEdit.value = endRound
        }
    }
    
    func editScore(_ scoreChange: ScoreChange) {
        game.editScoreChange(scoreChange)
        
        if let index = game.historySegments.firstIndex(of: GameHistorySegment.scoreChange(scoreChange, 0)) {
            self.tableViewIndexToRefresh.value = index
        }
    }
    
    func endRound(_ endRound: EndRound) {
        game.editEndRound(endRound)
        
        if let index = game.historySegments.firstIndex(of: GameHistorySegment.endRound(endRound, [])) {
            self.tableViewIndexToRefresh.value = index
        }
    }
}
