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
    }
    
    private func setDelegates() {
        guard let _ = viewModel else { return }
        self.viewModel?.delegate = self
        
        let playerTableViewDelegate = PlayerSetupPlayerTableViewDelegate()
        self.playerTableViewDelegate = playerTableViewDelegate
        playerTableView.delegate = playerTableViewDelegate
        playerTableView.dataSource = playerTableViewDelegate
        
        let positionTableViewDelegate = PlayerSetupPositionTableViewDelegate()
        self.positionTableViewDelegate = positionTableViewDelegate
        positionTableView.delegate = positionTableViewDelegate
        positionTableView.dataSource = positionTableViewDelegate
        
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
    
}
