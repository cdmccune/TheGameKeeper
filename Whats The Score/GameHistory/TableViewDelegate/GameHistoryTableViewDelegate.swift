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
        return viewModel.game.historySegments.count
    }
    
    
    // MARK: - CellForRowAt
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard viewModel.game.historySegments.indices.contains(indexPath.row) else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GameHistoryErrorTableViewCell") ?? UITableViewCell()
            return cell
        }
        
        switch viewModel.game.historySegments[indexPath.row] {
        case .scoreChange(let scoreChange, let player):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GameHistoryScoreChangeTableViewCell") as? GameHistoryScoreChangeTableViewCell else {
                fatalError("GameHistoryScoreChangeTableViewCell not registered")
            }
            
            cell.setupViewProperties(for: scoreChange, andPlayer: player)
            
            return cell
        case .endRound(let endRound, let players):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GameHistoryEndRoundTableViewCell") as? GameHistoryEndRoundTableViewCell else {
                fatalError("GameHistoryEndRoundTableViewCell not registered")
            }
            
            cell.setupCellFor(round: endRound.roundNumber, and: endRound.scoreChangeArray, andPlayers: players)
            
            return cell
        }
    }
    
    
    // MARK: - HeightForRowAt
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let scoreChangeCellHeight: CGFloat = 44
        
        guard viewModel.game.historySegments.indices.contains(indexPath.row) else {
            return scoreChangeCellHeight
        }
        
        switch viewModel.game.historySegments[indexPath.row] {
            
        case .scoreChange(_, _):
            return scoreChangeCellHeight
        case .endRound(let endRound, _):
            return CGFloat((44*endRound.scoreChangeArray.count) - (endRound.scoreChangeArray.isEmpty ? 0 : 1))
        }
    }
    
    
    // MARK: - DidSelectRowAt
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(indexPath.row)
    }
    
    
    // MARK: - trailingSwipeActions
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            self.viewModel.startDeletingHistorySegmentAt(indexPath.row)
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
