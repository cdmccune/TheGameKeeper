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
    private var tableViewDelegate: GameHistoryEndRoundTableViewCellTableViewDelegate?

    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        tableView.register(UINib(nibName: "GameHistoryScoreChangeTableViewCell", bundle: nil), forCellReuseIdentifier: "GameHistoryScoreChangeTableViewCell")
        tableView.register(UINib(nibName: "GameHistoryErrorTableViewCell", bundle: nil), forCellReuseIdentifier: "GameHistoryErrorTableViewCell")
    }
    
    // MARK: - Functions
    
    func setupCellFor(round: Int, and scoreChanges: [ScoreChange]) {
        roundNumberLabel.text = "Round \(round)"
        
        let viewModel = GameHistoryEndRoundTableViewCellViewModel(scoreChanges: scoreChanges)
        self.viewModel = viewModel
        
        tableViewDelegate = GameHistoryEndRoundTableViewCellTableViewDelegate(viewModel: viewModel)
        tableView.dataSource = tableViewDelegate
        tableView.delegate = tableViewDelegate
        
        tableView.reloadData()
    }
}
