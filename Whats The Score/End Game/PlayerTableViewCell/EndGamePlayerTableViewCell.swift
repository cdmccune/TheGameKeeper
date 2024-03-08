//
//  EndGamePlayerTableViewCell.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/8/24.
//

import UIKit

class EndGamePlayerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerScoreLabel: UILabel!

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
    
    func setupNoLosingPlayers() {
        playerNameLabel.text = "There are no losers!"
        playerScoreLabel.text = ""
    }
    
    func setupErrorCell() {
        playerNameLabel.text = "There has been an error"
        playerScoreLabel.text = "???"
    }
    
    func setupViewFor(_ player: Player) {
        playerNameLabel.text = player.name
        playerScoreLabel.text = String(player.score)
    }
    
    
}
