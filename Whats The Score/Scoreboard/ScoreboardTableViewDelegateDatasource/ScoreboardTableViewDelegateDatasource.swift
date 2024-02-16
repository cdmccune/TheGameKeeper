//
//  ScoreboardTableViewDelegateDatasource.swift
//  Whats The Score
//
//  Created by Curt McCune on 1/24/24.
//

import Foundation
import UIKit

class ScoreboardTableViewDelegateDatasource: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Setup
    
    init(viewModel: ScoreboardViewModelProtocol) {
        self.viewModel = viewModel
    }
    
    var viewModel: ScoreboardViewModelProtocol
    
    
    // MARK: - Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sortedPlayers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreboardTableViewCell", for: indexPath) as? ScoreboardTableViewCell else { fatalError("ScoreboardTableViewCell not found") }
        
        guard viewModel.sortedPlayers.indices.contains(indexPath.row) else {
            cell.setupCellForError()
            return cell
        }
        
        let player = viewModel.sortedPlayers[indexPath.row]
        cell.setupCellWith(player)
        cell.editPlayer = {
            self.viewModel.startEditingPlayerAt(indexPath.row)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.startEditingPlayerScoreAt(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            self.viewModel.startDeletingPlayerAt(indexPath.row)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}
