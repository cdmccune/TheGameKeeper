//
//  GameNameViewController.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/12/24.
//

import UIKit

class GameNameViewController: UIViewController, Storyboarded {
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameTextField: UITextField!
    
    
    // MARK: - Properties
    
    weak var coordinator: GameSetupCoordinator?
    
    
    // MARK: - IBActions
    
    
    @IBAction func goButtonTapped(_ sender: Any) {
        coordinator?.gameNameSet(nameTextField.text ?? "Game")
    }
    
    
}
