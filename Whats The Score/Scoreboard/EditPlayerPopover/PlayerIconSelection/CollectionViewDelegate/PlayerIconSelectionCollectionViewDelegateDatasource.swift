//
//  PlayerIconSelectionCollectionViewDelegateDatasource.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/18/24.
//

import Foundation
import UIKit

class PlayerIconSelectionCollectionViewDelegateDatasource: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    init(viewModel: PlayerIconSelectionViewModelProtocol? = nil) {
        self.viewModel = viewModel
    }
    
    var viewModel: PlayerIconSelectionViewModelProtocol?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.icons.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayerIconSelectionCollectionViewCell", for: indexPath) as! PlayerIconSelectionCollectionViewCell
        
        guard viewModel?.icons.indices.contains(indexPath.row) ?? false,
              let icon = viewModel?.icons[indexPath.row] else {
            return cell
        }
        
        cell.setupCellForIcon(icon)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.iconSelectAt(row: indexPath.row)
    }
}
