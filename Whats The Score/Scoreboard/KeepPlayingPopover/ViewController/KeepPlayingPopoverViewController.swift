//
//  KeepPlayingPopoverViewController.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/1/24.
//

import UIKit

class KeepPlayingPopoverViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var inputDescriptionLabel: UILabel!
    @IBOutlet weak var saveChangesButton: UIButton!
    
    
    // MARK: - Properties
    
    var game: GameProtocol?
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        addTargets()
        inputTextField.becomeFirstResponder()
    }
    
    
    // MARK: - Private Funcs
    
    private func setupViews() {
        guard let game = game else {
            fatalError("Forgot to set the game")
        }
        
        switch game.gameEndType {
        case .none:
            fatalError("Keep playing popup shouldn't be shown")
        case .round:
            instructionLabel.text = "Set the new number of rounds"
            inputDescriptionLabel.text = "Rounds"
        case .score:
            instructionLabel.text = "Set the new winning score"
            inputDescriptionLabel.text = "Points"
        }
        
    }

    private func addTargets() {
        inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let game = game else {
            fatalError("Forgot to set the game")
        }
        
        
        guard let text = textField.text,
            let newInput = Int(text) else {
            saveChangesButton.isEnabled = false
            return
        }
        
        
        if game.gameEndType == .round,
           game.currentRound > newInput {
            saveChangesButton.isEnabled = false
            instructionLabel.textColor = .red
            instructionLabel.text = "Rounds must be higher than \(game.currentRound - 1)"
        } else if game.gameEndType == .score,
                  game.winningPlayers.first?.score ?? 0 >= newInput {
            saveChangesButton.isEnabled = false
            instructionLabel.textColor = .red
            instructionLabel.text = "Score must be higher than \(game.winningPlayers.first?.score ?? 0)"
        } else {
            instructionLabel.textColor = .systemBlue
            instructionLabel.text = "Tap save changes to play on!"
            saveChangesButton.isEnabled = true
        }
    }
    

}
