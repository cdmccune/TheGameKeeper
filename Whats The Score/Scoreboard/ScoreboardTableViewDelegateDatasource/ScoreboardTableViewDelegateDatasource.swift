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
        return viewModel.game.players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreboardTableViewCell", for: indexPath) as? ScoreboardTableViewCell else { fatalError("ScoreboardTableViewCell not found") }
        
        guard viewModel.game.players.indices.contains(indexPath.row) else {
            cell.setupCellForError()
            return cell
        }
        
        let player = viewModel.game.players[indexPath.row]
        cell.setupCellWith(player)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.startEditingPlayerScoreAt(indexPath.row)
    }
    
}
