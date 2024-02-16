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
    
    // MARK: - Properties
    
    var viewModel: ScoreboardViewModelProtocol?
    private var tableViewDelegate: ScoreboardTableViewDelegateDatasource?
    var defaultPopoverPresenter: DefaultPopoverPresenterProtocol = DefaultPopoverPresenter()
    lazy var resetBarButton = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetButtonTapped))
    lazy var endRoundPopoverHeightHelper: EndRoundPopoverHeightHelperProtocol = EndRoundPopoverHeightHelper()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setDelegates()
        registerNibs()
        setBindings()
        setupViews()
    }
    
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
    }
    
    private func setupViews() {
        navigationItem.rightBarButtonItem = resetBarButton
        
        self.scoreSortButton.alpha = 1
        self.turnOrderSortButton.alpha = 0.5
    }
    
    private func editPlayerScore(for player: Player) {
        guard viewModel != nil else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let editPlayerScoreVC = storyboard.instantiateViewController(withIdentifier: "ScoreboardPlayerEditScorePopoverViewController") as? ScoreboardPlayerEditScorePopoverViewController else { fatalError("ScoreboardPlayerEditScorePopoverViewController not instantiated")}
        
        
        editPlayerScoreVC.player = player
        editPlayerScoreVC.delegate = viewModel!
        
        defaultPopoverPresenter.setupPopoverCentered(onView: self.view, withPopover: editPlayerScoreVC, withWidth: 300, andHeight: 200)
        
        self.present(editPlayerScoreVC, animated: true)
    }
    
    private func editPlayer(_ player: Player) {
        guard viewModel != nil else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let editPlayerVC = storyboard.instantiateViewController(withIdentifier: "EditPlayerPopoverViewController") as? EditPlayerPopoverViewController else { fatalError("EditPlayerPopoverViewController not instantiated")}
        
        
        editPlayerVC.player = player
        editPlayerVC.delegate = viewModel!
        
        defaultPopoverPresenter.setupPopoverCentered(onView: self.view, withPopover: editPlayerVC, withWidth: 300, andHeight: 180)
        
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
    
    // MARK: - IBActions
    
    @IBAction func endRoundButtonTapped(_ sender: Any) {
        guard let viewModel = viewModel,
              !viewModel.sortedPlayers.isEmpty else { return }
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let endRoundPopoverVC = storyboard.instantiateViewController(withIdentifier: "EndRoundPopoverViewController") as? EndRoundPopoverViewController else { fatalError("EndRoundPopoverViewController not instantiated")}
        
        
        endRoundPopoverVC.players = viewModel.sortedPlayers
        endRoundPopoverVC.round = viewModel.game.currentRound
        
        let height = endRoundPopoverHeightHelper.getPopoverHeightFor(playerCount: viewModel.sortedPlayers.count, andSafeAreaHeight: self.view.safeAreaFrame.height)
        defaultPopoverPresenter.setupPopoverCentered(onView: self.view, withPopover: endRoundPopoverVC, withWidth: 300, andHeight: height)
        
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
    
    
}

extension ScoreboardViewController: ScoreboardViewModelViewProtocol {
    func bindViewToViewModel(dispatchQueue: DispatchQueueProtocol) {
        dispatchQueue.async {
            guard let viewModel = self.viewModel else { return }
            let game = viewModel.game
            
            self.roundLabel.isHidden = game.gameType != .round
            self.roundLabel.text = "Round \(game.currentRound)"
            
            self.filterButtonStackView.isHidden = game.gameType == .basic
            
            self.tableView.reloadData()
        }
    }
}
