//
//  GameEndQuantitySelectionViewController.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/21/24.
//

import UIKit

class GameEndQuantitySelectionViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var gameEndQuantityTextField: UITextField!
    
    
    weak var coordinator: GameSetupCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func goButtonTapped(_ sender: Any) {
        coordinator?.gameEndQuantitySelected(Int(gameEndQuantityTextField.text ?? "") ?? 0)
    }
    
    
}
