//
//  PlayerSetupViewController.swift
//  What's The Score
//
//  Created by Curt McCune on 1/2/24.
//

import UIKit

class PlayerSetupViewController: UIViewController, Storyboarded {
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var randomizeButton: UIButton!
    @IBOutlet weak var playerTableView: UITableView!
    @IBOutlet weak var tapToAddPlayerButton: UIButton!
    @IBOutlet weak var tableViewStackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var startGameButton: UIButton!
    
    
    // MARK: - Properties
    var viewModel: PlayerSetupViewModelProtocol?
    private var playerTableViewDelegate: PlayerSetupPlayerTableViewDelegate?
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDelegates()
        self.registerNibs()
    }
    
    private func setDelegates() {
        guard viewModel != nil else { return }
        self.viewModel?.delegate = self
        
        let playerTableViewDelegate = PlayerSetupPlayerTableViewDelegate(playerViewModel: viewModel!)
        self.playerTableViewDelegate = playerTableViewDelegate
        playerTableView.delegate = playerTableViewDelegate
        playerTableView.dataSource = playerTableViewDelegate
        
        playerTableView.dragDelegate = playerTableView
        playerTableView.dropDelegate = playerTableView
    }
    
    private func registerNibs() {
        playerTableView.register(UINib(nibName: "PlayerSetupPlayerTableViewCell", bundle: nil), forCellReuseIdentifier: "PlayerSetupPlayerTableViewCell")
    }
    
    
    // MARK: - IBActions
    
    @IBAction func tapToAddPlayerButtonTapped(_ sender: Any) {
        viewModel?.addPlayer()
    }
    
    @IBAction func randomizeButtonTapped(_ sender: Any) {
        viewModel?.randomizePlayers()
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        viewModel?.playersSetup()
    }
}

extension PlayerSetupViewController: PlayerSetupViewModelViewProtocol {
    func reloadTableViewCell(index: Int) {
        DispatchQueue.main.async {
            self.playerTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
    }
    
    func bindViewToViewModel(dispatchQueue: DispatchQueueProtocol) {
        dispatchQueue.async {
            
            switch self.viewModel?.players.count ?? 0 {
            case ..<2:
                self.instructionLabel.text = "You must add at least 2 players!"
                self.startGameButton.isEnabled = false
                self.randomizeButton.isHidden = true
            default:
                self.instructionLabel.text = "Tap, hold then drag players to reorder!"
                self.startGameButton.isEnabled = true
                self.randomizeButton.isHidden = false
            }
            
            
            self.playerTableView.reloadData()
            self.view.layoutIfNeeded()
            self.tableViewStackViewHeightConstraint.constant = self.playerTableView.contentSize.height
            self.view.layoutIfNeeded()
        }
    }
}
