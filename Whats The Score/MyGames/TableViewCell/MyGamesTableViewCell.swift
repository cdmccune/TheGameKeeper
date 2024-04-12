//
//  MyGamesTableViewCell.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/11/24.
//

import UIKit

class MyGamesTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    

    func setupCellFor(_ game: GameProtocol) {
        titleLabel.text = game.id.uuidString
    }
    
    func setupNoGamesCell(for status: GameStatus) {
        titleLabel.text = "No games"
    }
    
    func setupErrorCell() {
        titleLabel.text = "Error"
    }
    
}
