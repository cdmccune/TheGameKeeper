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
    @IBOutlet weak var playerIconImageView: UIImageView!
    
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.playerIconImageView.layer.cornerRadius = 25
        self.playerIconImageView.layer.borderWidth = 2
    }
    
    // MARK: - Functions

    func setupErrorCell() {
        self.playerNameLabel.text = "Error"
        self.playerScoreLabel.text = "???"
    }
    
    func setupViewFor(_ player: PlayerProtocol) {
        self.playerScoreLabel.text = String(player.score)
        
        self.playerIconImageView.image = player.icon.image
        self.playerIconImageView.layer.borderColor = player.icon.color.cgColor
        
        let playerNameAttributedString = NSMutableAttributedString(string: player.name)
        playerNameAttributedString.addStrokeAttribute(strokeColor: player.icon.color, strokeWidth: 4)
        playerNameLabel.attributedText = playerNameAttributedString
    }
    
}
