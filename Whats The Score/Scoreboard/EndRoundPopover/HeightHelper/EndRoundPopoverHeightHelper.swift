//
//  EndRoundPopoverHeightHelper.swift
//  Whats The Score
//
//  Created by Curt McCune on 2/16/24.
//

import Foundation

protocol EndRoundPopoverHeightHelperProtocol {
    func getPopoverHeightFor(playerCount: Int, andSafeAreaHeight safeAreaHeight: CGFloat) -> CGFloat
}

struct EndRoundPopoverHeightHelper: EndRoundPopoverHeightHelperProtocol {
    func getPopoverHeightFor(playerCount: Int, andSafeAreaHeight safeAreaHeight: CGFloat) -> CGFloat {
        let contentHeight = CGFloat(90 + (playerCount * 45) + (playerCount - 1))
        return min(safeAreaHeight - 40, contentHeight)
    }
}
