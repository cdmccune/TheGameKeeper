//
//  ScoreboardViewController.swift
//  Whats The Score
//
//  Created by Curt McCune on 1/18/24.
//

import UIKit

class ScoreboardViewController: UIViewController, Storyboarded {

    // MARK: - Outlets
    
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var filterButtonStackView: UIStackView!
    @IBOutlet weak var turnOrderSortButton: UIButton!
    @IBOutlet weak var scoreSortButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addPlayerButton: UIButton!
    
    @IBOutlet weak var endRoundButton: UIButton!
    @IBOutlet weak var endGameButton: UIButton!
    
    
    
    // MARK: - Properties
    
    var viewModel: ScoreboardViewModelProtocol?
    private var tableViewDelegate: ScoreboardTableViewDelegateDatasource?
    var defaultPopoverPresenter: DefaultPopoverPresenterProtocol = DefaultPopoverPresenter()
    lazy var historyBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(image: UIImage(named: "clockIcon"), style: .plain, target: self, action: #selector(historyButtonTapped))
        barButton.tintColor = .textColor
        return barButton
    }()
    
    lazy var settingsBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(image: UIImage(named: "gearIcon"), style: .plain, target: self, action: #selector(self.settingsButtonTapped))
        barButton.tintColor = .textColor
        return barButton
    }()

    
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
        navigationItem.rightBarButtonItems = [settingsBarButton, historyBarButton]
        
        self.scoreSortButton.alpha = 1
        self.turnOrderSortButton.alpha = 0.5
        
        addPlayerButton.underlineButtonForButtonStates(title: "Add Player", withTextSize: 15)
        endRoundButton.underlineButtonForButtonStates(title: "End Round", withTextSize: 22)
        endGameButton.underlineButtonForButtonStates(title: "End Game", withTextSize: 22)
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
            
            let attributedNameString = NSMutableAttributedString(string: game.name)
            attributedNameString.addStrokeAttribute(strokeColor: .black, strokeWidth: -4.0)
            attributedNameString.addTextColorAttribute(textColor: .white)
            self.gameNameLabel.attributedText = attributedNameString
            
            if game.isEndOfGame() {
                self.roundLabel.text = "Game Over"
            } else {
                self.roundLabel.text = "Round \(game.currentRound)"
            }
            
            self.filterButtonStackView.isHidden = game.gameType == .basic
            
            self.tableView.reloadData()
            
            guard game.gameType == .round,
                  game.gameEndType != .none else {
                self.progressLabel.isHidden = true
                return
            }
            
            self.progressLabel.isHidden = false
            
            guard !game.isEndOfGame() else {
                self.progressLabel.text = ""
                return
            }
            

            if game.gameEndType == .round {
                self.progressLabel.text = "\(game.numberOfRounds)"
                
                let numberOfRoundsLeft = game.numberOfRounds - (game.currentRound - 1)
                
                if numberOfRoundsLeft > 1 {
                    self.progressLabel.text = "\(numberOfRoundsLeft) rounds left!"
                } else {
                    self.progressLabel.text = "Last round!"
                }
            } else if game.gameEndType == .score {
                self.progressLabel.text = "\(game.endingScore)"
                
                let pointsToWin = game.endingScore - (game.winningPlayers.first?.score ?? 0)
                let pointsOrPoint = pointsToWin > 1 ? "pts" : "pt"
                
                if game.winningPlayers.count == 1 {
                    let playerName = game.winningPlayers.first?.name ?? ""
                    
                    self.progressLabel.text = "\(playerName) needs \(pointsToWin) \(pointsOrPoint) to win!"
                } else {
                    self.progressLabel.text = "Multiple players need \(pointsToWin) \(pointsOrPoint) to win!"
                }
            }
        }
    }
}
