//
//  PlayerSetupPositionTableViewDelegate.swift
//  What's The Score
//
//  Created by Curt McCune on 1/3/24.
//

import Foundation
import UIKit

class PlayerSetupPositionTableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    init(playerSetupCoordinator: PlayerSetupPlayerCoordinator) {
        self.playerSetupCoordinator = playerSetupCoordinator
    }
    
    var playerSetupCoordinator: PlayerSetupPlayerCoordinator
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerSetupCoordinator.players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerSetupPositionTableViewCell", for: indexPath) as! PlayerSetupPositionTableViewCell
        cell.numberLabel.text = String(indexPath.row + 1)
        
        return cell
    }
}
