//
//  ScoreboardViewController.swift
//  Whats The Score
//
//  Created by Curt McCune on 1/18/24.
//

import UIKit

class ScoreboardViewController: UIViewController {

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
    lazy var endRoundPopoverHeightHelper: EndRoundPopoverHeightHelperProtocol = EndRoundPopoverHeightHelper(playerViewHeight: 45, playerSeperatorHeight: 3)

    
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
        viewModel?.playerToEditScore.valueChanged = { [weak self] player in
            guard let player = player else { return }
            self?.editPlayerScore(for: player)
        }
        
        viewModel?.playerToEdit.valueChanged = { [weak self] player in
            guard let player = player else { return }
            self?.editPlayer(player)
        }
        
        viewModel?.sortPreference.valueChanged = { [weak self] sortPreference in
            self?.tableView.reloadData()
            self?.scoreSortButton.alpha = sortPreference == .score ? 1 : 0.5
            self?.turnOrderSortButton.alpha = sortPreference == .position ? 1 : 0.5
        }
        
        viewModel?.playerToDelete.valueChanged = { [weak self] _ in
            self?.presentDeletePlayerAlert()
        }
        
        viewModel?.shouldShowEndGamePopup.valueChanged = { [weak self] shouldShow in
            guard shouldShow ?? false else { return }
            self?.presentEndGamePopoverView()
            self?.viewModel?.shouldShowEndGamePopup.value = false
        }
        
        viewModel?.shouldGoToEndGameScreen.valueChanged = { [weak self] shouldShow in
            guard shouldShow ?? false else { return }
            
            self?.presentEndGameScreen()
        }
        
        viewModel?.shouldShowKeepPlayingPopup.valueChanged = { [weak self] shouldShow in
            guard shouldShow ?? false else { return }
            self?.presentKeepPlayingPopoverView()
            self?.viewModel?.shouldShowKeepPlayingPopup.value = false
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
    
    private func editPlayerScore(for player: PlayerProtocol) {
        guard viewModel != nil else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let editPlayerScoreVC = storyboard.instantiateViewController(withIdentifier: "ScoreboardPlayerEditScorePopoverViewController") as? ScoreboardPlayerEditScorePopoverViewController else { fatalError("ScoreboardPlayerEditScorePopoverViewController not instantiated")}
        
        
        editPlayerScoreVC.scoreChange = ScoreChange(player: player, scoreChange: 0)
        editPlayerScoreVC.delegate = viewModel!
        
        defaultPopoverPresenter.setupPopoverCentered(onView: self.view, withPopover: editPlayerScoreVC, withWidth: 300, andHeight: 200, tapToExit: true)
        
        self.present(editPlayerScoreVC, animated: true)
    }
    
    private func editPlayer(_ player: PlayerProtocol) {
        guard viewModel != nil else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let editPlayerVC = storyboard.instantiateViewController(withIdentifier: "EditPlayerPopoverViewController") as? EditPlayerPopoverViewController else { fatalError("EditPlayerPopoverViewController not instantiated")}
        
        
        editPlayerVC.player = player
        editPlayerVC.delegate = viewModel!
        
        defaultPopoverPresenter.setupPopoverCentered(onView: self.view, withPopover: editPlayerVC, withWidth: 300, andHeight: 100, tapToExit: true)
        
        self.present(editPlayerVC, animated: true)
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
    
    private func presentEndGamePopoverView() {
        guard let game = viewModel?.game else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let endGamePopoverVC = storyboard.instantiateViewController(withIdentifier: "EndGamePopoverViewController") as? EndGamePopoverViewController else {
            fatalError("EndGamePopoverViewController not instantiated")
        }
        
        endGamePopoverVC.game = game
        endGamePopoverVC.delegate = viewModel
        
        defaultPopoverPresenter.setupPopoverCentered(onView: self.view, withPopover: endGamePopoverVC, withWidth: 300, andHeight: 165, tapToExit: !game.isEndOfGame())
        
        self.present(endGamePopoverVC, animated: true)
    }
    
    private func presentEndGameScreen() {
        guard let game = viewModel?.game else {
            fatalError("There was no game")
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let endGameViewController = storyboard.instantiateViewController(withIdentifier: "EndGameViewController") as? EndGameViewController else {
            fatalError("EndGameViewController couldn't be instantiated")
        }
        
        endGameViewController.viewModel = EndGameViewModel(game: game)
        
        self.navigationController?.viewControllers = [endGameViewController]
    }
    
    private func presentKeepPlayingPopoverView() {
        guard let game = viewModel?.game else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let keepPlayingPopoverVC = storyboard.instantiateViewController(withIdentifier: "KeepPlayingPopoverViewController") as? KeepPlayingPopoverViewController else {
            fatalError("KeepPlayingPopoverViewController not instantiated")
        }
        
        keepPlayingPopoverVC.game = game
        keepPlayingPopoverVC.delegate = viewModel
        
        defaultPopoverPresenter.setupPopoverCentered(onView: self.view, withPopover: keepPlayingPopoverVC, withWidth: 300, andHeight: 217, tapToExit: false)
        
        self.present(keepPlayingPopoverVC, animated: true)
    }
    
    // MARK: - IBActions
    
    @IBAction func endRoundButtonTapped(_ sender: Any) {
        guard let viewModel = viewModel,
              !viewModel.sortedPlayers.isEmpty else { return }
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let endRoundPopoverVC = storyboard.instantiateViewController(withIdentifier: "EndRoundPopoverViewController") as? EndRoundPopoverViewController else { fatalError("EndRoundPopoverViewController not instantiated")}
        
        let positionSortedPlayers = viewModel.sortedPlayers.sorted { $0.position < $1.position }
        
        let endRound = EndRound(withPlayers: positionSortedPlayers, roundNumber: viewModel.game.currentRound)
        endRoundPopoverVC.endRound = endRound
        
        endRoundPopoverVC.playerViewHeight = endRoundPopoverHeightHelper.playerViewHeight
        endRoundPopoverVC.playerSeparatorHeight = endRoundPopoverHeightHelper.playerSeperatorHeight
        endRoundPopoverVC.delegate = viewModel
        
        let height = endRoundPopoverHeightHelper.getPopoverHeightFor(playerCount: viewModel.sortedPlayers.count, andSafeAreaHeight: self.view.safeAreaFrame.height)
        defaultPopoverPresenter.setupPopoverCentered(onView: self.view, withPopover: endRoundPopoverVC, withWidth: 300, andHeight: height, tapToExit: true)
        
        self.present(endRoundPopoverVC, animated: true)
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
        guard let game = viewModel?.game else {
            fatalError("No viewModel game")
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let gameHistoryViewController = storyboard.instantiateViewController(withIdentifier: "GameHistoryViewController") as? GameHistoryViewController else {
            fatalError("GameHistoryViewController couldn't be made")
        }
        
        let viewModel = GameHistoryViewModel(game: game)
        gameHistoryViewController.viewModel = viewModel
        gameHistoryViewController.delegate = self.viewModel
        navigationController?.pushViewController(gameHistoryViewController, animated: true)
    }
    
    @objc func settingsButtonTapped() {
        guard let game = viewModel?.game else {
            fatalError("No viewModel game")
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let gameSettingsViewController = storyboard.instantiateViewController(withIdentifier: "GameSettingsViewController") as? GameSettingsViewController else {
            fatalError("GameSettingsViewController couldn't be made")
        }
        
        let viewModel = GameSettingsViewModel(game: game, delegate: viewModel)
        gameSettingsViewController.viewModel = viewModel
        
        navigationController?.pushViewController(gameSettingsViewController, animated: true)
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
