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

    func test_NoAdaptivePresentationStylePopoverPresentationDelegate_WhenPresentationControllerWillDismissCalled_ShouldSetMaskViewToNil() {
        // given
        let sut = NoAdaptivePresentationStylePopoverPresentationDelegate()
        sut.maskView = UIView() // Initially set a mask view
        
        // when
        sut.presentationControllerWillDismiss(UIPresentationController(presentedViewController: UIViewController(), presenting: nil))
        
        // then
        XCTAssertNil(sut.maskView, "Mask view should be nil after presentationControllerWillDismiss is called")
    }

    func test_NoAdaptivePresentationStylePopoverPresentationDelegate_WhenPresentationControllerDidDismissCalled_ShouldRemoveMaskViewFromSuperview() {
        // given
        let sut = NoAdaptivePresentationStylePopoverPresentationDelegate()
        let mask = UIViewRemoveFromSuperviewMock()
        sut.maskView = mask // Initially set a mask view
        
        // when
        sut.presentationControllerWillDismiss(UIPresentationController(presentedViewController: UIViewController(), presenting: nil))
        
        // then
        XCTAssertEqual(mask.removeFromSuperviewCalledCount, 1, "Mask view should have been removed from superview once")
    }


    // MARK: - Popover Dismissed

    func test_NoAdaptivePresentationStylePopoverPresentationDelegate_WhenPopoverDismissedCalled_ShouldSetMaskViewToNil() {
        // given
        let sut = NoAdaptivePresentationStylePopoverPresentationDelegate()
        sut.maskView = UIView() // Initially set a mask view
        
        // when
        sut.popoverDismissed()
        
        // then
        XCTAssertNil(sut.maskView, "Mask view should be nil after popoverDismissed is called")
    }

    func test_NoAdaptivePresentationStylePopoverPresentationDelegate_WhenPopoverDismissedCalled_ShouldRemoveMaskViewFromSuperview() {
        // given
        let sut = NoAdaptivePresentationStylePopoverPresentationDelegate()
        let mask = UIViewRemoveFromSuperviewMock()
        sut.maskView = mask // Initially set a mask view
        
        // when
        sut.popoverDismissed()
        
        // then
        XCTAssertEqual(mask.removeFromSuperviewCalledCount, 1, "Mask view should have been removed from superview once after popoverDismissed is called")
    }
}
