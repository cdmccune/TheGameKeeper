//
//  GameHistoryViewModel.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/11/24.
//

import Foundation

protocol GameHistoryViewModelProtocol: ScoreboardPlayerEditScorePopoverDelegate {
    var game: GameProtocol { get set }
    
    var scoreChangeToEdit: Observable<ScoreChange> { get }
    var shouldShowEndRoundPopover: Observable<Bool> { get }
    
    func didSelectRow(_ row: Int)
}

class GameHistoryViewModel: GameHistoryViewModelProtocol, ScoreboardPlayerEditScorePopoverDelegate {
    init(game: GameProtocol) {
        self.game = game
    }
    
    var game: GameProtocol
    var scoreChangeToEdit: Observable<ScoreChange> = Observable(nil)
    var shouldShowEndRoundPopover: Observable<Bool> = Observable(nil)
    
    
    func didSelectRow(_ row: Int) {
        guard game.historySegments.indices.contains(row) else { return }
        
        switch game.historySegments[row] {
        case .scoreChange(let scoreChange):
            scoreChangeToEdit.value = scoreChange
        case .endRound(_, _):
            shouldShowEndRoundPopover.value = true
        }
    }
    
    func editScore(_ scoreChange: ScoreChange) {
        
    }
}
