//
//  PlayerSetupPlayerTableViewCell.swift
//  What's The Score
//
//  Created by Curt McCune on 1/9/24.
//

import UIKit

class PlayerSetupPlayerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerIconImageView: UIImageView!
    
    func setupViewPropertiesFor(player: PlayerSettings) {
        let playerNameAttributedString = NSMutableAttributedString(string: player.name)
        playerNameAttributedString.addStrokeAttribute(strokeColor: player.icon.color, strokeWidth: 4)
        
        playerNameLabel.attributedText = playerNameAttributedString
        
        playerIconImageView.image = player.icon.image
        playerIconImageView.layer.cornerRadius = 25
        playerIconImageView.layer.borderWidth = 2
        playerIconImageView.layer.borderColor = player.icon.color.cgColor
        
    }
    
    func setupErrorCell() {
        
    }
}
