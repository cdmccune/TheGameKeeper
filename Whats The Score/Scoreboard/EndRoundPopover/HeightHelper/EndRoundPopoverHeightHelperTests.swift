//
//  EndRoundPopoverHeightHelperTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 2/16/24.
//

import XCTest
@testable import Whats_The_Score

final class EndRoundPopoverHeightHelperTests: XCTestCase {

    func test_EndRoundPopoverHeightHelper_WhenSafeAreaHeightIsLargerThanContent_ShouldReturnFullContentSize() {
        // given
        
        let playerViewHeight = Int.random(in: 1...1000)
        let playerSeparatorHeight = Int.random(in: 1...1000)
        let sut = EndRoundPopoverHeightHelper(playerViewHeight: playerViewHeight, playerSeperatorHeight: playerSeparatorHeight)
        let playerCount = Int.random(in: 1...10)
        let safeAreaHeight: CGFloat = 100000
        
        // when
        let height = sut.getPopoverHeightFor(playerCount: playerCount, andSafeAreaHeight: safeAreaHeight)
        
        // then
        let expectedHeight = CGFloat(99 + (playerCount * playerViewHeight) + playerSeparatorHeight*(playerCount - 1))
        XCTAssertEqual(height, expectedHeight)
    }
    
    func test_EndRoundPopoverHeightHelper_WhenScreenHeightIsSmallerThanContent_ShouldReturnSafeAreaMinus40() {
        // given
        let sut = EndRoundPopoverHeightHelper(playerViewHeight: 100, playerSeperatorHeight: 100)
        let playerCount: Int = 10000
        let safeAreaHeight: CGFloat = 100
        
        // when
        let height = sut.getPopoverHeightFor(playerCount: playerCount, andSafeAreaHeight: safeAreaHeight)
        
        // then
        let expectedHeight = safeAreaHeight - 40
        XCTAssertEqual(height, expectedHeight)
        
    }

}

class EndRoundPopoverHeightHelperMock: EndRoundPopoverHeightHelperProtocol {
    var playerViewHeight: Int = 0
    var playerSeperatorHeight: Int = 0
    
    var heightToReturn: CGFloat?
    
    var getPopoverHeightForPlayerCount: Int?
    var getPopoverHeightForSafeAreaHeight: CGFloat?
    var getPopoverHeightForCalledCount = 0
    
    func getPopoverHeightFor(playerCount: Int, andSafeAreaHeight safeAreaHeight: CGFloat) -> CGFloat {
        getPopoverHeightForPlayerCount = playerCount
        getPopoverHeightForSafeAreaHeight = safeAreaHeight
        getPopoverHeightForCalledCount += 1
        return heightToReturn ?? 0
    }
}
