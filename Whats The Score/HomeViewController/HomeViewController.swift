//
//  HomeViewController.swift
//  What's The Score
//
//  Created by Curt McCune on 12/30/23.
//

import UIKit

class HomeViewController: UIViewController, Storyboarded {
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var continueGameButton: UIButton!
    @IBOutlet weak var quickStartButton: UIButton!
    @IBOutlet weak var setupGameButton: UIButton!
    @IBOutlet weak var myGamesButton: UIButton!
    
    
    // MARK: - Properties
    
    weak var coordinator: HomeTabCoordinator?
    var activeGame: GameProtocol?
    
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        continueGameButton.isHidden = activeGame == nil
        
        setupViews()
    }
    
    
    // MARK: - Private Functions
    
    func setupViews() {
        let gameKeeperAttributedString = NSMutableAttributedString(string: "Game Keeper")
        gameKeeperAttributedString.addStrokeAttribute(strokeColor: .black, strokeWidth: 4.0)
        gameKeeperAttributedString.addTextColorAttribute(textColor: .white)
        titleLabel.attributedText = gameKeeperAttributedString
        
        continueGameButton.underlineButtonForButtonStates(title: "Continue", withTextSize: 22)
        quickStartButton.underlineButtonForButtonStates(title: "Quick Start", withTextSize: 22)
        setupGameButton.underlineButtonForButtonStates(title: "Setup Game", withTextSize: 22)
        myGamesButton.underlineButtonForButtonStates(title: "My Games", withTextSize: 22)
    }
    
    // MARK: - IBActions
    
    @IBAction func setupGameButtonTapped(_ sender: Any) {
        coordinator?.setupNewGame()
    }
    
    @IBAction func quickStartButtonTapped(_ sender: Any) {
        coordinator?.setupQuickGame()
    }
    
    @IBAction func continueGameButtonTapped(_ sender: Any) {
        coordinator?.playActiveGame()
    }
    
    @IBAction func myGamesButtonTapped(_ sender: Any) {
        coordinator?.showMyGames()
    }
    
}
