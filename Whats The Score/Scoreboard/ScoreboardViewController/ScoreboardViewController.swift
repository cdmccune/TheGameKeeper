//
//  ScoreboardViewController.swift
//  Whats The Score
//
//  Created by Curt McCune on 1/18/24.
//

import UIKit

class ScoreboardViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Properties
    
    var viewModel: ScoreboardViewModelProtocol?
    private var tableViewDelegate: ScoreboardTableViewDelegateDatasource?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setDelegates()
        registerNibs()
    }
    
    private func setDelegates() {
        guard viewModel != nil else { return }
        
        let tableViewDelegate = ScoreboardTableViewDelegateDatasource(viewModel: viewModel!)
        self.tableViewDelegate = tableViewDelegate
        
        viewModel!.delegate = self
        tableView.delegate = tableViewDelegate
        tableView.dataSource = tableViewDelegate
    }
    
    private func registerNibs() {
        tableView.register(UINib(nibName: "ScoreboardTableViewCell", bundle: nil), forCellReuseIdentifier: "ScoreboardTableViewCell")
    }
    

    // MARK: - IBActions
    
    @IBAction func endRoundButtonTapped(_ sender: Any) {
        viewModel?.endCurrentRound()
    }
    
    @IBAction func endGameButtonTapped(_ sender: Any) {
        viewModel?.endGame()
    }
    
}

extension ScoreboardViewController: ScoreboardViewModelViewProtocol {
    func bindViewToViewModel(dispatchQueue: DispatchQueueProtocol) {
        dispatchQueue.async {
            guard let viewModel = self.viewModel else { return }
            let game = viewModel.game
            
            self.roundLabel.isHidden = game.gameType != .round
            self.roundLabel.text = "Round \(game.currentRound)"
        }
    }
}