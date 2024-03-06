//
//  EndGamePopoverViewController.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/1/24.
//

import UIKit

protocol EndGamePopoverDelegate: AnyObject {
    func goToEndGameScreen()
    func showKeepPlayingPopup()
}

class EndGamePopoverViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var gameOverDescriptionLabel: UILabel!
    
    // MARK: - Properties
    
    var delegate: EndGamePopoverDelegate?
    var game: GameProtocol?
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    
    // MARK: - Functions
    
    private func setupViews() {
        guard let game = game else { return }
        
        guard game.gameType != .basic else {
            gameOverDescriptionLabel.text = ""
            return
        }
        
        guard game.isEndOfGame() else {
            gameOverDescriptionLabel.text = "You manually ended the game on round \(game.currentRound)"
            return
        }
        
        
        if game.gameEndType == .round {
            gameOverDescriptionLabel.text = "You completed \(game.numberOfRounds) rounds"
        } else if game.gameEndType == .score {
            let playerNameText = game.winningPlayers.count == 1 ? game.winningPlayers.first?.name ?? "" : "Multiple players"
            gameOverDescriptionLabel.text = playerNameText + " reached \(game.endingScore) points"
        }
    }
    
    
    // MARK: - IBActions
    
    @IBAction func finishGameButtonTapped(_ sender: Any) {
        delegate?.goToEndGameScreen()
        self.dismiss(animated: true)
    }
    
    @IBAction func keepPlayingButtonTapped(_ sender: Any) {
        delegate?.showKeepPlayingPopup()
        self.dismiss(animated: true)
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
