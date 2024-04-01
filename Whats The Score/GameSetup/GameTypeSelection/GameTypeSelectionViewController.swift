//
//  GameTypeSelectionViewController.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/21/24.
//

import UIKit

class GameTypeSelectionViewController: UIViewController, Storyboarded {
    
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
