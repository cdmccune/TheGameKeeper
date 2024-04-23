//
//  EndGamePlayerTableViewCell.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/8/24.
//

import UIKit

class EndGamePlayerTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerScoreLabel: UILabel!
    @IBOutlet weak var playerIconImageView: UIImageView!
    
    
    
    
    // MARK: - Lifecycles
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.playerIconImageView.layer.cornerRadius = 25
        self.playerIconImageView.layer.borderWidth = 2
    }
    
    
    // MARK: - Functions
    
    func setupNoLosingPlayers() {
        playerScoreLabel.text = "There are no losers!"
        playerNameLabel.isHidden = true
        playerIconImageView.isHidden = true
        
    }
    
    func setupErrorCell() {
        playerScoreLabel.text = "There has been an error"
        playerNameLabel.isHidden = true
        playerIconImageView.isHidden = true
    }
    
    func setupViewFor(_ player: PlayerProtocol, inPlace place: Int, isTied: Bool = false) {
        playerNameLabel.isHidden = false
        playerIconImageView.isHidden = false
        
        playerScoreLabel.text = String(player.score)
        positionLabel.text = (isTied ? "T-" : "") + place.ordinal
        
        let playerNameAttributedString = NSMutableAttributedString(string: player.name)
        playerNameAttributedString.addStrokeAttribute(strokeColor: player.icon.color, strokeWidth: 4)
        playerNameLabel.attributedText = playerNameAttributedString
        
        self.playerIconImageView.image = player.icon.image
        self.playerIconImageView.layer.borderColor = player.icon.color.cgColor
    }
    
    
}
