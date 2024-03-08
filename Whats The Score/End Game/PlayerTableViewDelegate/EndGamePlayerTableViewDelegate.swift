//
//  EndGamePlayerTableViewDelegate.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/8/24.
//

import Foundation
import UIKit

class EndGamePlayerTableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    init(viewModel: EndGameViewModelProtocol) {
        self.viewModel = viewModel
    }
    
    var viewModel: EndGameViewModelProtocol
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(1, viewModel.losingPlayers.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EndGamePlayerTableViewCell", for: indexPath) as?  EndGamePlayerTableViewCell else {
            fatalError("Couldn't find EndGamePlayerTableViewCell")
        }
        
        guard viewModel.losingPlayers.indices.contains(indexPath.row) else {
            if indexPath.row == 0 {
                cell.setupNoLosingPlayers()
            } else {
                cell.setupErrorCell()
            }
            return cell
        }
        
        let player = viewModel.losingPlayers[indexPath.row]
        cell.setupViewFor(player)

        return cell
    }
}
