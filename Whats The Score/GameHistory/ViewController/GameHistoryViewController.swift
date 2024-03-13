//
//  GameHistoryViewController.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/11/24.
//

import UIKit

class GameHistoryViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Properties
    
    private lazy var tableViewDelegate = GameHistoryTableViewDelegate(viewModel: viewModel)
    var viewModel: GameHistoryViewModelProtocol!
    lazy var defaultPopoverPresenter: DefaultPopoverPresenterProtocol = DefaultPopoverPresenter()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setDelegates()
        registerNibs()
        setBindings()
    }
    
    
    // MARK: - Private Functions
    
    private func setDelegates() {
        tableView.delegate = tableViewDelegate
        tableView.dataSource = tableViewDelegate
    }
    
    private func registerNibs() {
        tableView.register(UINib(nibName: "GameHistoryScoreChangeTableViewCell", bundle: nil), forCellReuseIdentifier: "GameHistoryScoreChangeTableViewCell")
        tableView.register(UINib(nibName: "GameHistoryEndRoundTableViewCell", bundle: nil), forCellReuseIdentifier: "GameHistoryEndRoundTableViewCell")
        tableView.register(UINib(nibName: "GameHistoryErrorTableViewCell", bundle: nil), forCellReuseIdentifier: "GameHistoryErrorTableViewCell")
    }
    
    
    // MARK: - Binding functionality
    
    private func presentEditPlayerScorePopoverWith(_ scoreChange: ScoreChange) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let editPlayerScoreVC = storyboard.instantiateViewController(withIdentifier: "ScoreboardPlayerEditScorePopoverViewController") as? ScoreboardPlayerEditScorePopoverViewController else { fatalError("ScoreboardPlayerEditScorePopoverViewController not instantiated")}
        
        
        editPlayerScoreVC.scoreChange = scoreChange
        editPlayerScoreVC.delegate = viewModel!
        
        defaultPopoverPresenter.setupPopoverCentered(onView: self.view, withPopover: editPlayerScoreVC, withWidth: 300, andHeight: 200, tapToExit: true)
        
        self.present(editPlayerScoreVC, animated: true)
    }
    
    
    // MARK: - Public Functions
    
    func setBindings() {
        viewModel.scoreChangeToEdit.valueChanged = { [weak self] scoreChange in
            guard let scoreChange = scoreChange else { return }
            
            self?.presentEditPlayerScorePopoverWith(scoreChange)
        }
    }
}
