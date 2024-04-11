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
            return viewModel.activeGames.count
        case 1:
            return viewModel.pausedGames.count
        case 2:
            return viewModel.completedGames.count
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
}
