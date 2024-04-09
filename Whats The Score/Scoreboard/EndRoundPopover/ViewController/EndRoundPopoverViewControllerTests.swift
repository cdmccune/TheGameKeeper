//
//  EndRoundPopoverViewControllerTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 2/16/24.
//

import XCTest
import CoreData
@testable import Whats_The_Score

final class EndRoundPopoverViewControllerTests: XCTestCase {

    // MARK: - Setup
    
    var viewController: EndRoundPopoverViewController!
    var managedObjectContext: NSManagedObjectContext!

    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "EndRoundPopoverViewController") as? EndRoundPopoverViewController else {
            fatalError("EndRoundPopoverViewController wasn't found")
        }
        self.viewController = viewController
        self.managedObjectContext = CoreDataStore(.inMemory).persistentContainer.viewContext
    }
    
    override func tearDown() {
        viewController = nil
        self.managedObjectContext = nil
    }
    
    
    // MARK: - Initialized
    
    func test_EndRoundPopoverViewController_WhenViewLoaded_ShouldHaveNonNilOutlets() {
        // given
        let sut = viewController!
        
        // when
        sut.loadView()
        
        // then
        XCTAssertNotNil(sut.playerScrollView)
        XCTAssertNotNil(sut.playerStackView)
        XCTAssertNotNil(sut.roundLabel)
    }
    
    
    // MARK: - ViewDidLoad
    
    func test_EndRoundPopoverViewController_WhenViewDidLoadCalled_ShouldSetRoundTextToEndRoundRoundNumber() {
        // given
        let sut = viewController!
        sut.loadView()
        
        let round = Int.random(in: 0...1000)
        let endRound = EndRoundSettings(scoreChangeSettingsArray: [], roundNumber: round)

        sut.endRound = endRound
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(sut.roundLabel.text, "Round \(round)")
    }
    
    func test_EndRoundPopoverViewController_WhenViewDidLoadCalledEndRoundNil_ShouldSetRoundTextToQuestionMarkRound() {
        // given
        let sut = viewController!
        sut.loadView()
        
        sut.endRound = nil
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(sut.roundLabel.text, "Round ???")
    }
    
    func test_EndRoundPopoverViewController_WhenViewDidLoadCalled_ShouldPlugInPlayersScoresIntoTextFields() {
        // given
        
        let sut = viewController!
        
        let playersScoreChanges = [
            Int.random(in: 1...100),
            Int.random(in: 1...100),
            Int.random(in: 1...100)
        ]
        
        var endRound = EndRoundSettings.getStub(withPlayerCount: 3)
        endRound.scoreChangeSettingsArray[0].scoreChange = playersScoreChanges[0]
        endRound.scoreChangeSettingsArray[1].scoreChange = playersScoreChanges[1]
        endRound.scoreChangeSettingsArray[2].scoreChange = playersScoreChanges[2]
        
        sut.endRound = endRound
        
        // when
        sut.loadView()
        sut.viewDidLoad()
        
        // then
        sut.textFields.enumerated().forEach { (index, textField) in
            XCTAssertEqual(textField.text, String(playersScoreChanges[index]))
        }
    }
    
    func test_EndRoundPopoverViewController_WhenViewDidLoadCalledPlayerScoreChangeZero_ShouldSetTextfieldTextToBlank() {
        // given
        let sut = viewController!
        
        var endRound = EndRoundSettings.getStub(withPlayerCount: 1)
        endRound.scoreChangeSettingsArray[0].scoreChange = 0
        sut.endRound = endRound
        
        // when
        sut.loadView()
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(sut.textFields[0].text, "")
    }
    
    // MARK: - PlayerStackView
    
    func test_EndRoundPopoverViewController_WhenViewDidLoad_ShouldAddEndRoundScoreChangeCountOfEndRoundPopoverPlayerStackView() {
        // given
        let sut = viewController!
        sut.loadView()
        
        let playerCount = Int.random(in: 1...10)
        let endRound = EndRoundSettings.getStub(withPlayerCount: playerCount)
        sut.endRound = endRound
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(sut.playerStackView.subviews.count, playerCount)
        XCTAssertTrue(sut.playerStackView.subviews is [EndRoundPopoverPlayerStackView])
    }
    
    func test_EndRoundPopoverViewController_WhenViewDidLoad_ShouldSetPlayerForEndRoundPopoverPlayerStackView() {
        // given
        let sut = viewController!
        sut.loadView()
        
        let playerCount = Int.random(in: 2...10)
        let endRound = EndRoundSettings.getStub(withPlayerCount: playerCount)
        sut.endRound = endRound
        let randomPlayerIndex = Int.random(in: 0...playerCount-1)
        
        // when
        sut.viewDidLoad()
        let endRoundPopoverPlayerStackView = sut.playerStackView.subviews[randomPlayerIndex] as? EndRoundPopoverPlayerStackView
        
        // then
        XCTAssertEqual(endRoundPopoverPlayerStackView?.playerID, endRound.scoreChangeSettingsArray[randomPlayerIndex].player.id)
    }
    
    func test_EndRoundPopoverViewController_WhenViewDidLoad_ShouldSetTextFieldIndexAndActionDelegateToSelf() {
        // given
        let sut = viewController!
        sut.loadView()
        
        let playerCount = Int.random(in: 2...10)
        let endRound = EndRoundSettings.getStub(withPlayerCount: playerCount)
        sut.endRound = endRound
        
        // when
        sut.viewDidLoad()
        
        // then
        guard let stackViews = sut.playerStackView.subviews as? [EndRoundPopoverPlayerStackView] else {
            XCTFail("Subviews should be correct stack view")
            return
        }
        
        stackViews.enumerated().forEach { (index, stackView) in
            XCTAssertTrue((stackView.textField as? EndRoundPopoverTextField)?.actionDelegate is EndRoundPopoverViewController)
            XCTAssertEqual((stackView.textField as? EndRoundPopoverTextField)?.index, index)
        }
    }
    
    func test_EndRoundPopoverViewController_WhenViewDidLoad_ShouldSetIsLastPropertyWhichAffectsTheToolbarItemTitle() {
        // given
        let sut = viewController!
        sut.loadView()
        
        let playerCount = Int.random(in: 2...10)
        let endRound = EndRoundSettings.getStub(withPlayerCount: playerCount)
        sut.endRound = endRound
        
        // when
        sut.viewDidLoad()
        
        // then
        guard let stackViews = sut.playerStackView.subviews as? [EndRoundPopoverPlayerStackView] else {
            XCTFail("Subviews should be correct stack view")
            return
        }
        
        stackViews.enumerated().forEach { (index, stackView) in
            XCTAssertEqual((stackView.textField.inputAccessoryView as? UIToolbar)?.items?.last?.title, index == stackViews.count-1 ? "Done" : "Next")
        }
    }
    
    func test_EndRoundPopoverViewController_WhenViewDidLoad_ShouldSetTextFieldDelegateForEndRoundPopoverPlayerStackViewsTextField() {
        // given
        let sut = viewController!
        sut.loadView()
        
        let playerCount = Int.random(in: 2...10)
        let endRound = EndRoundSettings.getStub(withPlayerCount: playerCount)
        sut.endRound = endRound
        
        // when
        sut.viewDidLoad()
        
        // then
        guard let stackViews = sut.playerStackView.subviews as? [EndRoundPopoverPlayerStackView] else {
            XCTFail("Subviews should be correct stack view")
            return
        }
        
        stackViews.forEach { (stackView) in
            XCTAssertTrue(stackView.textFieldDelegate is StackViewTextFieldDelegate)
        }
    }
    
    func test_EndRoundPopoverViewController_WhenViewDidLoad_ShouldSetSelfAsEndRoundPopoverPlayerStackViewsTextFieldsEndRoundPopoverTextFieldDelegate() {
        // given
        let sut = viewController!
        sut.loadView()
        
        let playerCount = Int.random(in: 2...10)
        let endRound = EndRoundSettings.getStub(withPlayerCount: playerCount)
        sut.endRound = endRound
        
        // when
        sut.viewDidLoad()
        
        // then
        guard let stackViews = sut.playerStackView.subviews as? [EndRoundPopoverPlayerStackView] else {
            XCTFail("Subviews should be correct stack view")
            return
        }
        
        stackViews.forEach { (stackView) in
            let textFieldDelegate = stackView.textFieldDelegate as? StackViewTextFieldDelegate
            XCTAssertTrue(textFieldDelegate?.delegate is EndRoundPopoverViewController)
        }
    }
    
    func test_EndRoundPopoverViewController_WhenViewDidLoad_ShouldAddTextFieldsInPlayerStackViewsToTextFieldsProperty() {
        // given
        let sut = viewController!
        sut.loadView()
        
        let endRound = EndRoundSettings.getStub(withPlayerCount: Int.random(in: 2...10))
        sut.endRound = endRound
        
        // when
        sut.viewDidLoad()
        
        // then
        guard let stackViews = sut.playerStackView.subviews as? [EndRoundPopoverPlayerStackView] else {
            XCTFail("Subviews should be correct stack view")
            return
        }
        
        stackViews.enumerated().forEach { (index, stackView) in
            XCTAssertEqual(sut.textFields[index], stackView.textField)
        }
    }
    
    func test_EndRoundPopoverViewController_WhenViewDidLoad_ShouldSetPlayerStackViewSpacingToPlayerSeparatorHeight() {
        // given
        let sut = viewController!
        sut.loadView()
        
        sut.endRound = EndRoundSettings.getStub(withPlayerCount: 0)
        
        let separatorHeight = Int.random(in: 1...1000)
        sut.playerSeparatorHeight = separatorHeight
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(Int(sut.playerStackView.spacing), separatorHeight)
    }
    
    func test_EndRoundPopoverViewController_WhenViewDidLoad_ShouldSetPlayerStackViewsSubviewsHeightToPlayerViewHeight() {
        // given
        let sut = viewController!
        sut.loadView()
    
        sut.endRound = EndRoundSettings.getStub(withPlayerCount: 2)
        
        let playerViewHeight = Int.random(in: 1...1000)
        sut.playerViewHeight = playerViewHeight
        
        // when
        sut.viewDidLoad()
        
        // then
        sut.playerStackView.subviews.forEach { playerView in
            let constraints = playerView.constraints
            
            XCTAssertTrue(constraints.contains(where: { $0.firstAttribute == .height &&
                $0.constant == CGFloat(playerViewHeight)}))
        }
    }
    
    // MARK: - EndRoundButtonTapped
    
    func test_EndRoundPopoverViewController_WhenEndRoundButtonTappedEndRoundNotNil_ShouldCallEndRoundWithPlayers() {
        // given
        let sut = viewController!
        sut.loadView()
        
        let endRound = EndRoundSettings.getStub(withPlayerCount: 0)
        sut.endRound = endRound
        
        let endRoundDelegateMock = EndRoundPopoverDelegateProtocolMock()
        sut.delegate = endRoundDelegateMock
        
        // when
        sut.endRoundButtonTapped(0)
        
        // then
        
        XCTAssertEqual(endRoundDelegateMock.endRoundCalledCount, 1)
        XCTAssertTrue(endRoundDelegateMock.endRoundEndRound == endRound)
    }
    
    func test_EndRoundPopoverViewController_WhenEndRoundButtonTapped_ShouldDismissItself() {
        
        class EndRoundPopoverViewControllerDismissMock: EndRoundPopoverViewController {
            var dismissedCalledCount = 0
            override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
                dismissedCalledCount += 1
            }
        }
        
        // given
        let sut = EndRoundPopoverViewControllerDismissMock()
        sut.endRound = EndRoundSettings.getStub(withPlayerCount: 0)
        
        // when
        sut.endRoundButtonTapped(0)
        
        // then
        XCTAssertEqual(sut.dismissedCalledCount, 1)
    }
    
    
    // MARK: - ExitButtonTapped
    
    func test_EndRoundPopoverViewController_WhenExitButtonTappedCalled_ShouldDismissItself() {
        class EndRoundPopoverViewControllerDismissMock: EndRoundPopoverViewController {
            var dismissedCalledCount = 0
            override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
                dismissedCalledCount += 1
            }
        }
        
        // given
        let sut = EndRoundPopoverViewControllerDismissMock()
        
        // when
        sut.exitButtonTapped(0)
        
        // then
        XCTAssertEqual(sut.dismissedCalledCount, 1)
    }
    
    
    // MARK: - TextFieldEditingBegan
    
    func test_EndRoundPopoverViewController_WhenTextFieldEditingBeganCalledTextFieldIsInCurrentFrameOfPlayerScrollView_ShouldNotChangeScrollViewContentOffset() {
        // given
        let sut = viewController!
        sut.loadView()
        
        sut.playerViewHeight = Int.random(in: 1...100)
        sut.playerSeparatorHeight = Int.random(in: 1...100)
        
        let completePlayerCellHeight = (sut.playerViewHeight ?? 0) + (sut.playerSeparatorHeight ?? 0)
        
        sut.playerScrollView.frame = CGRect(x: 0, y: 0, width: 0, height: completePlayerCellHeight * 2)
        sut.playerScrollView.contentOffset.y = 0
        
        
        // when
        sut.textFieldEditingBegan(index: 0)
        
        // then
        XCTAssertEqual(sut.playerScrollView.contentOffset.y, 0)
    }
    
    func test_EndRoundPopoverViewController_WhenTextFieldEditingBeganCalledTextFieldIsOutOfCurrentFrameOfPlayerScrollView_ShouldChangeScrollViewOffsetToPlaceTextFieldAtBottomOfScrollView() {
        // given
        let sut = viewController!
        sut.loadView()
        
        sut.playerViewHeight = Int.random(in: 1...100)
        sut.playerSeparatorHeight = Int.random(in: 1...100)
        
        let completePlayerCellHeight = (sut.playerViewHeight ?? 0) + (sut.playerSeparatorHeight ?? 0)
        let scrollViewHeight = 2 * completePlayerCellHeight
        let playerToPanTo = Int.random(in: 3...10)
        
        sut.playerScrollView.frame = CGRect(x: 0, y: 0, width: 0, height: completePlayerCellHeight * 2)
        sut.playerScrollView.contentOffset.y = 0
        
        
        // when
        sut.textFieldEditingBegan(index: playerToPanTo)
        
        // then
        let newContentOffset = playerToPanTo * completePlayerCellHeight - scrollViewHeight + completePlayerCellHeight
        XCTAssertEqual(Int(sut.playerScrollView.contentOffset.y), newContentOffset)
    }
    
    
    // MARK: - TextField Should Return
    
    func test_EndRoundPopoverViewController_WhenTextFieldShouldReturnForCalledForNotLastTextField_ShouldCallBecomeFirstResponderOnNextTextField() {
        
        class UITextFieldBecomeFirstResponderMock: UITextField {
            var becomeFirstResponderCalledCount = 0
            override func becomeFirstResponder() -> Bool {
                becomeFirstResponderCalledCount += 1
                return false
            }
        }
        
        // given
        let sut = viewController!
        sut.loadView()
        
        let textFields = [UITextFieldBecomeFirstResponderMock(), UITextFieldBecomeFirstResponderMock()]
        sut.textFields = textFields
        
        // when
        sut.textFieldShouldReturn(for: 0)
        
        // then
        XCTAssertEqual(textFields[1].becomeFirstResponderCalledCount, 1)
    }
    
    func test_EndRoundPopoverViewController_WhenTextFieldShouldReturnForCalledForLastTextField_ShouldCallEndEditingOnThatTextField() {
        
        class UITextFieldEndEditingMock: UITextField {
            var endEditingCalledCount = 0
            override func endEditing(_ force: Bool) -> Bool {
                endEditingCalledCount += 1
                return false
            }
        }
        
        // given
        let sut = viewController!
        sut.loadView()
        
        let textFields = [UITextFieldEndEditingMock(), UITextFieldEndEditingMock()]
        sut.textFields = textFields
        
        // when
        sut.textFieldShouldReturn(for: 1)
        
        // then
        XCTAssertEqual(textFields[1].endEditingCalledCount, 1)
    }
    
    
    // MARK: - TextFieldValueChanged
    
    func test_EndRoundPopoverViewController_WhenTextFieldValueChangedCalled_ShouldSetEndRoundScoreChangesAtCorrectIndexToNewValue() {
        // given
        let sut = viewController!
        
        let playerCount = Int.random(in: 3...15)
        let randomPlayer = Int.random(in: 0...playerCount-1)
        let randomScore = Int.random(in: 1...10000)
        
        sut.endRound = EndRoundSettings.getStub(withPlayerCount: playerCount)
        
        // when
        sut.textFieldValueChanged(forIndex: randomPlayer, to: "\(randomScore)")
        
        // then
        XCTAssertEqual(sut.endRound?.scoreChangeSettingsArray[randomPlayer].scoreChange, randomScore)
    }
    
    
    // MARK: - Classes
}


class EndRoundPopoverDelegateProtocolMock: EndRoundPopoverDelegateProtocol {
    var endRoundCalledCount = 0
    var endRoundEndRound: EndRoundSettings?
    func endRound(_ endRound: EndRoundSettings) {
        endRoundCalledCount += 1
        endRoundEndRound = endRound
    }
}
