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
    
    
    // MARK: - Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.game.historySegments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard viewModel.game.historySegments.indices.contains(indexPath.row) else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GameHistoryErrorTableViewCell") ?? UITableViewCell()
            return cell
        }
        
        switch viewModel.game.historySegments[indexPath.row] {
        case .scoreChange(let scoreChange):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GameHistoryScoreChangeTableViewCell") as? GameHistoryScoreChangeTableViewCell else {
                fatalError("GameHistoryScoreChangeTableViewCell not registered")
            }
            
            cell.setupViewProperties(for: scoreChange)
            
            return cell
        case .endRound(let endRound):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GameHistoryEndRoundTableViewCell") as? GameHistoryEndRoundTableViewCell else {
                fatalError("GameHistoryEndRoundTableViewCell not registered")
            }
            
            cell.setupCellFor(round: endRound.roundNumber, and: endRound.scoreChangeArray)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let scoreChangeCellHeight: CGFloat = 44
        
        guard viewModel.game.historySegments.indices.contains(indexPath.row) else {
            return scoreChangeCellHeight
        }
        
        switch viewModel.game.historySegments[indexPath.row] {
            
        case .scoreChange(_):
            return scoreChangeCellHeight
        case .endRound(let endRound):
            return CGFloat(44 + (44*endRound.scoreChangeArray.count) - (endRound.scoreChangeArray.isEmpty ? 0 : 1))
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(indexPath.row)
    }
}
