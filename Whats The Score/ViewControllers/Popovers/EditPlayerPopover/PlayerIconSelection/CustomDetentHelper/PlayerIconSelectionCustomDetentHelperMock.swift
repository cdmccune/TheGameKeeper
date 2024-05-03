//
//  PlayerIconSelectionCustomDetentHelperMock.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 4/19/24.
//

import Foundation
import UIKit
@testable import Whats_The_Score

class PlayerIconSelectionCustomDetentHelperMock: PlayerIconSelectionCustomDetentHelperProtocol {
    var viewModel: Whats_The_Score.PlayerIconSelectionViewModelProtocol?
    var returnedHeight: CGFloat?
    
    var detentToReturn: UISheetPresentationController.Detent = .medium()
    var getCustomDetentForCalledCount = 0
    func getCustomDetentFor(forScreenSize screenSize: CGSize) -> UISheetPresentationController.Detent {
        getCustomDetentForCalledCount += 1
        
        return detentToReturn
    }
}
