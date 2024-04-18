//
//  GameNameViewController.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/12/24.
//

import UIKit

class GameNameViewController: UIViewController, Storyboarded {
    
    // MARK: - Outlets
    
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    
    // MARK: - Properties
    
    weak var coordinator: GameSetupCoordinator?
    lazy var textFieldDelegate = GameNameTextFieldDelegate(coordinator: coordinator)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setDelegatesAndTargets()
    }
    
    
    // MARK: - Private Functions
    
    private func setupViews() {
        let attributedString = NSMutableAttributedString(string: "Game Name")
        attributedString.addStrokeAttribute(strokeColor: .black, strokeWidth: 4.0)
        gameNameLabel.attributedText = attributedString
        
        continueButton.underlineButtonForButtonStates(title: "Continue", withTextSize: 22)
        nameTextField.becomeFirstResponder()
    }
    
    private func setDelegatesAndTargets() {
        nameTextField.delegate = textFieldDelegate
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        continueButton.isEnabled = nameTextField.text ?? "" != ""
    }
    
    
    // MARK: - IBActions
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        coordinator?.gameNameSet(nameTextField.text ?? "Game")
    }
}
