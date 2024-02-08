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
        let popoverViewController = UIViewController()
        
        // when
        sut.setupPopoverCentered(onView: UIView(), withPopover: popoverViewController, withWidth: 0, andHeight: 0)
        
        // then
        XCTAssertEqual(popoverViewController.modalPresentationStyle, .popover)
    }
    
    func test_DefaultPopoverPresenter_WhenSetupPopoverCenteredCalled_ShouldSetViewControllersPopoverPresentationControllerPermittedArrowDirectionToZero() {
        // given
        let sut = DefaultPopoverPresenter()
        let popoverViewController = UIViewController()
        
        // when
        sut.setupPopoverCentered(onView: UIView(), withPopover: popoverViewController, withWidth: 0, andHeight: 0)
        
        // then
        XCTAssertEqual(popoverViewController.popoverPresentationController?.permittedArrowDirections, UIPopoverArrowDirection(rawValue: 0))
    }
    
    func test_DefaultPopoverPresenter_WhenSetupPopoverCenteredCalled_ShouldSetViewControllersPopoverPresentationSourceViewToViewControllersView() {
        // given
        let view = UIView()
        let sut = DefaultPopoverPresenter()
        let popoverViewController = UIViewController()
        
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
        
        let popoverViewController = UIViewController()
        
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
        
        let popoverViewController = UIViewController()
        
        // when
        sut.setupPopoverCentered(onView: UIView(), withPopover: popoverViewController, withWidth: width, andHeight: height)
        
        // then
        let goalSize = CGSize(width: width, height: height)
        XCTAssertEqual(popoverViewController.preferredContentSize, goalSize)
    }
    
    func test_DefaultPopoverPresenter_WhenSetupPopoverCenteredCalled_ShouldSetViewControllersPopoverPresentationControllerDelegateToNoAdaptivePresentationStylePopoverPresentationDelegate() {
        // given
        let sut = DefaultPopoverPresenter()
        let popoverViewController = UIViewController()
        
        // when
        sut.setupPopoverCentered(onView: UIView(), withPopover: popoverViewController, withWidth: 0, andHeight: 0)
        
        // then
        XCTAssertTrue(popoverViewController.popoverPresentationController?.delegate is NoAdaptivePresentationStylePopoverPresentationDelegate)
    }
    
    func test_DefaultPopoverPresenter_WhenSetupPopoverCenteredCalled_ShouldCallHideKeyboardWhenTappedAroundOnViewController() {
        
        class UIViewControllerHideKeyboardWhenTappedAround: UIViewController {
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

}

class DefaultPopoverPresenterMock: DefaultPopoverPresenterProtocol {
    
    var setupPopoverCenteredCalledCount = 0
    var setupPopoverCenteredPopoverVC: UIViewController?
    var setupPopoverCenteredWidth: CGFloat?
    var setupPopoverCenteredHeight: CGFloat?
//    var setupPopoverCenteredDelegate: UIPopoverPresentationControllerDelegate?
    var setupPopoverCenteredView: UIView?
    
    func setupPopoverCentered(onView view: UIView, withPopover viewController: UIViewController, withWidth width: CGFloat, andHeight height: CGFloat) {
        self.setupPopoverCenteredCalledCount += 1
        self.setupPopoverCenteredPopoverVC = viewController
        self.setupPopoverCenteredWidth = width
        self.setupPopoverCenteredHeight = height
        self.setupPopoverCenteredView = view
    }
}
