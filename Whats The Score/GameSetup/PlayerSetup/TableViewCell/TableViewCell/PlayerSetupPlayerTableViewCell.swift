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
        playerNameLabel.text = player.name
        playerNameLabel.textColor = player.icon.color
        
        playerIconImageView.image = player.icon.image
        playerIconImageView.layer.cornerRadius = 25
        playerIconImageView.layer.borderWidth = 2
        playerIconImageView.layer.borderColor = player.icon.color.cgColor
        
    }
    
    func setupErrorCell() {
        
    }
}
