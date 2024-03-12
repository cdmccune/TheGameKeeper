//
//  GameHistoryEndRoundTableViewCellViewModel.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/12/24.
//

import Foundation

protocol GameHistoryEndRoundTableViewCellViewModelProtocol {
    var scoreChanges: [ScoreChange] { get set }
}

class GameHistoryEndRoundTableViewCellViewModel: GameHistoryEndRoundTableViewCellViewModelProtocol {
    
    init(scoreChanges: [ScoreChange]) {
        self.scoreChanges = scoreChanges
    }
    
    var scoreChanges: [ScoreChange]
}
