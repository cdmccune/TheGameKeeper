//
//  EndGamePlayerCollectionViewDelegate.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/8/24.
//

import Foundation
import UIKit

class EndGamePlayerCollectionViewDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    init(viewModel: EndGameViewModelProtocol) {
        self.viewModel = viewModel
    }
    
    var viewModel: EndGameViewModelProtocol
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return max(1, viewModel.game.winningPlayers.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EndGamePlayerCollectionViewCell", for: indexPath) as? EndGamePlayerCollectionViewCell else {
            fatalError("Didn't register cell")
        }
        
        guard viewModel.game.winningPlayers.indices.contains(indexPath.row) else {
            cell.setupErrorCell()
            return cell
        }
        
        let player = viewModel.game.winningPlayers[indexPath.row]
        cell.setupViewFor(player)
        
        return cell
    }
}
