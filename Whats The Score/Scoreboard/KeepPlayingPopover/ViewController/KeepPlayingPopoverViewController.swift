//
//  KeepPlayingPopoverViewController.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/1/24.
//

import UIKit

protocol KeepPlayingPopoverDelegate: AnyObject {
    func updateNumberOfRounds(to numberOfRounds: Int)
    func updateWinningScore(to winningScore: Int)
    func setNoEnd()
    func goToEndGameScreen()
    
}

class KeepPlayingPopoverViewController: UIViewController, Storyboarded, DismissingPopoverViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var inputDescriptionLabel: UILabel!
    @IBOutlet weak var saveChangesButton: UIButton!
    @IBOutlet weak var noEndButton: UIButton!
    @IBOutlet weak var endGameButton: UIButton!
    
    // MARK: - Properties
    
    var dismissingDelegate: PopoverDimissingDelegate?
    var game: GameProtocol?
    weak var delegate: KeepPlayingPopoverDelegate?
    lazy var textFieldDelegate = DismissingTextFieldDelegate()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        addTargets()
        setDelegates()
        inputTextField.becomeFirstResponder()
    }
    
    
    // MARK: - Private Funcs
    
    private func setupViews() {
        noEndButton.underlineButtonForButtonStates(title: "No End", withTextSize: 14)
        endGameButton.underlineButtonForButtonStates(title: "End Game", withTextSize: 14)
        
        guard let game = game else {
            fatalError("Forgot to set the game")
        }
        
        switch game.gameEndType {
        case .none:
            break
        case .round:
            instructionLabel.text = "Set the new number of rounds"
            inputDescriptionLabel.text = "rnds"
        case .score:
            instructionLabel.text = "Set the new winning score"
            inputDescriptionLabel.text = "pts"
        }
        
    }

    private func addTargets() {
        inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func setDelegates() {
        inputTextField.delegate = textFieldDelegate
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let game = game else {
            fatalError("Forgot to set the game")
        }
        
        let newInput = Int(textField.text ?? "") ?? 0
        
        if game.gameEndType == .round,
           game.currentRound > newInput {
            saveChangesButton.isEnabled = false
            instructionLabel.text = "Rounds must be higher than \(game.currentRound - 1)"
        } else if game.gameEndType == .score,
                  game.winningPlayers.first?.score ?? 0 >= newInput {
            saveChangesButton.isEnabled = false
            instructionLabel.text = "Score must be higher than \(game.winningPlayers.first?.score ?? 0)"
        } else {
            instructionLabel.text = "Tap save changes to play on!"
            saveChangesButton.isEnabled = true
        }
    }
    
    
    // MARK: - IBActions
    
    @IBAction func saveChangesButtonTapped(_ sender: Any) {
        guard let inputInt = Int(inputTextField.text ?? ""),
            let game = game  else {
            fatalError("Game wasn't set or input wasn't text")
        }
        
        switch game.gameEndType {
        case .none:
            fatalError("Game end type shouldn't be none on this popover")
        case .round:
            delegate?.updateNumberOfRounds(to: inputInt)
        case .score:
            delegate?.updateWinningScore(to: inputInt)
        }
        
        dismissPopover()
    }
    
    @IBAction func setNoEndButtonTapped(_ sender: Any) {
        delegate?.setNoEnd()
        dismissPopover()
    }
    
    @IBAction func endGameButtonTapped(_ sender: Any) {
        delegate?.goToEndGameScreen()
        dismissPopover()
    }
    
    
}
