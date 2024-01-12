//
//  PlayerSetupViewController.swift
//  What's The Score
//
//  Created by Curt McCune on 1/2/24.
//

import UIKit

class PlayerSetupViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var randomizeButton: UIButton!
    @IBOutlet weak var playerTableView: UITableView!
    @IBOutlet weak var positionTableView: UITableView!
    
    
    //MARK: - Properties
    var viewModel: PlayerSetupViewModel?
    private var playerTableViewDelegate: PlayerSetupPlayerTableViewDelegate?
    private var positionTableViewDelegate: PlayerSetupPositionTableViewDelegate?
    
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDelegates()
        self.registerNibs()
        self.setTableViewFunctionality()
    }
    
    private func setDelegates() {
        guard let _ = viewModel else { return }
        self.viewModel?.delegate = self
        
        let playerTableViewDelegate = PlayerSetupPlayerTableViewDelegate(playerSetupCoordinator: viewModel!)
        self.playerTableViewDelegate = playerTableViewDelegate
        playerTableView.delegate = playerTableViewDelegate
        playerTableView.dataSource = playerTableViewDelegate
        
        let positionTableViewDelegate = PlayerSetupPositionTableViewDelegate(playerSetupCoordinator: viewModel!)
        self.positionTableViewDelegate = positionTableViewDelegate
        positionTableView.delegate = positionTableViewDelegate
        positionTableView.dataSource = positionTableViewDelegate
        
    }
    
    private func registerNibs() {
        playerTableView.register(UINib(nibName: "PlayerSetupPlayerTableViewCell", bundle: nil), forCellReuseIdentifier: "PlayerSetupPlayerTableViewCell")
        positionTableView.register(UINib(nibName: "PlayerSetupPositionTableViewCell", bundle: nil), forCellReuseIdentifier: "PlayerSetupPositionTableViewCell")
    }
    
    private func setTableViewFunctionality() {
        playerTableView.isEditing = true
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PlayerSetupViewController: PlayerSetupViewModelProtocol {
    func reloadTableViewCell(index: Int) {
        DispatchQueue.main.async {
            self.playerTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
    }
    
    func bindViewToViewModel() {
        DispatchQueue.main.async {
            self.playerTableView.reloadData()
            self.positionTableView.reloadData()
        }
    }
}
