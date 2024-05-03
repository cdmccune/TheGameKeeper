//
//  GameHistoryViewController.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/11/24.
//

import UIKit

class GameHistoryViewController: UIViewController, Storyboarded {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
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
        setupViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        delegate?.updateFromHistory()
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
        tableView.register(UINib(nibName: "GameHistoryTableViewHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "GameHistoryTableViewHeaderView")
    }
    
    
    // MARK: - Binding functionality
    
    private func presentDeleteAlertController(index: Int) {
        let alert = UIAlertController(title: "Are you sure you want to delete this score change?", message: "This will erase this data and update the score of any affected player", preferredStyle: .alert)
        
        let cancelAction = TestableUIAlertAction.createWith(title: "Cancel", style: .cancel) { _ in }
        let deleteAction = TestableUIAlertAction.createWith(title: "Delete", style: .destructive) { _ in
            self.viewModel.deleteRowAt(index)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        self.present(alert, animated: true)
    }
    
    private func setupViews() {
        let historyAttributedString = NSMutableAttributedString(string: "History")
        historyAttributedString.addStrokeAttribute(strokeColor: .black, strokeWidth: 4.0)
        titleLabel.attributedText = historyAttributedString
    }
    
    
    // MARK: - Public Functions
    
    func setBindings() {
        
        viewModel.shouldRefreshTableView.valueChanged = { [weak self] shouldRefresh in
            guard shouldRefresh ?? false else { return }
            
            self?.tableView.reloadData()
        }
        
        viewModel.shouldShowDeleteSegmentWarningIndex.valueChanged = { [weak self] index in
            guard let index else { return }
            
            self?.presentDeleteAlertController(index: index)
        }
    }
}
