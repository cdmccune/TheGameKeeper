//
//  DefaultPopoverPresenterTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 2/6/24.
//

import XCTest
@testable import Whats_The_Score

final class DefaultPopoverPresenterTests: XCTestCase {

    // MARK: - GetCenteredRect

    func test_DefaultPopoverPresenter_WhenGetCenteredRectCalled_ShouldReturnRectWithRectCenteredOnView() {
        // given
        let viewHeight = CGFloat.random(in: 1...1000)
        let viewWidth = CGFloat.random(in: 1...1000)
        let viewFrame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
        let view = UIView(frame: viewFrame)
        
        let sut = DefaultPopoverPresenter()
        
        // when
        let rectWidth = CGFloat.random(in: 1...1000)
        let rectHeight = CGFloat.random(in: 1...1000)
        let resultRect = sut.getCenteredRectWith(onView: view, withWidth: rectWidth, andHeight: rectHeight)
        
        // then
        let goalRect = CGRect(x: viewWidth/2 - rectWidth/2, y: viewHeight/2 - rectHeight/2, width: rectWidth, height: rectHeight)
        XCTAssertEqual(goalRect, resultRect)
    }
    
    
    // MARK: - SetupPopoverCentered
    
    func test_DefaultPopoverPresenter_WhenSetupPopoverCenteredCalled_ShouldSetViewControllersModalPresentationStyleToPopover() {
        // given
        let sut = DefaultPopoverPresenter()
        let popoverViewController = DismissingPopoverViewControllerMock()
        
        // when
        sut.setupPopoverCentered(onView: UIView(), withPopover: popoverViewController, withWidth: 0, andHeight: 0)
        
        // then
        XCTAssertEqual(popoverViewController.modalPresentationStyle, .popover)
    }
    
    func test_DefaultPopoverPresenter_WhenSetupPopoverCenteredCalled_ShouldSetViewControllersPopoverPresentationControllerPermittedArrowDirectionToZero() {
        // given
        let sut = DefaultPopoverPresenter()
        let popoverViewController = DismissingPopoverViewControllerMock()
        
        // when
        sut.setupPopoverCentered(onView: UIView(), withPopover: popoverViewController, withWidth: 0, andHeight: 0)
        
        // then
        XCTAssertEqual(popoverViewController.popoverPresentationController?.permittedArrowDirections, UIPopoverArrowDirection(rawValue: 0))
    }
    
    func test_DefaultPopoverPresenter_WhenSetupPopoverCenteredCalled_ShouldSetViewControllersPopoverPresentationSourceViewToViewControllersView() {
        // given
        let view = UIView()
        let sut = DefaultPopoverPresenter()
        let popoverViewController = DismissingPopoverViewControllerMock()
        
        // when
        sut.setupPopoverCentered(onView: view, withPopover: popoverViewController, withWidth: 0, andHeight: 0)
        
        // then
        XCTAssertEqual(popoverViewController.popoverPresentationController?.sourceView, view)
    }
    
    func test_DefaultPopoverPresenter_WhenSetupPopoverCenteredCalled_ShouldSetViewControllersPopoverPresentationSourceRectToCorrectRect() {

        
        // given
        let viewHeight = CGFloat.random(in: 1...1000)
        let viewWidth = CGFloat.random(in: 1...1000)
        let viewFrame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
        let view = UIView(frame: viewFrame)
        
        let sut = DefaultPopoverPresenter()
        
        let popoverViewController = DismissingPopoverViewControllerMock()
        
        let rectWidth = CGFloat.random(in: 1...1000)
        let rectHeight = CGFloat.random(in: 1...1000)
        
        // when
        sut.setupPopoverCentered(onView: view, withPopover: popoverViewController, withWidth: rectWidth, andHeight: rectHeight)
        
        // then
        let goalRect = CGRect(x: viewWidth/2 - rectWidth/2, y: viewHeight/2 - rectHeight/2, width: rectWidth, height: rectHeight)
        XCTAssertEqual(popoverViewController.popoverPresentationController?.sourceRect, goalRect)
    }
    
    func test_DefaultPopoverPresenter_WhenSetupPopoverCenteredCalled_ShouldSetViewControllersPreferredContentSizeToHeightAndWidth() {
        // given
        let sut = DefaultPopoverPresenter()
        let width = CGFloat.random(in: 1...1000)
        let height = CGFloat.random(in: 1...1000)
        
        let popoverViewController = DismissingPopoverViewControllerMock()
        
        // when
        sut.setupPopoverCentered(onView: UIView(), withPopover: popoverViewController, withWidth: width, andHeight: height)
        
        // then
        let goalSize = CGSize(width: width, height: height)
        XCTAssertEqual(popoverViewController.preferredContentSize, goalSize)
    }
    
    func test_DefaultPopoverPresenter_WhenSetupPopoverCenteredCalledTapToExitTrue_ShouldSetViewControllersPopoverPresentationControllerDelegateToNoAdaptivePresentationStylePopoverPresentationDelegateTapToExitTrue() {
        // given
        let sut = DefaultPopoverPresenter()
        let popoverViewController = DismissingPopoverViewControllerMock()
        
        // when
        sut.setupPopoverCentered(onView: UIView(), withPopover: popoverViewController, withWidth: 0, andHeight: 0, tapToExit: true)
        
        // then
        XCTAssertTrue(popoverViewController.popoverPresentationController?.delegate is NoAdaptivePresentationStylePopoverPresentationDelegate)
        XCTAssertTrue((popoverViewController.popoverPresentationController?.delegate as? NoAdaptivePresentationStylePopoverPresentationDelegate)?.tapToExit ?? false)
    }
    
