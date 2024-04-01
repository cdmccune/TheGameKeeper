//
//  GameEndQuantitySelectionViewController.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/21/24.
//

import UIKit

class GameEndQuantitySelectionViewController: UIViewController, Storyboarded {
    
    // MARK: - Outlets
    
    @IBOutlet weak var gameEndQuantityTextField: UITextField!
    
    
    // MARK: - Properties
    
    weak var coordinator: GameSetupCoordinator?

    
    // MARK: - IBActions

    @IBAction func goButtonTapped(_ sender: Any) {
        coordinator?.gameEndQuantitySelected(Int(gameEndQuantityTextField.text ?? "") ?? 0)
    }
}
