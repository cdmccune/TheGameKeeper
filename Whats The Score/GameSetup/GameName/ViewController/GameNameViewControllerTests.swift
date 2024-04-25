//
//  GameNameViewControllerTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 4/12/24.
//

import XCTest
@testable import Whats_The_Score

final class GameNameViewControllerTests: XCTestCase {

    // MARK: - Setup

    var viewController: GameNameViewController!
    
    override func setUp() {
        viewController = GameNameViewController.instantiate()
    }
    
    override func tearDown() {
        viewController = nil
    }
    
    
    // MARK: - Properties
    
    func test_GameNameViewController_WhenTextFieldLoaded_ShouldSetItsCoordinatorEqualToOwnCoordinator() {
        // given
        let sut = viewController!
        sut.loadView()
        
        let coordinator = GameSetupCoordinatorMock()
        sut.coordinator = coordinator
        
        // when
        let textFieldDelegate = sut.textFieldDelegate
        
        // then
        XCTAssertIdentical(textFieldDelegate.coordinator, coordinator)
    }
    
    
    // MARK: - ViewDidLoad
    
    func test_GameNameViewController_WhenViewDidLoadCalled_ShouldCallBecomeFirstResponderOnNameTextField() {
        // given
        let sut = viewController!
        sut.loadView()
        
        let textField = UITextFieldBecomeFirstResponderMock()
        sut.nameTextField = textField
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(textField.becomeFirstResponderCalledCount, 1)
    }
    
    func test_GameNameViewController_WhenViewDidLoadCalled_ShouldSetGameNameLabelWithCorrectStrokeWidthAndColor() {
        // given
        let sut = viewController!
        sut.loadView()
        
        // when
        sut.viewDidLoad()
        
        // then
        let attributedString = sut.gameNameLabel.attributedText
        XCTAssertEqual(attributedString?.string, "Game Name")
        XCTAssertEqual(attributedString?.attributes(at: 0, effectiveRange: nil)[NSAttributedString.Key.strokeWidth] as? CGFloat, -4.0)
        XCTAssertEqual(attributedString?.attributes(at: 0, effectiveRange: nil)[NSAttributedString.Key.strokeColor] as? UIColor, .black)
    }
    
    func test_GameNameViewController_WhenViewDidLoadCalled_ShouldSetTextFieldDelegateEqualToTextFieldDelegateOnNameTextField() {
        // given
        let sut = viewController!
        sut.loadView()
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertIdentical(sut.nameTextField.delegate, sut.textFieldDelegate)
    }
    
    func test_GameNameViewController_WhenViewDidLoadCalled_ShouldAddTargetToNameTextFieldForEditingDidChange() {
        // given
        let sut = viewController!
        sut.loadView()
        
        // when
        sut.viewDidLoad()
        
        // then
        let targets = sut.nameTextField.allTargets
        XCTAssertTrue(targets.contains(sut))
    }

    
    // MARK: - Continue Button Tapped
    
    func test_GameNameViewController_WhenContinueButtonTapped_ShouldCallCoordinatorGameNameSet() {
        // given
        let sut = viewController!
        
        let name = UUID().uuidString
        
        let textField = UITextField()
        textField.text = name
        sut.nameTextField = textField
        
        let coordinator = GameSetupCoordinatorMock()
        sut.coordinator = coordinator
        
        // when
        sut.continueButtonTapped(0)
        
        // then
        XCTAssertEqual(coordinator.gameNameSetCalledCount, 1)
        XCTAssertEqual(coordinator.gameNameSetName, name)
    }
    
    
    // MARK: - TextFieldDidChange
    
    func test_GameNameViewController_WhenNameTextFieldValueBlankEditingChanged_ShouldSetContinueButtonIsEnabledToFalse() {
        // given
        let sut = viewController!
        sut.loadView()
        sut.viewDidLoad()
        
        sut.continueButton.isEnabled = true
        sut.nameTextField.text = ""
        
        // when
        sut.nameTextField.sendActions(for: .editingChanged)
        
        // then
        XCTAssertFalse(sut.continueButton.isEnabled)
    }
    
    func test_GameNameViewController_WhenNameTextFieldValueNotBlankEditingChanged_ShouldSetContinueButtonIsEnabledToTrue() {
        // given
        let sut = viewController!
        sut.loadView()
        sut.viewDidLoad()
        
        sut.continueButton.isEnabled = false
        sut.nameTextField.text = "fasdf"
        
        // when
        sut.nameTextField.sendActions(for: .editingChanged)
        
        // then
        XCTAssertTrue(sut.continueButton.isEnabled)
    }
}
