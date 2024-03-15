//
//  ScoreboardTableViewCell.swift
//  Whats The Score
//
//  Created by Curt McCune on 1/24/24.
//

import UIKit

class ScoreboardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerScoreLabel: UILabel!
    
    var editPlayer: (() -> Void)?
    
    
    func setupCellWith(_ player: PlayerProtocol) {
        self.playerNameLabel.text = player.name
        self.playerScoreLabel.text = String(player.score)
    }
    
    func setupCellForError() {
        self.playerNameLabel.text = "Error"
        self.playerScoreLabel.text = "000"
    }
    
    
    @IBAction func gearButtonTapped(_ sender: Any) {
        editPlayer?()
    }
}
