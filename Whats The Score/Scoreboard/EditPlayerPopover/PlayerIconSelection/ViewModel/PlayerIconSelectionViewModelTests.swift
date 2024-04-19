//
//  PlayerIconSelectionViewTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 4/19/24.
//

import XCTest
@testable import Whats_The_Score

final class PlayerIconSelectionViewModelTests: XCTestCase {

    func test_PlayerIconSelectionViewModel_WhenIconSelectAtCalled_ShouldCallDelegateNewIconSelectedWithIcon() {
        // given
        let sut = PlayerIconSelectionViewModel()
        
        let delegate = PlayerIconSelectionDelegateMock()
        sut.delegate = delegate
        
        let randomIconIndex = Int.random(in: 0..<sut.icons.count)
        
        // when
        sut.iconSelectAt(row: randomIconIndex)
        
        // then
        XCTAssertEqual(delegate.newIconSelectedIcon, sut.icons[randomIconIndex])
        XCTAssertEqual(delegate.newIconSelectedCalledCount, 1)
    }

    func test_PlayerIconSelectionViewModel_WhenIconSelectedAtCalled_ShouldSetShouldDismissValueToTrue() {
        // given
        let sut = PlayerIconSelectionViewModel()
        
        let expectation = XCTestExpectation(description: "Should Dismiss value should be changed")
        
        sut.shouldDismiss.valueChanged = { shouldChange in
            expectation.fulfill()
            XCTAssertTrue(shouldChange ?? false)
        }
        
        // when
        sut.iconSelectAt(row: 0)
        wait(for: [expectation], timeout: 0.1)
        

    }
}
