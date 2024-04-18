//
//  GameEndQuantitySelectionPopoverViewControllerTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 4/17/24.
//

import XCTest
@testable import Whats_The_Score

final class GameEndQuantitySelectionPopoverViewControllerTests: XCTestCase {

    // MARK: - Setup

    var viewController: GameEndQuantitySelectionPopoverViewController!
    
    override func setUp() {
        viewController = GameEndQuantitySelectionPopoverViewController.instantiate()
    }
    
    override func tearDown() {
        viewController = nil
    }
    
    
    // MARK: - Outlets
    
    func test_GameEndQuantitySelectionPopoverViewController_WhenLoaded_ShouldHaveNonNilOutlets() {
        // given
        let sut = viewController!
        
        // when
        sut.loadView()
        
        // then
        XCTAssertNotNil(sut.saveButton)
    }
    
    
    // MARK: - ViewDidLoad
    
    func test_GameEndQuantitySelectionPopoverViewController_WhenViewDidLoadCalled_ShouldCallSetAttributedUnderlinedTitleWithSubtextOnSaveButtonWithCorrectParameters() {
        // given
        let sut = viewController!
        sut.loadView()
        
        let button = UIButtonUnderlineButtonForButtonStatesMock()
        sut.saveButton = button
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(button.underlineButtonForButtonStatesCalledCount, 1)
        XCTAssertEqual(button.underlineButtonForButtonStatesTitle, "Save")
        XCTAssertEqual(button.underlineButtonForButtonStatesTextSize, 22)
    }
    
    func test_GameEndQuantitySelectionPopoverViewController_WhenViewDidLoadCalled_ShouldCallBecomeFirstResponderOnQuantityTextField() {
        // given
        let sut = viewController!
        sut.loadView()
        
        let textField = UITextFieldBecomeFirstResponderMock()
        sut.quantityTextField = textField
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(textField.becomeFirstResponderCalledCount, 1)
    }
    
    func test_GameEndQuantitySelectionPopoverViewController_WhenViewDidLoadCalledGameEndTypeRound_ShouldSetTitleLabelToRoundsAndQuantityTextFieldPlaceholderToNumberOfRounds() {
        // given
        let sut = viewController!
        sut.loadView()
        sut.gameEndType = .round
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(sut.quantityTextField.placeholder, "# of rounds")
        XCTAssertEqual(sut.titleLabel.text, "Rounds")
    }
    
    func test_GameEndQuantitySelectionPopoverViewController_WhenViewDidLoadCalledGameEndTypeRound_ShouldSetTitleLabelToScoreQuantityTextFieldPlaceholderToWinningScore() {
        // given
        let sut = viewController!
        sut.loadView()
        sut.gameEndType = .score
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(sut.quantityTextField.placeholder, "Winning score")
        XCTAssertEqual(sut.titleLabel.text, "Score")
    }
    
    func test_GameEndQuantitySelectionPopoverViewController_WhenViewDidLoadCalled_ShouldAddTargetToQuantityTextFieldForEditingDidChange() {
        // given
        let sut = viewController!
        sut.loadView()
        
        // when
        sut.viewDidLoad()
        
        // then
        let targets = sut.quantityTextField.allTargets
        XCTAssertTrue(targets.contains(sut))
    }
    
    
    // MARK: - TextFieldDidChange
    
    func test_GameEndQuantitySelectionPopoverViewController_WhenGameEndTypeScoreQuantityTextFieldValueZeroEditingChanged_ShouldSetIssueLabelTextToWinningScoreMustBeAtLeast1AndDisableSaveButton() {
        // given
        let sut = viewController!
        sut.loadView()
        sut.viewDidLoad()
        
        sut.gameEndType = .score
        sut.saveButton.isEnabled = true
        
        // when
        sut.quantityTextField.text = "0"
        sut.quantityTextField.sendActions(for: .editingChanged)
        
        // then
        XCTAssertEqual(sut.issueLabel.text, "Must be at least 1!")
        XCTAssertFalse(sut.saveButton.isEnabled)
    }
    
