//
//  NoAdaptivePresentationStylePopoverPresentationDelegateTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 2/6/24.
//

import XCTest
@testable import Whats_The_Score

final class NoAdaptivePresentationStylePopoverPresentationDelegateTests: XCTestCase {

    func test_NoAdaptivePresentationStylePopoverPresentationDelegate_WhenAdaptiveStyleForCalled_ShouldReturnNone() {
        // given
        let sut = NoAdaptivePresentationStylePopoverPresentationDelegate()
        
        // when
        let style = sut.adaptivePresentationStyle(for: UIPresentationController(presentedViewController: UIViewController(), presenting: nil))
        
        // then
        XCTAssertEqual(style, .none)
    }

}
