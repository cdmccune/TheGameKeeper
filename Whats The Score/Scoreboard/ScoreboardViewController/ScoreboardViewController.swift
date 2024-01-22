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
    
    
    // MARK: - Properties
    
    var viewModel: ScoreboardViewModelProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setDelegates()
    }
    
    private func setDelegates() {
        self.viewModel?.delegate = self
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
    func bindViewToViewModel() {
        guard let viewModel else { return }
        let game = viewModel.game
        
        roundLabel.isHidden = game.gameType != .round
        roundLabel.text = "Round \(game.currentRound)"
    }
}
