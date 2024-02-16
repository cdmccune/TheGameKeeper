//
//  EndRoundPopoverTableViewCell.swift
//  Whats The Score
//
//  Created by Curt McCune on 2/16/24.
//

import UIKit

class EndRoundPopoverTableViewCell: UITableViewCell {
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var scoreTextField: UITextField!
    
    
    // MARK: - Functions
    
    func setupViewProperties(for player: Player) {
        playerNameLabel.text = player.name
    }
    
    func setupErrorCell() {
        playerNameLabel.text = "Error"
    }
    
    
}