    func test_DefaultPopoverPresenter_WhenSetupPopoverCenteredCalledTapToExitFalse_ShouldSetViewControllersPopoverPresentationControllerDelegateToNoAdaptivePresentationStylePopoverPresentationDelegateTapToExitFalse() {
        // given
        let sut = DefaultPopoverPresenter()
        let popoverViewController = DismissingPopoverViewControllerMock()
        
        // when
        sut.setupPopoverCentered(onView: UIView(), withPopover: popoverViewController, withWidth: 0, andHeight: 0, tapToExit: false)
        
        // then
        XCTAssertTrue(popoverViewController.popoverPresentationController?.delegate is NoAdaptivePresentationStylePopoverPresentationDelegate)
        XCTAssertFalse((popoverViewController.popoverPresentationController?.delegate as? NoAdaptivePresentationStylePopoverPresentationDelegate)?.tapToExit ?? true)
    }
    
    func test_DefaultPopoverPresenter_WhenSetupPopoverCenteredCalled_ShouldCallHideKeyboardWhenTappedAroundOnViewController() {
        
        class UIViewControllerHideKeyboardWhenTappedAround: DismissingPopoverViewControllerMock {
            var hideKeyboardWhenTappedAroundCalledCount = 0
            override func hideKeyboardWhenTappedAround() {
                hideKeyboardWhenTappedAroundCalledCount += 1
            }
        }
        // given
        let sut = DefaultPopoverPresenter()
        let popoverViewController = UIViewControllerHideKeyboardWhenTappedAround()
        
        // when
        sut.setupPopoverCentered(onView: UIView(), withPopover: popoverViewController, withWidth: 0, andHeight: 0)
        
        // then
        XCTAssertEqual(popoverViewController.hideKeyboardWhenTappedAroundCalledCount, 1)
    }
    func test_DefaultPopoverPresenter_WhenSetupPopoverCenteredCalled_ShouldAddMaskToParentViewWithAlpha() {
        // given
        let sut = DefaultPopoverPresenter()
        let popoverViewController = DismissingPopoverViewControllerMock()
        let parentView = UIView(frame: UIScreen.main.bounds) // Use the whole screen bounds
        
        // when
        sut.setupPopoverCentered(onView: parentView, withPopover: popoverViewController, withWidth: 100, andHeight: 100)
        
        // then
        guard let maskView = parentView.mask else {
            XCTFail("No mask view with alpha found on parent view")
            return
        }
        XCTAssertEqual(maskView.backgroundColor, UIColor.black.withAlphaComponent(0.5))
        XCTAssertEqual(maskView.frame, UIScreen.main.bounds) // Check if the mask view covers the whole screen
    }

    func test_DefaultPopoverPresenter_WhenSetupPopoverCenteredCalled_ShouldSetDelegateMaskViewToCreatedMaskView() {
        // given
        let sut = DefaultPopoverPresenter()
        let popoverViewController = DismissingPopoverViewControllerMock()
        let parentView = UIView(frame: UIScreen.main.bounds) // Use the whole screen bounds
        
        // when
        sut.setupPopoverCentered(onView: parentView, withPopover: popoverViewController, withWidth: 100, andHeight: 100)
        
        // then
        XCTAssertNotNil(sut.delegate?.maskView, "Delegate's maskView should not be nil")
        XCTAssertEqual(sut.delegate?.maskView, parentView.mask, "Delegate's maskView should be the same as the mask view added to the parent view")
    }

    func test_DefaultPopoverPresenter_WhenSetupPopoverCenteredCalled_ShouldSetDelegateAsViewControllersDismissingDelegate() {
        // given
        let sut = DefaultPopoverPresenter()
        let popoverViewController = DismissingPopoverViewControllerMock()
        let parentView = UIView()

        // when
        sut.setupPopoverCentered(onView: parentView, withPopover: popoverViewController, withWidth: 100, andHeight: 100)

        // then
        XCTAssertNotNil(popoverViewController.dismissingDelegate, "Dismissing delegate should not be nil")
        XCTAssertIdentical(popoverViewController.dismissingDelegate, sut.delegate, "Dismissing delegate should be the same as the presenter's delegate")
    }
    
    
    class DismissingPopoverViewControllerMock: UIViewController, DismissingPopoverViewController {
        var dismissingDelegate: PopoverDimissingDelegate?
    }
}

class DefaultPopoverPresenterMock: DefaultPopoverPresenterProtocol {
    
    var setupPopoverCenteredCalledCount = 0
    var setupPopoverCenteredPopoverVC: DismissingPopoverViewController?
    var setupPopoverCenteredWidth: CGFloat?
    var setupPopoverCenteredHeight: CGFloat?
//    var setupPopoverCenteredDelegate: UIPopoverPresentationControllerDelegate?
    var setupPopoverCenteredView: UIView?
    var setupPopoverCenteredTapToExit: Bool?
    
    func setupPopoverCentered(onView view: UIView, withPopover viewController: DismissingPopoverViewController, withWidth width: CGFloat, andHeight height: CGFloat, tapToExit: Bool = false) {
        self.setupPopoverCenteredCalledCount += 1
        self.setupPopoverCenteredPopoverVC = viewController
        self.setupPopoverCenteredWidth = width
        self.setupPopoverCenteredHeight = height
        self.setupPopoverCenteredView = view
        self.setupPopoverCenteredTapToExit = tapToExit
    }
}
