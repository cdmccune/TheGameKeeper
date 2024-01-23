//
//  HomeViewController.swift
//  What's The Score
//
//  Created by Curt McCune on 12/30/23.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var quickStartButton: UIButton!
    @IBOutlet weak var setupGameButton: UIButton!
    
    
    // MARK: - Lifecycles
    
    
    // MARK: - IBActions
    
    @IBAction func setupGameButtonTapped(_ sender: Any) {
        let gameSetupVC = storyboard?.instantiateViewController(withIdentifier: "GameSetupViewController")
        
        navigationController?.pushViewController(gameSetupVC!, animated: true)
    }
    
    @IBAction func quickStartButtonTapped(_ sender: Any) {
        guard let scoreboardVC = storyboard?.instantiateViewController(withIdentifier: "ScoreboardViewController") as? ScoreboardViewController else {
            fatalError("Couldn't find ScoreboardViewController")
        }
        
        let game = Game(gameType: .basic,
                        gameEndType: .none,
                        numberOfRounds: 0,
                        numberOfPlayers: 2)
        
        let viewModel = ScoreboardViewModel(game: game)
        scoreboardVC.viewModel = viewModel
        
        navigationController?.pushViewController(scoreboardVC, animated: true)
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
