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
        viewModel = GameSetupViewModel(game: Game(gameType: .basic,
                                                                  gameEndType: .none,
                                                                  numberOfRounds: 1,
                                                                  numberOfPlayers: 2))
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
        
        viewModel?.delegate = self
    }
    
    
    // MARK: - IBActions

    @IBAction func gameTypeSegmentedControlValueChanged(_ sender: Any) {
        guard let gameType = GameType(rawValue: gameTypeSegmentedControl.selectedSegmentIndex) else {
            return
        }
        
        viewModel?.game.gameType = gameType
    }
    
    @IBAction func gameEndTypeSegmentedControlValueChanged(_ sender: Any) {
        guard let gameEndType = GameEndType(rawValue: gameEndTypeSegmentedControl.selectedSegmentIndex) else {
            return
        }
        
        viewModel?.game.gameEndType = gameEndType
    }
    
    @IBAction func numberOfRoundsTextFieldValueChanged(_ sender: Any) {
        guard let numberOfRounds = Int(numberOfRoundsTextField.text ?? "") else { return }
        viewModel?.game.numberOfRounds = numberOfRounds
    }
    
    @IBAction func endingScoreTextFieldValueChanged(_ sender: Any) {
        guard let endingScore = Int(endingScoreTextField.text ?? "") else { return }
        viewModel?.game.endingScore = endingScore
    }
    
    @IBAction func numberOfPlayersTextFieldValueChanged(_ sender: Any) {
        guard let numberOfPlayers = Int(numberOfPlayersTextField.text ?? "") else { return }
        viewModel?.game.numberOfPlayers = numberOfPlayers
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        guard let game = viewModel?.game else { return }
        
        let playerSetupVC = storyboard?.instantiateViewController(withIdentifier: "PlayerSetupViewController") as? PlayerSetupViewController
        playerSetupVC?.viewModel = PlayerSetupViewModel(game: game)
        
        navigationController?.pushViewController(playerSetupVC!, animated: true)
    }
}


extension GameSetupViewController: GameSetupViewModelProtocol {
    func bindViewToGame(with game: Game) {

        // Setting Values
        self.gameTypeSegmentedControl.selectedSegmentIndex = game.gameType.rawValue
        self.gameEndTypeSegmentedControl.selectedSegmentIndex = game.gameEndType.rawValue
        self.numberOfRoundsTextField.text = String(game.numberOfRounds)
        self.numberOfPlayersTextField.text = String(game.numberOfPlayers)

        if let endingScore = game.endingScore {
            self.endingScoreTextField.text = String(endingScore)
        } else {
            self.endingScoreTextField.text = ""
        }
        
        // Hiding and Showing
        self.gameEndTypeStackView.isHidden = game.gameType == .basic
        self.numberOfRoundsStackView.isHidden = game.gameType == .basic || game.gameEndType != .round
        self.endingScoreStackView.isHidden = game.gameType == .round && game.gameEndType != .score
        
    }
}
