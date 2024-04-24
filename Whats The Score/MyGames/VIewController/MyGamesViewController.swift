//
//  MyGamesViewController.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/11/24.
//

import UIKit

class MyGamesViewController: UIViewController, Storyboarded {
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Properties
    
    var viewModel: MyGamesViewModelProtocol!
    lazy var tableViewDelegate = MyGamesTableViewDelegateDatasource(viewModel: viewModel)
    
    
    // MARK: - Lifecycles

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setDelegates()
        registerNibs()
        setBindings()
    }
    
    
    // MARK: - Private Functions
    
    private func setupViews() {
        let myGamesAttributedString = NSMutableAttributedString(string: "My Games")
        myGamesAttributedString.addStrokeAttribute(strokeColor: .black, strokeWidth: 4.0)
        myGamesAttributedString.addTextColorAttribute(textColor: .white)
        titleLabel.attributedText = myGamesAttributedString
    }
    
    private func setDelegates() {
        self.tableView.delegate = tableViewDelegate
        self.tableView.dataSource = tableViewDelegate
    }
    
    private func registerNibs() {
        self.tableView.register(UINib(nibName: "MyGamesTableViewCell", bundle: nil), forCellReuseIdentifier: "MyGamesTableViewCell")
        self.tableView.register(UINib(nibName: "MyGamesTableViewHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "MyGamesTableViewHeaderView")
    }
    
    private func setBindings() {
        viewModel.shouldRefreshTableView.valueChanged = { [weak self] shouldReload in
            guard shouldReload ?? false else { return }
            self?.tableView.reloadData()
        }
    }
}
