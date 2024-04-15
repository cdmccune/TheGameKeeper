//
//  GameSettingsViewController.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/19/24.
//

import UIKit

class GameSettingsViewController: UIViewController, Storyboarded {
    
    // MARK: - Outlets
    
    @IBOutlet weak var gameEndTypeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var numberOfRoundsStackView: UIStackView!
    @IBOutlet weak var numberOfRoundTextField: UITextField!
    
    @IBOutlet weak var endingScoreStackView: UIStackView!
    @IBOutlet weak var endingScoreTextField: UITextField!
    
    
    // MARK: - Properties
    
    var viewModel: GameSettingsViewModelProtocol? 
    
    lazy var saveBarButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveChanges))
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setBindings()
        viewModel?.setInitialValues()
    }
    
    
    // MARK: - Private Functions
    
    private func setupViews() {
        guard let viewModel else { return }
        endingScoreTextField.text = String(viewModel.endingScore)
        numberOfRoundTextField.text = String(viewModel.numberOfRounds)
        
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
