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
    
    func test_NoAdaptivePresentationStylePopoverPresentationDelegate_WhenInitializedWithTapToExitFalse_ShouldReturnFalseForPresentationControllerShouldDismiss() {
        // given
        let sut = NoAdaptivePresentationStylePopoverPresentationDelegate(tapToExit: false)
        
        // when
        let bool = sut.presentationControllerShouldDismiss(UIPresentationController(presentedViewController: UIViewController(), presenting: nil))
        
        // then
        XCTAssertFalse(bool)
    }
    
    func test_NoAdaptivePresentationStylePopoverPresentationDelegate_WhenInitializedWith_ShouldReturnTrueForPresentationControllerShouldDismiss() {
        // given
        let sut = NoAdaptivePresentationStylePopoverPresentationDelegate()
        
        // when
        let bool = sut.presentationControllerShouldDismiss(UIPresentationController(presentedViewController: UIViewController(), presenting: nil))
        
        // then
        XCTAssertTrue(bool)
    }

}
