//
//  EndRoundPopoverHeightHelper.swift
//  Whats The Score
//
//  Created by Curt McCune on 2/16/24.
//

import Foundation

protocol EndRoundPopoverHeightHelperProtocol {
    var playerViewHeight: Int {get set}
    var playerSeperatorHeight: Int {get set}
    func getPopoverHeightFor(playerCount: Int, andSafeAreaHeight safeAreaHeight: CGFloat) -> CGFloat
}

struct EndRoundPopoverHeightHelper: EndRoundPopoverHeightHelperProtocol {
    var playerViewHeight: Int
    var playerSeperatorHeight: Int
    func getPopoverHeightFor(playerCount: Int, andSafeAreaHeight safeAreaHeight: CGFloat) -> CGFloat {
        let contentHeight = CGFloat(99 + (playerCount * playerViewHeight) + playerSeperatorHeight * (playerCount - 1))
        return min(safeAreaHeight - 40, contentHeight)
    }
}
