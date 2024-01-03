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
        viewModel = GameSetupViewModel(gameSettings: GameSettings(gameType: .basic,
                                                                  gameEndType: .none,
                                                                  numberOfRounds: 1,
                                                                  numberOfPlayers: 2))
    }
    
    //MARK: - Outlets
    
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
    
    
    //MARK: - Properties
    
    var viewModel: GameSetupViewModel?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.delegate = self
    }
    
    
    //MARK: - IBActions

    @IBAction func gameTypeSegmentedControlValueChanged(_ sender: Any) {
        guard let gameType = GameType(rawValue: gameTypeSegmentedControl.selectedSegmentIndex) else {
            return
        }
        
        viewModel?.gameSettings.gameType = gameType
    }
    
    @IBAction func gameEndTypeSegmentedControlValueChanged(_ sender: Any) {
        guard let gameEndType = GameEndType(rawValue: gameEndTypeSegmentedControl.selectedSegmentIndex) else {
            return
        }
        
        viewModel?.gameSettings.gameEndType = gameEndType
    }
    
    @IBAction func numberOfRoundsTextFieldValueChanged(_ sender: Any) {
        guard let numberOfRounds = Int(numberOfRoundsTextField.text ?? "") else { return }
        viewModel?.gameSettings.numberOfRounds = numberOfRounds
    }
    
    @IBAction func endingScoreTextFieldValueChanged(_ sender: Any) {
        guard let endingScore = Int(endingScoreTextField.text ?? "") else { return }
        viewModel?.gameSettings.endingScore = endingScore
    }
    
    @IBAction func numberOfPlayersTextFieldValueChanged(_ sender: Any) {
        guard let numberOfPlayers = Int(numberOfRoundsTextField.text ?? "") else { return }
        viewModel?.gameSettings.numberOfPlayers = numberOfPlayers
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        let playerSetupVC = storyboard?.instantiateViewController(withIdentifier: "PlayerSetupViewController")
        
        navigationController?.pushViewController(playerSetupVC!, animated: true)
    }
    
    
    
    
    
}


extension GameSetupViewController: GameSetupViewModelProtocol {
    func bindViewToGameSettings(with gameSettings: GameSettings) {

        //Setting Values
        self.gameTypeSegmentedControl.selectedSegmentIndex = gameSettings.gameType.rawValue
        self.gameEndTypeSegmentedControl.selectedSegmentIndex = gameSettings.gameEndType.rawValue
        self.numberOfRoundsTextField.text = String(gameSettings.numberOfRounds)
        self.numberOfPlayersTextField.text = String(gameSettings.numberOfPlayers)

        if let endingScore = gameSettings.endingScore {
            self.endingScoreTextField.text = String(endingScore)
        } else {
            self.endingScoreTextField.text = ""
        }
        
        //Hiding and Showing
        self.gameEndTypeStackView.isHidden = gameSettings.gameType == .basic
        self.numberOfRoundsStackView.isHidden = gameSettings.gameType == .basic || gameSettings.gameEndType != .round
        self.endingScoreStackView.isHidden = gameSettings.gameType == .round && gameSettings.gameEndType != .score
        
    }
}
