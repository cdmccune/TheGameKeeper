//
//  DismissingPopoverViewControllerTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 4/29/24.
//

import XCTest
@testable import Whats_The_Score

final class DismissingPopoverViewControllerTests: XCTestCase {
    
    func test_DismissingPopoverViewController_WhenDismissPopoverCalled_ShouldCallPopoverDismissed() {
        // Given
        let dismissingDelegateMock = PopoverDismissingDelegateMock()
        let sut = DismissingPopoverViewControllerMock()
        sut.dismissingDelegate = dismissingDelegateMock
        
        // When
        sut.dismissPopover()
        
        // Then
        XCTAssertEqual(dismissingDelegateMock.popoverDismissedCalledCount, 1, "popoverDismissed should be called on dismissingDelegate when dismiss is called")
    }
    
    func test_DismissingPopoverViewController_WhenDismissPopoverCalled_ShouldStillCallViewControllersDismissFunction() {
        class DismissingPopoverViewControllerDismissMock: DismissingPopoverViewControllerMock {
            var dismissCalledCount = 0
            override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
                dismissCalledCount += 1
            }
        }
        
        // given
        let sut = DismissingPopoverViewControllerDismissMock()
        
        // when
        sut.dismissPopover()
        
        // then
        XCTAssertEqual(sut.dismissCalledCount, 1)
    }
    
    // Mock class for PopoverDismissingDelegate
    class PopoverDismissingDelegateMock: PopoverDimissingDelegate {
        
        var maskView: UIView?
        
        var popoverDismissedCalledCount = 0
        func popoverDismissed() {
            popoverDismissedCalledCount += 1
        }
    }
    
    class DismissingPopoverViewControllerMock: UIViewController, DismissingPopoverViewController {
        var dismissingDelegate: Whats_The_Score.PopoverDimissingDelegate?
    }
    
}
