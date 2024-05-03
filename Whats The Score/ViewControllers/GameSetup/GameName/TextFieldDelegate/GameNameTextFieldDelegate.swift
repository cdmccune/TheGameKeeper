//
//  GameNameTextFieldDelegate.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/18/24.
//

import Foundation
import UIKit

class GameNameTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    // MARK: - Init
    
    init(coordinator: GameSetupCoordinator? = nil) {
        self.coordinator = coordinator
    }
    
    
    // MARK: - Properties
    
    var coordinator: GameSetupCoordinator?
    
    
    // MARK: - Functions
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard textField.text ?? "" != "" else { return false }
        
        coordinator?.gameNameSet(textField.text ?? "Game")
        return true
    }
}
