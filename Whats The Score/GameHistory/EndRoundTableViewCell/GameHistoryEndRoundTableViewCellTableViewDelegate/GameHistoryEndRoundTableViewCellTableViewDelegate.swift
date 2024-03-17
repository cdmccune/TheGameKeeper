//
//  GameHistoryEndRoundTableViewCellTableViewDelegate.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/12/24.
//

import Foundation
import UIKit

class GameHistoryEndRoundTableViewCellTableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Init
    
    init(viewModel: GameHistoryEndRoundTableViewCellViewModelProtocol) {
        self.viewModel = viewModel
    }
    

    // MARK: - Properties
    
    var viewModel: GameHistoryEndRoundTableViewCellViewModelProtocol
    
    
    // MARK: - Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.scoreChanges.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard viewModel.scoreChanges.indices.contains(indexPath.row),
              viewModel.totalScores.indices.contains(indexPath.row)
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GameHistoryErrorTableViewCell") ?? UITableViewCell()
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GameHistoryScoreChangeTableViewCell", for: indexPath) as? GameHistoryScoreChangeTableViewCell else {
            fatalError("GameHistoryScoreChangeTableViewCell wasn't registered")
        }
        
        let scoreChange = viewModel.scoreChanges[indexPath.row]
        let totalScore = viewModel.totalScores[indexPath.row]
        
        cell.setupViewProperties(for: scoreChange, isInRoundEnd: true, andTotalScore: totalScore)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