    func test_GameEndQuantitySelectionPopoverViewController_WhenGameEndTypeRoundQuantityTextFieldValueZeroEditingChanged_ShouldSetIssueLabelTextToNumberOfRoundsMustBeAtLeast2AndDisableSaveButton() {
        // given
        let sut = viewController!
        sut.loadView()
        sut.viewDidLoad()
        
        sut.gameEndType = .round
        sut.saveButton.isEnabled = true
        
        // when
        sut.quantityTextField.text = "0"
        sut.quantityTextField.sendActions(for: .editingChanged)
        
        // then
        XCTAssertEqual(sut.issueLabel.text, "Must be at least 2!")
        XCTAssertFalse(sut.saveButton.isEnabled)
    }
    
    func test_GameEndQuantitySelectionPopoverViewController_WhenShouldGameEndTypeScoreQuantityTextFieldValue1EditingChanged_ShouldSetIssueTextToBlankAndEnableButton() {
        // given
        let sut = viewController!
        sut.loadView()
        sut.viewDidLoad()
        
        sut.gameEndType = .score
        sut.issueLabel.text = "d"
        sut.saveButton.isEnabled = false
        
        // when
        sut.quantityTextField.text = "1"
        sut.quantityTextField.sendActions(for: .editingChanged)
        
        // then
        XCTAssertEqual(sut.issueLabel.text, "")
        XCTAssertTrue(sut.saveButton.isEnabled)
    }
    
    func test_GameEndQuantitySelectionPopoverViewController_WhenShouldGameEndTypeRoundQuantityTextFieldValue2EditingChanged_ShouldSetIssueTextToBlankAndEnableButton() {
        // given
        let sut = viewController!
        sut.loadView()
        sut.viewDidLoad()
        
        sut.gameEndType = .round
        sut.issueLabel.text = "d"
        sut.saveButton.isEnabled = false
        
        // when
        sut.quantityTextField.text = "2"
        sut.quantityTextField.sendActions(for: .editingChanged)
        
        // then
        XCTAssertEqual(sut.issueLabel.text, "")
        XCTAssertTrue(sut.saveButton.isEnabled)
    }
    
    
    // MARK: - SaveButtonTapped
    
    func test_GameEndQuantitySelectionPopoverViewController_WhenSaveButtonTapped_ShouldCallCoordinatorGameQuantitySelectedWithTextFieldValue() {
        // given
        let sut = viewController!
        sut.loadView()
        
        let coordinator = GameSetupCoordinatorMock()
        sut.coordinator = coordinator
        
        let value = Int.random(in: 2...10)
        sut.quantityTextField.text = String(value)
        
        // when
        sut.saveButtonTapped(0)
        
        // then
        XCTAssertEqual(coordinator.gameEndQuantityCalledCount, 1)
        XCTAssertEqual(coordinator.gameEndQuantity, value)
    }
    
    func test_GameEndQuantitySelectionPopoverViewController_WhenSaveButtonTapped_ShouldCallDismissOnPopover() {
        class GameEndQuantitySelectionPopoverViewControllerDismissMock: GameEndQuantitySelectionPopoverViewController {
            var dismissedCalledCount = 0
            override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
                dismissedCalledCount += 1
            }
        }
        
        // given
        let sut = GameEndQuantitySelectionPopoverViewControllerDismissMock()
        let textField = UITextField()
        sut.quantityTextField = textField
        
        // when
        sut.saveButtonTapped(0)
        
        // then
        XCTAssertEqual(sut.dismissedCalledCount, 1)
    }
    
    
    // MARK: - ExitButtonTapped
    
    func test_GameEndQuantitySelectionPopoverViewController_WhenExitButtonTappedCalled_ShouldCallDismissOnPopover() {
        class GameEndQuantitySelectionPopoverViewControllerDismissMock: GameEndQuantitySelectionPopoverViewController {
            var dismissedCalledCount = 0
            override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
                dismissedCalledCount += 1
            }
        }
        
        // given
        let sut = GameEndQuantitySelectionPopoverViewControllerDismissMock()
        
        // when
        sut.exitButtonTapped(0)
        
        // then
        XCTAssertEqual(sut.dismissedCalledCount, 1)
    }
}
