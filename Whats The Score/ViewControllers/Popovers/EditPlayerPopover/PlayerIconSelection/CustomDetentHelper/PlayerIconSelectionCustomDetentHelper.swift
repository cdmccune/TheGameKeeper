//
//  PlayerIconSelectionCustomDetentHelper.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/19/24.
//

import Foundation
import UIKit

protocol PlayerIconSelectionCustomDetentHelperProtocol {
    var viewModel: PlayerIconSelectionViewModelProtocol? { get set }
    var returnedHeight: CGFloat? { get set }
    func getCustomDetentFor(forScreenSize screenSize: CGSize) -> UISheetPresentationController.Detent
}

class PlayerIconSelectionCustomDetentHelper: PlayerIconSelectionCustomDetentHelperProtocol {
    var viewModel: PlayerIconSelectionViewModelProtocol?
    var returnedHeight: CGFloat?
    
    func getCustomDetentFor(forScreenSize screenSize: CGSize) -> UISheetPresentationController.Detent {
        
        let iconCount = viewModel?.icons.count ?? 0
        let labelAndSpacingHeight: CGFloat = 40
        let iconHeightAndWidth: CGFloat = 50
        let totalIconWidth: CGFloat = iconHeightAndWidth * CGFloat(iconCount) + CGFloat(10) * CGFloat(iconCount - 1)
        let numberOfRows: CGFloat = ceil(totalIconWidth / (screenSize.width - CGFloat(20)))
        
        let estimatedCollectionViewHeight = (numberOfRows*iconHeightAndWidth) + (CGFloat(10)*(numberOfRows - 1)) + labelAndSpacingHeight
        
        self.returnedHeight = estimatedCollectionViewHeight
        
        let identifier = UISheetPresentationController.Detent.Identifier("PlayerIconSelectionViewController")
        
        let customDetent = UISheetPresentationController.Detent.custom(identifier: identifier) { _ in
            return estimatedCollectionViewHeight
        }
        
        return customDetent
    }
}
