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

class EndGamePopoverViewController: UIViewController, Storyboarded, DismissingPopoverViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var gameOverDescriptionLabel: UILabel!
    @IBOutlet weak var keepPlayingButton: UIButton!
    @IBOutlet weak var finishGameButton: UIButton!
    
    // MARK: - Properties
    
    var dismissingDelegate: PopoverDimissingDelegate?
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
            gameOverDescriptionLabel.text = "You completed \(game.currentRound - 1) rounds"
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
        dismissPopover()
    }
    
    @IBAction func keepPlayingButtonTapped(_ sender: Any) {
        delegate?.keepPlayingSelected()
        dismissPopover()
    }
}
