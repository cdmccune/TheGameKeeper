//
//  GameEndTypeSelectionViewController.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/21/24.
//

import UIKit

class GameEndTypeSelectionViewController: UIViewController, Storyboarded {
    
    // MARK: - Outlets
    
    @IBOutlet weak var gameEndLabel: UILabel!
    @IBOutlet weak var noneButton: UIButton!
    @IBOutlet weak var roundButton: UIButton!
    @IBOutlet weak var scoreButton: UIButton!
    
    
    // MARK: - Properties
    
    weak var coordinator: GameSetupCoordinator?
    
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        setupViews()
    }
    
    
    // MARK: - Private Functions
    
    private func setupViews() {
        let attributedString = NSMutableAttributedString(string: "Game End")
        attributedString.addStrokeAttribute(strokeColor: .black, strokeWidth: 4.0)
        gameEndLabel.attributedText = attributedString
        
        noneButton.setAttributedUnderlinedTitleWithSubtext(title: "None", subtext: "You will manually end the game when you are finished.")
        roundButton.setAttributedUnderlinedTitleWithSubtext(title: "Round", subtext: "The game ends after a certain number of rounds.")
        scoreButton.setAttributedUnderlinedTitleWithSubtext(title: "Score", subtext: "The game ends once a player reaches the end score.")
    }
    
    
    // MARK: - IBActions
    
    @IBAction func noneButtonTapped(_ sender: Any) {
        coordinator?.gameEndTypeSelected(.none)
    }
    
    
    @IBAction func roundButtonTapped(_ sender: Any) {
        coordinator?.gameEndTypeSelected(.round)
    }
    
    @IBAction func scoreButtonTapped(_ sender: Any) {
        coordinator?.gameEndTypeSelected(.score)
    }
    
}
