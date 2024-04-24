//
//  MyGamesTableViewDelegateDatasource.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/11/24.
//

import Foundation
import UIKit

class MyGamesTableViewDelegateDatasource: NSObject, UITableViewDataSource, UITableViewDelegate {
    var viewModel: MyGamesViewModelProtocol
    
    init(viewModel: MyGamesViewModelProtocol) {
        self.viewModel = viewModel
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return max(viewModel.activeGames.count, 1)
        case 1:
            return max(viewModel.pausedGames.count, 1)
        case 2:
            return max(viewModel.completedGames.count, 1)
        default:
            fatalError("Invalid section")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyGamesTableViewCell", for: indexPath) as? MyGamesTableViewCell else {
            fatalError("Couldn't find MyGamesTableViewCell")
        }
        
        var game: GameProtocol?
        switch indexPath.section {
        case 0:
            if viewModel.activeGames.indices.contains(indexPath.row) {
                game = viewModel.activeGames [indexPath.row]
            }
            
        case 1:
            if viewModel.pausedGames.indices.contains(indexPath.row) {
                game = viewModel.pausedGames [indexPath.row]
            }
            
        case 2:
            if viewModel.completedGames.indices.contains(indexPath.row) {
                game = viewModel.completedGames [indexPath.row]
            }
            
        default:
            fatalError("Invalid section")
        }
        
        if let game {
            cell.setupCellFor(game)
        } else {
            if indexPath.row == 0 {
                cell.setupNoGamesCell(for: GameStatus(rawValue: indexPath.section) ?? .active)
            } else {
                cell.setupErrorCell()
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRowAt(indexPath)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        switch indexPath.section {
        case 0:
            guard viewModel.activeGames.indices.contains(indexPath.row) else { return nil }
        case 1:
            guard viewModel.pausedGames.indices.contains(indexPath.row) else { return nil }
        case 2:
            guard viewModel.completedGames.indices.contains(indexPath.row) else { return nil }
        default:
            fatalError("Invalid section")
        }
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            self.viewModel.deleteGameAt(indexPath)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MyGamesTableViewHeaderView") as? MyGamesTableViewHeaderView else {
            fatalError("MyGamesTableViewHeaderView not found")
        }
        
        switch section {
        case 0:
            header.sectionTitleLabel.text = "Active Game"
        case 1:
            header.sectionTitleLabel.text = "Paused Games"
        case 2:
            header.sectionTitleLabel.text = "Completed Games"
        default:
            fatalError("Invalid section")
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}
