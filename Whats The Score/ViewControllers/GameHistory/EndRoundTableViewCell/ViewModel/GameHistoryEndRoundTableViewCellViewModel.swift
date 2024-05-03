//
//  GameHistoryEndRoundTableViewCellViewModel.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/12/24.
//

import Foundation

protocol GameHistoryEndRoundTableViewCellViewModelProtocol {
    var scoreChanges: [ScoreChangeProtocol] { get set }
}

class GameHistoryEndRoundTableViewCellViewModel: GameHistoryEndRoundTableViewCellViewModelProtocol {
    
    init(scoreChanges: [ScoreChangeProtocol]) {
        self.scoreChanges = scoreChanges
    }
    
    var scoreChanges: [ScoreChangeProtocol]
}
