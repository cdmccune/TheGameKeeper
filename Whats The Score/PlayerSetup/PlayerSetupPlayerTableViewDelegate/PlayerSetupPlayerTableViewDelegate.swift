//
//  PlayerSetupPlayerTableViewDelegate.swift
//  What's The Score
//
//  Created by Curt McCune on 1/3/24.
//

import Foundation
import UIKit

class PlayerSetupPlayerTableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    init(playerSetupCoordinator: PlayerSetupPlayerCoordinator) {
        self.playerSetupCoordinator = playerSetupCoordinator
    }
    
    var playerSetupCoordinator: PlayerSetupPlayerCoordinator
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerSetupCoordinator.players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerSetupPlayerTableViewCell", for: indexPath) as? PlayerSetupPlayerTableViewCell else {
            fatalError("PlayerSetupPlayerTableViewCell wasn't found")
        }
            
        guard playerSetupCoordinator.players.indices.contains(indexPath.row) else {
            cell.playerTextField.text = "Error"
            return cell
        }
        
        let player = playerSetupCoordinator.players[indexPath.row]
        
        cell.playerNameChanged = {string in
            self.playerSetupCoordinator.playerNameChanged(withIndex: indexPath.row, toName: string)
        }
        
        cell.textFieldDelegate.hasDefaultName = player.hasDefaultName
        cell.playerTextField.text = player.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        playerSetupCoordinator.movePlayerAt(sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    // To remove the red delete button and indent
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        false
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .none
    }
}
