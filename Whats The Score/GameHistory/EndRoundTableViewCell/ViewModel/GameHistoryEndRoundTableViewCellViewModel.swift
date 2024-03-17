//
//  GameHistoryEndRoundTableViewCellViewModel.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/12/24.
//

import Foundation

protocol GameHistoryEndRoundTableViewCellViewModelProtocol {
    var scoreChanges: [ScoreChange] { get set }
    var totalScores: [Int] { get set }
}

class GameHistoryEndRoundTableViewCellViewModel: GameHistoryEndRoundTableViewCellViewModelProtocol {
    
    init(scoreChanges: [ScoreChange], totalScores: [Int]) {
        self.scoreChanges = scoreChanges
        self.totalScores = totalScores
    }
    
    var scoreChanges: [ScoreChange]
    var totalScores: [Int]
}
