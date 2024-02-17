//
//  EndRoundPopoverViewController.swift
//  Whats The Score
//
//  Created by Curt McCune on 2/16/24.
//

import UIKit

class EndRoundPopoverViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Properties
    
    var players: [Player]?
    var round: Int?
    
    
    // MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()

        setDelegates()
        registerNibs()
        setupViews()
    }
    
    
    // MARK: - Private Functions
    
    private func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func registerNibs() {
        tableView.register(UINib(nibName: "EndRoundPopoverTableViewCell", bundle: nil), forCellReuseIdentifier: "EndRoundPopoverTableViewCell")
    }
    
    private func setupViews() {
        if let round {
            roundLabel.text = "Round \(round)"
        } else {
            roundLabel.text = "Round ???"
        }
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

extension EndRoundPopoverViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EndRoundPopoverTableViewCell", for: indexPath) as?  EndRoundPopoverTableViewCell else { fatalError("EndRoundPopoverTableViewCell wasn't registered")}
        
        guard let players,
              players.indices.contains(indexPath.row) else {
            cell.setupErrorCell()
            return cell
        }
        
        cell.setupViewProperties(for: players[indexPath.row])
        cell.textFieldDidChangeHandler = { scoreChange in
            self.players?[indexPath.row].score += scoreChange
        }
        
        return cell
    }
}
