//
//  GameHistoryScoreChangeTableViewCell.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/11/24.
//

import UIKit

class GameHistoryScoreChangeTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var scoreChangeLabel: UILabel!
    @IBOutlet weak var scoreTotalLabel: UILabel!
    
    // MARK: - Functions
    
    func setupViewProperties(for scoreChange: ScoreChange, isInRoundEnd: Bool = false, andTotalScore totalScore: Int) {
        playerNameLabel.text = scoreChange.playerName
        scoreChangeLabel.text = String(scoreChange.scoreChange)
        scoreTotalLabel.text = String(totalScore)
        
        switch scoreChange.scoreChange {
        case ..<0:
            scoreChangeLabel.textColor = .red
        case 0:
            scoreChangeLabel.textColor = .label
        default: // Greater than zero
            scoreChangeLabel.textColor = .systemBlue
        }
        
        if isInRoundEnd {
            contentView.backgroundColor = .systemBlue.withAlphaComponent(0.3)
        } else {
            contentView.backgroundColor = nil
        }
    }
}
