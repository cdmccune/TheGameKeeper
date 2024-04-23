//
//  EndGamePopoverViewController.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/1/24.
//

import UIKit

protocol EndGamePopoverDelegate: AnyObject {
    func goToEndGameScreen()
    func keepPlayingSelected()
}

class EndGamePopoverViewController: UIViewController, Storyboarded {
    
    // MARK: - Outlets
    
    @IBOutlet weak var gameOverDescriptionLabel: UILabel!
    @IBOutlet weak var keepPlayingButton: UIButton!
    @IBOutlet weak var finishGameButton: UIButton!
    
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
        keepPlayingButton.underlineButtonForButtonStates(title: "Keep Playing", withTextSize: 15)
        finishGameButton.underlineButtonForButtonStates(title: "Finish Game", withTextSize: 15)
        
        guard let game = game else { return }
        
        guard game.gameType != .basic else {
            gameOverDescriptionLabel.text = ""
            return
        }
        
        guard game.isEndOfGame() else {
            gameOverDescriptionLabel.text = "Do you want to end the game on round \(game.currentRound)?"
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
        delegate?.keepPlayingSelected()
        self.dismiss(animated: true)
    }
}
