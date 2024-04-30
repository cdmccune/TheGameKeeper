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
        setBindings()
        viewModel?.setInitialValues()
    }
    
    
    // MARK: - Private Functions
    
    private func setupViews() {

        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.pressPlay2PRegular(withSize: 10),
            .foregroundColor: UIColor.textColor  // Optional: Set text color
        ]
        
        gameEndTypeSegmentedControl.setTitleTextAttributes(textAttributes, for: .normal)
        gameEndTypeSegmentedControl.setTitleTextAttributes(textAttributes, for: .selected)
        
        let settingsAttributedString = NSMutableAttributedString(string: "Settings")
        settingsAttributedString.addStrokeAttribute(strokeColor: .black, strokeWidth: 4.0)
        titleLabel.attributedText = settingsAttributedString
        
        guard let viewModel else { return }
        endingScoreTextField.text = String(viewModel.endingScore)
        numberOfRoundTextField.text = String(viewModel.numberOfRounds)
        gameEndStackView.isHidden = viewModel.game.gameType == .basic
        
        navigationItem.rightBarButtonItem = saveBarButton
    }
    
    private func setBindings() {
        viewModel?.gameEndType.valueChanged = { [weak self] gameEndType in
            guard let gameEndType else { return }
            self?.updateViews(for: gameEndType)
        }
    }
    
    private func updateViews(for gameEndType: GameEndType) {
        gameEndTypeSegmentedControl.selectedSegmentIndex = gameEndType.rawValue
        
        endingScoreStackView.isHidden = gameEndType != .score
        numberOfRoundsStackView.isHidden = gameEndType != .round
    }
    
    
    // MARK: - IBActions
    
    @IBAction func endingScoreTextFieldEditingDidEnd(_ sender: Any) {
        guard let text = endingScoreTextField.text,
              let endingScore = Int(text) else {
            return
        }
        
        viewModel?.endingScore = endingScore
        
    }
    
    @IBAction func numberOfRoundsTextFieldEditingDidEnd(_ sender: Any) {
        guard let text = numberOfRoundTextField.text,
              let numberOfRounds = Int(text) else {
            return
        }
        
        viewModel?.numberOfRounds = numberOfRounds
    }
    
    
    @IBAction func gameEndTypeSegmentedControlValueChanged(_ sender: Any) {
        guard let endGameType = GameEndType(rawValue: gameEndTypeSegmentedControl.selectedSegmentIndex) else {
            return
        }
        
        viewModel?.gameEndType.value = endGameType
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
    
    @objc func saveChanges() {
        viewModel?.saveChanges()
        navigationController?.popViewController(animated: true)
    }
    
}
