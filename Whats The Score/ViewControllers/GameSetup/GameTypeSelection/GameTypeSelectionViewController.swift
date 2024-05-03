//
//  GameTypeSelectionViewController.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/21/24.
//

import UIKit

class GameTypeSelectionViewController: UIViewController, Storyboarded {
    
    // MARK: - Outlets
    
    @IBOutlet weak var gameTypeLabel: UILabel!
    @IBOutlet weak var basicButton: UIButton!
    @IBOutlet weak var roundButton: UIButton!
    
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        setupViews()
    }
    
    
    // MARK: - Private Functions
    
    private func setupViews() {
        let attributedString = NSMutableAttributedString(string: "GameType")
        attributedString.addStrokeAttribute(strokeColor: .black, strokeWidth: 4.0)
        gameTypeLabel.attributedText = attributedString
        
        roundButton.setAttributedUnderlinedTitleWithSubtext(title: "Round", subtext: "Round based game where points are added to players when the round is ended. Allows for conditions for winning to be set.")
        basicButton.setAttributedUnderlinedTitleWithSubtext(title: "Basic", subtext: "A simple game where points are added individually to players and game is manually ended")
    }
    
    
    // MARK: - Properties
    
    weak var coordinator: GameSetupCoordinator?

    // MARK: - IBActions
    
    @IBAction func basicButtonTapped(_ sender: Any) {
        coordinator?.gameTypeSelected(.basic)
    }
    
    @IBAction func roundButtonTapped(_ sender: Any) {
        coordinator?.gameTypeSelected(.round)
    }
    
}
