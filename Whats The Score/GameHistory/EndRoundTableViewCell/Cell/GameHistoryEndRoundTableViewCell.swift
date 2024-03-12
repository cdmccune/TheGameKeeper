//
//  GameHistoryEndRoundTableViewCell.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/11/24.
//

import UIKit

class GameHistoryEndRoundTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var roundNumberLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Properties
    
    var viewModel: GameHistoryEndRoundTableViewCellViewModel?

    
    // MARK: - Functions
    
    func setupCellFor(round: Int, and scoreChanges: [ScoreChange]) {
        viewModel = GameHistoryEndRoundTableViewCellViewModel(scoreChanges: scoreChanges)
        
    }
}
