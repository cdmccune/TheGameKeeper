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
    
    // MARK: - Properties
    
    var viewModel: ScoreboardViewModelProtocol?
    private var tableViewDelegate: ScoreboardTableViewDelegateDatasource?
    var defaultPopoverPresenter: DefaultPopoverPresenterProtocol = DefaultPopoverPresenter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setDelegates()
        registerNibs()
        setBindings()
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
        
        viewModel?.sortPreference.valueChanged = { [weak self] _ in
            self?.tableView.reloadData()
        }
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
    

    // MARK: - IBActions
    
    @IBAction func endRoundButtonTapped(_ sender: Any) {
        viewModel?.endCurrentRound()
    }
    
    @IBAction func endGameButtonTapped(_ sender: Any) {
        viewModel?.endGame()
    }
    
    @IBAction func addPlayerTapped(_ sender: Any) {
        viewModel?.addPlayer()
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
