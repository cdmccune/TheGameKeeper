//
//  ScoreboardViewController.swift
//  Whats The Score
//
//  Created by Curt McCune on 1/18/24.
//

import UIKit

class ScoreboardViewController: UIViewController, Storyboarded {

    // MARK: - Outlets
    
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterButtonStackView: UIStackView!
    
    @IBOutlet weak var turnOrderSortButton: UIButton!
    @IBOutlet weak var scoreSortButton: UIButton!
    @IBOutlet weak var endRoundButton: UIButton!
    
    @IBOutlet weak var progressBarStackView: UIStackView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressBarLeftLabel: UILabel!
    @IBOutlet weak var progressBarRightLabel: UILabel!
    
    // MARK: - Properties
    
    var viewModel: ScoreboardViewModelProtocol?
    private var tableViewDelegate: ScoreboardTableViewDelegateDatasource?
    var defaultPopoverPresenter: DefaultPopoverPresenterProtocol = DefaultPopoverPresenter()
    lazy var resetBarButton = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetButtonTapped))
    lazy var historyBarButton = UIBarButtonItem(image: UIImage(systemName: "clock.arrow.2.circlepath"), style: .plain, target: self, action: #selector(historyButtonTapped))
    lazy var settingsBarButton = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(settingsButtonTapped))

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setDelegates()
        registerNibs()
        setupViews()
        setBindings()
        isEndOfGameCheck()
    }
    
    
    // MARK: - Private Functions
    
    private func setDelegates() {
        guard viewModel != nil else { return }
        
        let tableViewDelegate = ScoreboardTableViewDelegateDatasource(viewModel: viewModel!)
        self.tableViewDelegate = tableViewDelegate
        
        viewModel!.delegate = self
        tableView.delegate = tableViewDelegate
        tableView.dataSource = tableViewDelegate
    }
    
    private func registerNibs() {
        tableView.register(UINib(nibName: "ScoreboardTableViewCell", bundle: nil), forCellReuseIdentifier: "ScoreboardTableViewCell")
    }
    
    private func setBindings() {
        
        viewModel?.sortPreference.valueChanged = { [weak self] sortPreference in
            self?.tableView.reloadData()
            self?.scoreSortButton.alpha = sortPreference == .score ? 1 : 0.5
            self?.turnOrderSortButton.alpha = sortPreference == .position ? 1 : 0.5
        }
        
        viewModel?.playerToDelete.valueChanged = { [weak self] _ in
            self?.presentDeletePlayerAlert()
        }
    }
    
    private func setupViews() {
        navigationItem.rightBarButtonItems = [settingsBarButton, resetBarButton, historyBarButton]
        
        self.scoreSortButton.alpha = 1
        self.turnOrderSortButton.alpha = 0.5
    }
    
    private func isEndOfGameCheck() {
        viewModel?.openingGameOverCheck()
    }
    
    private func presentDeletePlayerAlert() {
        guard let player = viewModel?.playerToDelete.value else { return }
                
                
        let alert = UIAlertController(title: "Delete Player", message: "Are you sure you want to remove \(player.name) from this game?", preferredStyle: .alert)
        
        let cancelAction = TestableUIAlertAction.createWith(title: "Cancel", style: .cancel) { _ in }
        let deleteAction = TestableUIAlertAction.createWith(title: "Delete", style: .destructive) { _ in
            self.viewModel?.deletePlayer(player)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        self.present(alert, animated: true)
    }
    
    
    // MARK: - IBActions
    
    @IBAction func endRoundButtonTapped(_ sender: Any) {
        viewModel?.showEndRoundPopover()
    }
    
    @IBAction func endGameButtonTapped(_ sender: Any) {
        viewModel?.endGame()
    }
    
    @IBAction func addPlayerTapped(_ sender: Any) {
        viewModel?.addPlayer()
    }
    
    @IBAction func scoreSortButtonTapped(_ sender: Any) {
        viewModel?.sortPreference.value = .score
    }
    
    @IBAction func turnOrderSortButtonTapped(_ sender: Any) {
        viewModel?.sortPreference.value = .position
    }
    
    @objc func resetButtonTapped() {
        let alert = UIAlertController(title: "Are you sure you want to reset?", message: "This will erase all of the game data and player scores", preferredStyle: .alert)
        
        let cancelAction = TestableUIAlertAction.createWith(title: "Cancel", style: .cancel) { _ in }
        let resetAction = TestableUIAlertAction.createWith(title: "Reset", style: .destructive) { _ in
            self.viewModel?.resetGame()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(resetAction)
        
        self.present(alert, animated: true)
    }
    
    @objc func historyButtonTapped() {
        viewModel?.showGameHistory()
    }
    
    @objc func settingsButtonTapped() {
        viewModel?.showGameSettings()
    }
    
    
}

extension ScoreboardViewController: ScoreboardViewModelViewProtocol {
    func bindViewToViewModel(dispatchQueue: DispatchQueueProtocol) {
        dispatchQueue.async {
            guard let viewModel = self.viewModel else { return }
            let game = viewModel.game
            
            self.roundLabel.isHidden = game.gameType != .round
            self.endRoundButton.isHidden = game.gameType != .round
            
            if game.isEndOfGame() {
                self.roundLabel.text = "Game Over"
            } else {
                self.roundLabel.text = "Round \(game.currentRound)"
            }
            
            self.filterButtonStackView.isHidden = game.gameType == .basic
            
            self.tableView.reloadData()
            
            guard game.gameType == .round,
                  game.gameEndType != .none,
                  !game.isEndOfGame() else {
                self.progressBarStackView.isHidden = true
                return
            }
            
            self.progressBarStackView.isHidden = false
            
            if game.gameEndType == .round {
                self.progressBar.progress = Float(game.currentRound - 1)/Float(game.numberOfRounds)
                self.progressBarRightLabel.text = "\(game.numberOfRounds)"
                
                let numberOfRoundsLeft = game.numberOfRounds - (game.currentRound - 1)
                
                if numberOfRoundsLeft > 1 {
                    self.progressBarLeftLabel.text = "\(numberOfRoundsLeft) rounds left"
                } else {
                    self.progressBarLeftLabel.text = "last round"
                }
            } else if game.gameEndType == .score {
                let topScore = game.winningPlayers.first?.score ?? 0
                self.progressBar.progress = (Float(topScore))/Float(game.endingScore)
                
                self.progressBarRightLabel.text = "\(game.endingScore)"
                
                let pointsToWin = game.endingScore - (game.winningPlayers.first?.score ?? 0)
                let pointsOrPoint = pointsToWin > 1 ? "pts" : "pt"
                
                if game.winningPlayers.count == 1 {
                    let playerName = game.winningPlayers.first?.name ?? ""
                    
                    self.progressBarLeftLabel.text = "\(playerName) needs \(pointsToWin) \(pointsOrPoint) to win"
                } else {
                    self.progressBarLeftLabel.text = "Multiple players need \(pointsToWin) \(pointsOrPoint) to win"
                }
            }
        }
    }
}