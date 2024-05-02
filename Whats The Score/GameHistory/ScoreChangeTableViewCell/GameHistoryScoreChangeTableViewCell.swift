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
    @IBOutlet weak var disclosureIndicatorStackView: UIStackView!
    
    // MARK: - Functions
    
    func setupViewProperties(for scoreChange: ScoreChangeProtocol, isInEndRound: Bool = false) {
        scoreChangeLabel.text = String(scoreChange.scoreChange)
        scoreTotalLabel.text = String(scoreChange.player.getScoreThrough(scoreChange))
        
        switch scoreChange.scoreChange {
        case ..<0:
            scoreChangeLabel.textColor = .red
        case 0:
            scoreChangeLabel.textColor = .lightGray
        default: // Greater than zero
            scoreChangeLabel.textColor = .textColor
        }
        
        disclosureIndicatorStackView.isHidden = isInEndRound
        
        playerNameLabel.text = scoreChange.player.name
        playerNameLabel.textColor = scoreChange.player.icon.color
    }
}
