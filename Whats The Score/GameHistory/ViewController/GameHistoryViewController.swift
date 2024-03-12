//
//  GameHistoryViewController.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/11/24.
//

import UIKit

class GameHistoryViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Properties
    
    private lazy var tableViewDelegate = GameHistoryTableViewDelegate(viewModel: viewModel)
    var viewModel: GameHistoryViewModelProtocol!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setDelegates()
        registerNibs()
    }
    
    
    // MARK: - Private Functions
    
    private func setDelegates() {
        tableView.delegate = tableViewDelegate
        tableView.dataSource = tableViewDelegate
    }
    
    private func registerNibs() {
        tableView.register(UINib(nibName: "GameHistoryScoreChangeTableViewCell", bundle: nil), forCellReuseIdentifier: "GameHistoryScoreChangeTableViewCell")
        tableView.register(UINib(nibName: "GameHistoryEndRoundTableViewCell", bundle: nil), forCellReuseIdentifier: "GameHistoryEndRoundTableViewCell")
        tableView.register(UINib(nibName: "GameHistoryErrorTableViewCell", bundle: nil), forCellReuseIdentifier: "GameHistoryErrorTableViewCell")
    }
}
