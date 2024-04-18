//
//  GameEndQuantitySelectionPopoverViewController.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/17/24.
//

import UIKit

class GameEndQuantitySelectionPopoverViewController: UIViewController, Storyboarded {
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var quantityTextField: UITextField!
    
    @IBOutlet weak var issueLabel: UILabel!
    
    // MARK: - Properties
    
    weak var coordinator: GameSetupCoordinator?
    var gameEndType: GameEndType?
    
    
    // MARK: - Lifecycles

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        addTargets()
    }
    
    
    // MARK: - Private Functions
    
    private func setupViews() {
        saveButton.underlineButtonForButtonStates(title: "Save")
        quantityTextField.becomeFirstResponder()
        
        guard let gameEndType else { return }
        
        if gameEndType == .round {
            quantityTextField.placeholder = "# of rounds"
            titleLabel.text = "Rounds"
        } else if gameEndType == .score {
            quantityTextField.placeholder = "Winning score"
            titleLabel.text = "Score"
        }
    }
    
    private func addTargets() {
        quantityTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let gameEndType,
              let text = quantityTextField.text else {
            saveButton.isEnabled = false
            issueLabel.text = "There has been an error"
            return
        }
        
        if gameEndType == .score,
           Int(text) ?? 0 < 1 {
            issueLabel.text = "Must be at least 1!"
            saveButton.isEnabled = false
        } else if gameEndType == .round,
                  Int(text) ?? 0 < 2 {
            issueLabel.text = "Must be at least 2!"
            saveButton.isEnabled = false
        } else {
            issueLabel.text = ""
            saveButton.isEnabled = true
        }
    }
    
    
    // MARK: - IBActions
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        let gameEndQuantity = Int(quantityTextField.text ?? "") ?? 2
        coordinator?.gameEndQuantitySelected(gameEndQuantity)
        
        self.dismiss(animated: true)
    }
    
    @IBAction func exitButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
}
