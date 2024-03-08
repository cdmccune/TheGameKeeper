//
//  EndGameViewController.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/1/24.
//

import UIKit

class EndGameViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Properties
    
    private lazy var tableViewDelegate = EndGamePlayerTableViewDelegate(viewModel: viewModel)
    var viewModel: EndGameViewModelProtocol!
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setDelegates()
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - Private Functions
    
    private func setDelegates() {
        tableView.delegate = tableViewDelegate
        tableView.dataSource = tableViewDelegate
    }
}
