//
//  GameEndTypeSelectionViewController.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/21/24.
//

import UIKit

class GameEndTypeSelectionViewController: UIViewController, Storyboarded {
    
    // MARK: - Properties
    
    weak var coordinator: GameSetupCoordinator?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
