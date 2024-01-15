//
//  RootNavigationControllerTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 1/15/24.
//

import XCTest
@testable import Whats_The_Score

final class RootNavigationControllerTests: XCTestCase {

    func test_RootNavigationController_WhenViewDidLoadCalled_ShouldCallHideKeyboardWhenTappedAround() {
        
        class RootNavigationControllerHideKeyboardMock: RootNavigationController {
            var hideKeyboardWhenTappedAroundCalledCount = 0
            override func hideKeyboardWhenTappedAround() {
                hideKeyboardWhenTappedAroundCalledCount += 1
            }
        }
        
        // given
        let sut = RootNavigationControllerHideKeyboardMock()
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(sut.hideKeyboardWhenTappedAroundCalledCount, 1)
    }

}
