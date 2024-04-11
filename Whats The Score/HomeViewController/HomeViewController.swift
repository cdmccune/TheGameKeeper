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
    @IBOutlet weak var quickStartButton: UIButton!
    @IBOutlet weak var setupGameButton: UIButton!
    @IBOutlet weak var continueGameButton: UIButton!
    
    // MARK: - Properties
    
    weak var coordinator: HomeTabCoordinator?
    var activeGame: GameProtocol?
    
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        continueGameButton.isHidden = activeGame == nil
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
}
