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
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var winnerLabel: UILabel!
    @IBOutlet weak var winnerNameLabel: UILabel!
    
    
    // MARK: - Functions

    func setupCellFor(_ game: GameProtocol) {
        titleLabel.text = game.name
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        dateLabel.text = dateFormatter.string(from: game.lastModified)
        
        winnerLabel.text = game.gameStatus == .completed ? "Winner" : "Winning"
        
        switch game.winningPlayers.count {
        case 0:
            winnerNameLabel.text = "No winners"
        case 1:
            winnerNameLabel.text = game.winningPlayers.first?.name
        default:
            winnerNameLabel.text = "Multiple"
        }
    }
    
    func setupNoGamesCell(for status: GameStatus) {
        titleLabel.text = "No games"
    }
    
    func setupErrorCell() {
        titleLabel.text = "Error"
    }
    
}
