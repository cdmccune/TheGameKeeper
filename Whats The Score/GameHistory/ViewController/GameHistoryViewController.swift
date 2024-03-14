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
    var delegate: GameHistoryViewControllerDelegate?
    
    lazy var defaultPopoverPresenter: DefaultPopoverPresenterProtocol = DefaultPopoverPresenter()
    lazy var endRoundPopoverHeightHelper: EndRoundPopoverHeightHelperProtocol = EndRoundPopoverHeightHelper(playerViewHeight: 45, playerSeperatorHeight: 3)
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setDelegates()
        registerNibs()
        setBindings()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        delegate?.update(viewModel.game)
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
    
    private func presentEndRoundPopoverWith(_ endRound: EndRound) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let endRoundPopoverVC = storyboard.instantiateViewController(withIdentifier: "EndRoundPopoverViewController") as? EndRoundPopoverViewController else { fatalError("EndRoundPopoverViewController not instantiated")}
        
        #warning("Write a test for these being set before the default popover presenter")
        
        endRoundPopoverVC.endRound = endRound
        endRoundPopoverVC.playerViewHeight = endRoundPopoverHeightHelper.playerViewHeight
        endRoundPopoverVC.playerSeparatorHeight = endRoundPopoverHeightHelper.playerSeperatorHeight
        endRoundPopoverVC.delegate = viewModel
        
        let height = endRoundPopoverHeightHelper.getPopoverHeightFor(playerCount: endRound.scoreChangeArray.count, andSafeAreaHeight: self.view.safeAreaFrame.height)
        defaultPopoverPresenter.setupPopoverCentered(onView: self.view, withPopover: endRoundPopoverVC, withWidth: 300, andHeight: height, tapToExit: true)
        
        self.present(endRoundPopoverVC, animated: true)
    }
    
    
    // MARK: - Public Functions
    
    func setBindings() {
        viewModel.scoreChangeToEdit.valueChanged = { [weak self] scoreChange in
            guard let scoreChange else { return }
            
            self?.presentEditPlayerScorePopoverWith(scoreChange)
        }
        
        viewModel.endRoundToEdit.valueChanged = { [weak self] endRound in
            guard let endRound else { return }
            
            self?.presentEndRoundPopoverWith(endRound)
        }
        
        viewModel.tableViewIndexToRefresh.valueChanged = { [weak self] rowIndex in
            guard let rowIndex else { return }
            
            self?.tableView.reloadRows(at: [IndexPath(row: rowIndex, section: 0)], with: .automatic)
        }
    }
}
