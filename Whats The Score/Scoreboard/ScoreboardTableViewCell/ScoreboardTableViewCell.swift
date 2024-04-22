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
    @IBOutlet weak var playerIconImageView: UIImageView!
    @IBOutlet weak var positionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        playerIconImageView.layer.cornerRadius = 25
        playerIconImageView.layer.borderWidth = 2
    }
    
    
    func setupCellWith(_ player: PlayerProtocol, inPlace place: Int, isTied: Bool = false) {
        let playerNameAttributedString = NSMutableAttributedString(string: player.name)
        playerNameAttributedString.addStrokeAttribute(strokeColor: player.icon.color, strokeWidth: 4)
        playerNameLabel.attributedText = playerNameAttributedString
        
        positionLabel.text = (isTied ? "T-" : "") + place.ordinal
        
        self.playerScoreLabel.text = String(player.score)
        self.playerIconImageView.image = player.icon.image
        self.playerIconImageView.layer.borderColor = player.icon.color.cgColor
    }
    
    func setupCellForError() {
        self.playerNameLabel.text = "Error"
        self.playerScoreLabel.text = "000"
    }
}
