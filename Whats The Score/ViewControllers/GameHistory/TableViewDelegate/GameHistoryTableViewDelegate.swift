//
//  GameHistoryTableViewDelegate.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/11/24.
//

import Foundation
import UIKit

class GameHistoryTableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Init
    
    init(viewModel: GameHistoryViewModelProtocol) {
        self.viewModel = viewModel
    }
    
    
    // MARK: - Properties
    
    var viewModel: GameHistoryViewModelProtocol
    
    
    // MARK: - NumberOfRowsInSection
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let game = viewModel.game
        return game.gameType == .round ? game.endRounds.count : game.scoreChanges.count
    }
    
    
    // MARK: - CellForRowAt
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let game = viewModel.game
        let gameType = game.gameType
        
        guard gameType == .basic ? game.scoreChanges.indices.contains(indexPath.row) : game.endRounds.indices.contains(indexPath.row) else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GameHistoryErrorTableViewCell") ?? UITableViewCell()
            return cell
        }
        
        switch gameType {
        case .basic:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GameHistoryScoreChangeTableViewCell") as? GameHistoryScoreChangeTableViewCell else {
                fatalError("GameHistoryScoreChangeTableViewCell not registered")
            }
            cell.setupViewProperties(for: game.scoreChanges[indexPath.row])
            
            return cell
        case .round:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GameHistoryEndRoundTableViewCell") as? GameHistoryEndRoundTableViewCell else {
                fatalError("GameHistoryEndRoundTableViewCell not registered")
            }
            
            let endRound = game.endRounds[indexPath.row]
            cell.setupCellFor(round: endRound.roundNumber, and: endRound.scoreChanges)
            
            return cell
        }
    }
    
    
    // MARK: - HeightForRowAt
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let scoreChangeCellHeight: CGFloat = 44
        
        let game = viewModel.game
        let gameType = game.gameType
        
        guard gameType == .basic ? game.scoreChanges.indices.contains(indexPath.row) : game.endRounds.indices.contains(indexPath.row) else {
            return scoreChangeCellHeight
        }
        
        switch gameType {
        case .basic:
            return scoreChangeCellHeight
        case .round:
            let scoreChangeArray = game.endRounds[indexPath.row].scoreChanges
            return CGFloat((44*scoreChangeArray.count) - (scoreChangeArray.isEmpty ? 0 : 1))
        }
    }
    
    
    // MARK: - DidSelectRowAt
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(indexPath.row)
    }
    
    
    // MARK: - trailingSwipeActions
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            self.viewModel.startDeletingRowAt(indexPath.row)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    
    // MARK: - ViewForHeaderInSection
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "GameHistoryTableViewHeaderView") as? GameHistoryTableViewHeaderView else {
            fatalError("GameHistoryTableViewHeaderViewMock not found")
        }
        
        header.setupViews(isRoundBasedGame: viewModel.game.gameType == .round)
        
        return header
    }
    
    
    // MARK: - HeightForHeaderInSection
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        44
    }
}
