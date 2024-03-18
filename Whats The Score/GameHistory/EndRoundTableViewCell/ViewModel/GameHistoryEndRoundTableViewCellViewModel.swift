//
//  GameHistoryEndRoundTableViewCellViewModel.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/12/24.
//

import Foundation

protocol GameHistoryEndRoundTableViewCellViewModelProtocol {
    var scoreChanges: [ScoreChange] { get set }
//    var totalScores: [Int] { get set }
    var players: [PlayerProtocol] { get set }
}

class GameHistoryEndRoundTableViewCellViewModel: GameHistoryEndRoundTableViewCellViewModelProtocol {
    
    init(scoreChanges: [ScoreChange], players: [PlayerProtocol]) {
        self.scoreChanges = scoreChanges
        self.players = players
    }
    
    var scoreChanges: [ScoreChange]
    var players: [PlayerProtocol]
}
