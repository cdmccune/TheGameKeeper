//
//  EndGamePlayerCollectionViewCell.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/8/24.
//

import UIKit

class EndGamePlayerCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerScoreLabel: UILabel!
    
    
    // MARK: - Functions

    func setupErrorCell() {
        self.playerNameLabel.text = "Error"
        self.playerScoreLabel.text = "???"
    }
    
    func setupViewFor(_ player: Player) {
        self.playerNameLabel.text = player.name
        self.playerScoreLabel.text = String(player.score)
    }
    
}
