//
//  GameSettingsViewController.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/19/24.
//

import UIKit

class GameSettingsViewController: UIViewController, Storyboarded {
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var instructionLabel: UILabel!
    
    @IBOutlet weak var gameNameTextField: UITextField!
    
    @IBOutlet weak var gameEndStackView: UIStackView!
    @IBOutlet weak var gameEndTypeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var numberOfRoundsStackView: UIStackView!
    @IBOutlet weak var numberOfRoundTextField: UITextField!
    
    @IBOutlet weak var endingScoreStackView: UIStackView!
    @IBOutlet weak var endingScoreTextField: UITextField!
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var deleteGameButton: UIButton!
    
    
    // MARK: - Properties
    
    var viewModel: GameSettingsViewModelProtocol? 
    
    lazy var saveBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveChanges))
        
        barButton.tintColor = .textColor
        let attributes = [
            NSAttributedString.Key.font: UIFont.pressPlay2PRegular(withSize: 15)
        ]
        barButton.setTitleTextAttributes(attributes, for: .normal)
        barButton.setTitleTextAttributes(attributes, for: .highlighted)
        return barButton
    }()
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupTargets()
        setBindings()
        viewModel?.setInitialValues()
    }
    
    
    // MARK: - Private Functions
    
    private func setupViews() {

        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.pressPlay2PRegular(withSize: 10),
            .foregroundColor: UIColor.textColor
        ]
        
        gameEndTypeSegmentedControl.setTitleTextAttributes(textAttributes, for: .normal)
        gameEndTypeSegmentedControl.setTitleTextAttributes(textAttributes, for: .selected)
        
        let settingsAttributedString = NSMutableAttributedString(string: "Settings")
        settingsAttributedString.addStrokeAttribute(strokeColor: .black, strokeWidth: 4.0)
        titleLabel.attributedText = settingsAttributedString
        
        guard let viewModel else { return }
        gameNameTextField.text = viewModel.gameName
        endingScoreTextField.text = String(viewModel.endingScore)
        numberOfRoundTextField.text = String(viewModel.numberOfRounds)
        gameEndStackView.isHidden = viewModel.game.gameType == .basic
        
        navigationItem.rightBarButtonItem = saveBarButton
    }
    
    private func setupTargets() {
        gameNameTextField.addTarget(self, action: #selector(gameNameTextFieldEditingDidChange(_:)), for: .editingChanged)
        endingScoreTextField.addTarget(self, action: #selector(endingScoreTextFieldEditingDidChange(_:)), for: .editingChanged)
        numberOfRoundTextField.addTarget(self, action: #selector(numberOfRoundTextFieldEditingDidChange(_:)), for: .editingChanged)
    }
    
    private func setBindings() {
        viewModel?.gameEndType.valueChanged = { [weak self] gameEndType in
            guard let gameEndType else { return }
            self?.updateViews(for: gameEndType)
        }

        viewModel?.dataValidationString.valueChanged = { [weak self] dataValidationString in
            guard let dataValidationString else { return }
            self?.instructionLabel.text = dataValidationString
            self?.saveBarButton.isEnabled = dataValidationString.isEmpty
        }
    }
    
    private func updateViews(for gameEndType: GameEndType) {
        gameEndTypeSegmentedControl.selectedSegmentIndex = gameEndType.rawValue
        
        endingScoreStackView.isHidden = gameEndType != .score
        numberOfRoundsStackView.isHidden = gameEndType != .round
    }
    
    
    // MARK: - IBActions
    
    @IBAction func gameEndTypeSegmentedControlValueChanged(_ sender: Any) {
        viewModel?.gameEndTypeChanged(toRawValue: gameEndTypeSegmentedControl.selectedSegmentIndex)
    }
    
    @IBAction func resetButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure you want to reset?", message: "This will erase all of the game data and player scores", preferredStyle: .alert)
        
        let cancelAction = TestableUIAlertAction.createWith(title: "Cancel", style: .cancel) { _ in }
        let resetAction = TestableUIAlertAction.createWith(title: "Reset", style: .destructive) { _ in
            self.viewModel?.resetGame()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(resetAction)
        
        self.present(alert, animated: true)
    }
    
    
    @IBAction func deleteGameButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Delete Game", message: "Are you sure? This will delete all data associated with this game.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let deleteAction = TestableUIAlertAction.createWith(title: "Delete", style: .destructive) { _ in
            self.viewModel?.deleteGame()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        self.present(alertController, animated: true)
    }
    
    // MARK: - Functions

    @objc private func gameNameTextFieldEditingDidChange(_ sender: Any) {
        viewModel?.gameNameChanged(to: gameNameTextField.text ?? "")
    }

    @objc private func endingScoreTextFieldEditingDidChange(_ sender: Any) {
        let newEndingScore = Int(endingScoreTextField.text ?? "") ?? 0
        viewModel?.gameEndQuantityChanged(to: newEndingScore)
    }
    
    @objc private func numberOfRoundTextFieldEditingDidChange(_ sender: Any) {
        let newNumberOfRounds = Int(numberOfRoundTextField.text ?? "") ?? 0
        viewModel?.gameEndQuantityChanged(to: newNumberOfRounds)
    }
    
    @objc func saveChanges() {
        viewModel?.saveChanges()
        navigationController?.popViewController(animated: true)
    }
    
}
