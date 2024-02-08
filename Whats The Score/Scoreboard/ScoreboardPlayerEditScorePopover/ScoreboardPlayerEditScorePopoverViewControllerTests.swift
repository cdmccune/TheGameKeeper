//
//  ScoreboardPlayerEditScorePopoverViewControllerTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 2/7/24.
//

import XCTest
@testable import Whats_The_Score

final class ScoreboardPlayerEditScorePopoverViewControllerTests: XCTestCase {
    
    // MARK: - Setup
    
    var viewController: ScoreboardPlayerEditScorePopoverViewController?
    
    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ScoreboardPlayerEditScorePopoverViewController") as? ScoreboardPlayerEditScorePopoverViewController
        
        self.viewController = viewController
    }
    
    override func tearDown() {
        viewController = nil
    }
    
    
    // MARK: - Setup Tests
    
    func test_ScoreboardPlayerEditScorePopoverViewController_WhenLoaded_ShouldHaveNonNilOutlets() {
        // given
        let sut = viewController!
        
        // when
        sut.loadView()
        
        // then
        XCTAssertNotNil(sut.playerLabel)
        XCTAssertNotNil(sut.pointsTextField)
        XCTAssertNotNil(sut.pointsLabel)
        XCTAssertNotNil(sut.subtractButton)
        XCTAssertNotNil(sut.addButton)
    }
    
    
    // MARK: - ViewDidLoad
    
    func test_ScoreboardPlayerEditScorePopoverViewController_WhenViewDidLoadCalled_ShouldAddTargetToPointsTextFieldForEditingDidChange() {
        // given
        let sut = viewController!
        sut.loadView()
        
        // when
        sut.viewDidLoad()
        
        // then
        let targets = sut.pointsTextField.allTargets
        XCTAssertTrue(targets.contains(sut))
    }
    
    func test_ScoreboardPlayerEditScorePopoverViewController_WhenViewDidLoadCalled_CallBecomFirstResponderOnPointsTextField() {
        
        class UITextFieldBecomeFirstResponderMock: UITextField {
            var becomeFirstResponderCalledCount = 0
            override func becomeFirstResponder() -> Bool {
                becomeFirstResponderCalledCount += 1
                return true
            }
        }
        
        // given
        let sut = viewController!
        sut.loadView()
        let textFieldMock = UITextFieldBecomeFirstResponderMock()
        sut.pointsTextField = textFieldMock
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(textFieldMock.becomeFirstResponderCalledCount, 1)
    }
    
    func test_ScoreboardPlayerEditScorePopoverViewController_WhenViewDidLoadCalled_HaveAddAndSubtractButtonsDisables() {
        // given
        let sut = viewController!
        sut.loadView()
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertFalse(sut.addButton.isEnabled)
        XCTAssertFalse(sut.subtractButton.isEnabled)
    }
    
    
    // MARK: - TextField EditingChanged
    
    func test_ScoreboardPlayerEditScorePopoverViewController_WhenViewDidLoadCalledAndPointsTextFieldTextChangedToNilAndSendActionForEditingChanged_ShouldMakeAddAndSubtractButtonDisabled() {
        // given
        let sut = viewController!
        sut.loadView()
        sut.viewDidLoad()
        
        // when
        sut.pointsTextField.text = nil
        sut.pointsTextField.sendActions(for: .editingChanged)
        
        // then
        XCTAssertFalse(sut.addButton.isEnabled)
        XCTAssertFalse(sut.subtractButton.isEnabled)
    }
    
    func test_ScoreboardPlayerEditScorePopoverViewController_WhenViewDidLoadCalledAndPointsTextFieldTextChangedToTextAndSendActionForEditingChanged_ShouldMakeAddAndSubtractButtonDisabled() {
        // given
        let sut = viewController!
        sut.loadView()
        sut.viewDidLoad()
        
        // when
        sut.pointsTextField.text = "hfdsfh"
        sut.pointsTextField.sendActions(for: .editingChanged)
        
        // then
        XCTAssertFalse(sut.addButton.isEnabled)
        XCTAssertFalse(sut.subtractButton.isEnabled)
    }
    
    func test_ScoreboardPlayerEditScorePopoverViewController_WhenViewDidLoadCalledAndPointsTextFieldTextChangedToZeroAndSendActionForEditingChanged_ShouldMakeAddAndSubtractButtonDisabled() {
        // given
        let sut = viewController!
        sut.loadView()
        sut.viewDidLoad()
        
        // when
        sut.pointsTextField.text = "0"
        sut.pointsTextField.sendActions(for: .editingChanged)
        
        // then
        XCTAssertFalse(sut.addButton.isEnabled)
        XCTAssertFalse(sut.subtractButton.isEnabled)
    }
    
    func test_ScoreboardPlayerEditScorePopoverViewController_WhenViewDidLoadCalledAndPointsTextFieldTextChangedToNegativeAndSendActionForEditingChanged_ShouldMakeAddAndSubtractButtonDisabled() {
        // given
        let sut = viewController!
        sut.loadView()
        sut.viewDidLoad()
        
        // when
        sut.pointsTextField.text = "-3"
        sut.pointsTextField.sendActions(for: .editingChanged)
        
        // then
        XCTAssertFalse(sut.addButton.isEnabled)
        XCTAssertFalse(sut.subtractButton.isEnabled)
    }
    
    func test_ScoreboardPlayerEditScorePopoverViewController_WhenViewDidLoadCalledAndPointsTextFieldTextChangedToIntAndSendActionForEditingChanged_ShouldMakeAddAndSubtractButtonDisabled() {
        // given
        let sut = viewController!
        sut.loadView()
        sut.viewDidLoad()
        
        // when
        sut.pointsTextField.text = String(Int.random(in: 1...100))
        sut.pointsTextField.sendActions(for: .editingChanged)
        
        // then
        XCTAssertTrue(sut.addButton.isEnabled)
        XCTAssertTrue(sut.subtractButton.isEnabled)
    }
    
    
    // MARK: AddButtonTapped
    
    func test_ScoreboardPlayerEditScorePopoverViewController_WhenAddButtonTapped_ShouldCallDelegateEditWithPositiveTextFieldTextAndPlayer() {
        // given
        let sut = viewController!
        let textField = UITextField()
        
        let scoreNumber = Int.random(in: 1...1000)
        textField.text = String(scoreNumber)
        sut.pointsTextField = textField
        
        let delegateMock = ScoreboardPlayerEditScorePopoverDelegateMock()
        sut.delegate = delegateMock
        
        let player = Player(name: UUID().uuidString, position: 0)
        sut.player = player
        
        // when
        sut.addButtonTapped(0)
        
        // then
        XCTAssertEqual(delegateMock.editCalledCount, 1)
        XCTAssertEqual(delegateMock.editPlayer, player)
        XCTAssertEqual(delegateMock.editChange, scoreNumber)
    }
    
    func test_ScoreboardPlayerEditScorePopoverViewController_WhenAddButtonTapped_ShouldDismissView() {
        
        class ScoreboardPlayerEditScorePopoverViewControllerDismissMock: ScoreboardPlayerEditScorePopoverViewController {
            var dismissedCalledCount = 0
            override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
                dismissedCalledCount += 1
            }
        }
        
        // given
        let sut = ScoreboardPlayerEditScorePopoverViewControllerDismissMock()
        let textFieldMock = UITextField()
        textFieldMock.text = "3"
        sut.pointsTextField = textFieldMock
        
        sut.player = Player(name: "", position: 0)
        
        // when
        sut.addButtonTapped(0)
        
        // then
        XCTAssertEqual(sut.dismissedCalledCount, 1)
    }
    
    
    // MARK: SubtractButtonTapped
    
    func test_ScoreboardPlayerEditScorePopoverViewController_WhenSubtractButtonTapped_ShouldCallDelegateEditWithNegativeTextFieldTextAndPlayer() {
        // given
        let sut = viewController!
        let textField = UITextField()
        
        let scoreNumber = Int.random(in: 1...1000)
        textField.text = String(scoreNumber)
        sut.pointsTextField = textField
        
        let delegateMock = ScoreboardPlayerEditScorePopoverDelegateMock()
        sut.delegate = delegateMock
        
        let player = Player(name: UUID().uuidString, position: 0)
        sut.player = player
        
        // when
        sut.subtractButtonTapped(0)
        
        // then
        XCTAssertEqual(delegateMock.editCalledCount, 1)
        XCTAssertEqual(delegateMock.editPlayer, player)
        XCTAssertEqual(delegateMock.editChange, (-1 * scoreNumber))
    }
    
    func test_ScoreboardPlayerEditScorePopoverViewController_WhenSubtractButtonTapped_ShouldDismissView() {
        
        class ScoreboardPlayerEditScorePopoverViewControllerDismissMock: ScoreboardPlayerEditScorePopoverViewController {
            var dismissedCalledCount = 0
            override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
                dismissedCalledCount += 1
            }
        }
        
        // given
        let sut = ScoreboardPlayerEditScorePopoverViewControllerDismissMock()
        let textFieldMock = UITextField()
        textFieldMock.text = "3"
        sut.pointsTextField = textFieldMock
        
        sut.player = Player(name: "", position: 0)
        
        // when
        sut.subtractButtonTapped(0)
        
        // then
        XCTAssertEqual(sut.dismissedCalledCount, 1)
    }

}

class ScoreboardPlayerEditScorePopoverDelegateMock: ScoreboardPlayerEditScorePopoverDelegate {
    var editPlayer: Player?
    var editChange: Int?
    var editCalledCount = 0
    
    func editScore(for player: Whats_The_Score.Player, by change: Int) {
        editCalledCount += 1
        editPlayer = player
        editChange = change
    }
}
