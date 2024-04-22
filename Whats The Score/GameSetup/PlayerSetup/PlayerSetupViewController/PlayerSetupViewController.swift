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
    @IBOutlet weak var randomizeButton: UIButton!
    @IBOutlet weak var playerTableView: UITableView!
    @IBOutlet weak var tapToAddPlayerButton: UIButton!
    @IBOutlet weak var tableViewStackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var startGameButton: UIButton!
    
    lazy var startBarButton = UIBarButtonItem(title: "Start", style: .done, target: self, action: #selector(startBarButtonTapped))
    
    
    // MARK: - Properties
    var viewModel: PlayerSetupViewModelProtocol?
    private var playerTableViewDelegate: PlayerSetupPlayerTableViewDelegate?
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDelegates()
        self.registerNibs()
        self.setProgrammaticViewProperties()
    }
    
    private func setDelegates() {
        guard viewModel != nil else { return }
        self.viewModel?.delegate = self
        
        let playerTableViewDelegate = PlayerSetupPlayerTableViewDelegate(playerViewModel: viewModel!)
        self.playerTableViewDelegate = playerTableViewDelegate
        playerTableView.delegate = playerTableViewDelegate
        playerTableView.dataSource = playerTableViewDelegate
        
        playerTableView.isEditing = true
    }
    
    private func registerNibs() {
        playerTableView.register(UINib(nibName: "PlayerSetupPlayerTableViewCell", bundle: nil), forCellReuseIdentifier: "PlayerSetupPlayerTableViewCell")
    }

    
    private func setProgrammaticViewProperties() {
        self.navigationItem.rightBarButtonItem = startBarButton
    }
    
    // MARK: - IBActions
    
    @IBAction func tapToAddPlayerButtonTapped(_ sender: Any) {
        viewModel?.addPlayer()
    }
    
    @IBAction func randomizeButtonTapped(_ sender: Any) {
        viewModel?.randomizePlayers()
    }
    
    @objc func startBarButtonTapped() {
        viewModel?.playersSetup()
    }
}

extension PlayerSetupViewController: PlayerSetupViewModelViewProtocol {
    func reloadTableViewCell(index: Int) {
        DispatchQueue.main.async {
            self.playerTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
    }
    
    func bindViewToViewModel() {
        DispatchQueue.main.async {
            self.playerTableView.reloadData()
            self.view.layoutIfNeeded()
            self.tableViewStackViewHeightConstraint.constant = self.playerTableView.contentSize.height
            self.view.layoutIfNeeded()
        }
    }
}
