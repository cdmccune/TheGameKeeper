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
    
    
    func setupCellWith(_ player: Player) {
        self.playerNameLabel.text = player.name
        self.playerScoreLabel.text = String(player.score)
    }
    
    func setupCellForError() {
        self.playerNameLabel.text = "Error"
        self.playerScoreLabel.text = "000"
    }

//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
}
