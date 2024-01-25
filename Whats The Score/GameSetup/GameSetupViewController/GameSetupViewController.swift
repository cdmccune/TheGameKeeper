//
//  GameSetupViewController.swift
//  What's The Score
//
//  Created by Curt McCune on 12/30/23.
//

import UIKit

class GameSetupViewController: UIViewController {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewModel = GameSetupViewModel()
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var gameTypeStackView: UIStackView!
    @IBOutlet weak var gameTypeLabel: UILabel!
    @IBOutlet weak var gameTypeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var gameEndTypeStackView: UIStackView!
    @IBOutlet weak var gameEndTypeLabel: UILabel!
    @IBOutlet weak var gameEndTypeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var numberOfRoundsStackView: UIStackView!
    @IBOutlet weak var numberOfRoundsLabel: UILabel!
    @IBOutlet weak var numberOfRoundsTextField: UITextField!
    
    @IBOutlet weak var endingScoreStackView: UIStackView!
    @IBOutlet weak var endingScoreLabel: UILabel!
    @IBOutlet weak var endingScoreTextField: UITextField!
    
    @IBOutlet weak var numberOfPlayersStackView: UIStackView!
    @IBOutlet weak var numberOfPlayersLabel: UILabel!
    @IBOutlet weak var numberOfPlayersTextField: UITextField!
    
    
    // MARK: - Properties
    
    var viewModel: GameSetupViewModel?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBindings()
        viewModel?.setInitialValues()
    }
    
    
    // MARK: - Private Functions
    
    private func setBindings() {
        viewModel?.gameType.valueChanged = { [weak self] gameType in
            guard let newIndex = gameType?.rawValue else { return }
            self?.gameTypeSegmentedControl.selectedSegmentIndex = newIndex
            
            self?.handleHidingAndShowingStackViews()
        }
        
        viewModel?.gameEndType.valueChanged = { [weak self] gameEndType in
            guard let newIndex = gameEndType?.rawValue else { return }
            self?.gameEndTypeSegmentedControl.selectedSegmentIndex = newIndex
            
            self?.handleHidingAndShowingStackViews()
        }
        
        viewModel?.numberOfRounds.valueChanged = { [weak self] numberOfRounds in
            let text: String? = numberOfRounds == nil ? nil : String(numberOfRounds ?? 0)
            self?.numberOfRoundsTextField.text = text
        }
        
        viewModel?.numberOfPlayers.valueChanged = { [weak self] numberOfPlayers in
            let text: String? = numberOfPlayers == nil ? nil : String(numberOfPlayers ?? 0)
            self?.numberOfPlayersTextField.text = text
        }
        
        viewModel?.endingScore.valueChanged = { [weak self] endingScore in
            let text: String? = endingScore == nil ? nil : String(endingScore ?? 0)
            self?.endingScoreTextField.text = text
        }
    }
    
    private func handleHidingAndShowingStackViews() {
        self.gameEndTypeStackView.isHidden = viewModel?.gameType.value == .basic
        
        self.numberOfRoundsStackView.isHidden = viewModel?.gameType.value == .basic || viewModel?.gameEndType.value != .round
        self.endingScoreStackView.isHidden = viewModel?.gameType.value != .round || viewModel?.gameEndType.value != .score
    }
    
    
    // MARK: - IBActions

    @IBAction func gameTypeSegmentedControlValueChanged(_ sender: Any) {
        guard let gameType = GameType(rawValue: gameTypeSegmentedControl.selectedSegmentIndex) else {
            return
        }
        
        viewModel?.gameType.value = gameType
    }
    
    @IBAction func gameEndTypeSegmentedControlValueChanged(_ sender: Any) {
        guard let gameEndType = GameEndType(rawValue: gameEndTypeSegmentedControl.selectedSegmentIndex) else {
            return
        }
        
        viewModel?.gameEndType.value = gameEndType
    }
    
    @IBAction func numberOfRoundsTextFieldValueChanged(_ sender: Any) {
        guard let numberOfRounds = Int(numberOfRoundsTextField.text ?? "") else { return }
        viewModel?.numberOfRounds.value = numberOfRounds
    }
    
    @IBAction func endingScoreTextFieldValueChanged(_ sender: Any) {
        guard let endingScore = Int(endingScoreTextField.text ?? "") else { return }
        viewModel?.endingScore.value = endingScore
    }
    
    @IBAction func numberOfPlayersTextFieldValueChanged(_ sender: Any) {
        guard let numberOfPlayers = Int(numberOfPlayersTextField.text ?? "") else { return }
        viewModel?.numberOfPlayers.value = numberOfPlayers
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        guard let viewModel else { return }
        
        let playerSetupVC = storyboard?.instantiateViewController(withIdentifier: "PlayerSetupViewController") as? PlayerSetupViewController
        let newGame = Game(gameType: viewModel.gameType.value ?? .basic,
                           gameEndType: viewModel.gameEndType.value ?? .none,
                           numberOfRounds: viewModel.numberOfRounds.value, 
                           endingScore: viewModel.endingScore.value,
                           numberOfPlayers: viewModel.numberOfPlayers.value ?? 2)
        playerSetupVC?.viewModel = PlayerSetupViewModel(game: newGame)
        
        navigationController?.pushViewController(playerSetupVC!, animated: true)
    }
}
