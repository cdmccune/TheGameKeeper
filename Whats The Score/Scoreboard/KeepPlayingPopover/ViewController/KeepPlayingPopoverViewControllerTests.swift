//
//  KeepPlayingPopoverViewControllerTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 3/1/24.
//

import XCTest
@testable import Whats_The_Score

final class KeepPlayingPopoverViewControllerTests: XCTestCase {

    // MARK: - Setup
    
    var viewController: KeepPlayingPopoverViewController!
    
    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "KeepPlayingPopoverViewController") as? KeepPlayingPopoverViewController else {
            fatalError("KeepPlayingPopoverViewController wasn't found")
        }
        self.viewController = viewController
    }
    
    override func tearDown() {
        viewController = nil
    }
    
    // MARK: - Helper functions
    
    func getKeepPlayingPopoverVCWithGameMock() -> KeepPlayingPopoverViewController {
        let viewController = viewController!
        viewController.game = GameMock()
        viewController.game?.gameEndType = .score
        return viewController
    }
    
    
    // MARK: - Initialization
    
    func test_KeepPlayingPopoverViewController_WhenViewLoaded_ShouldHaveNonNilOutlets() {
        // given
        let sut = viewController!
        
        // when
        sut.loadView()
        
        // then
        XCTAssertNotNil(sut.instructionLabel)
        XCTAssertNotNil(sut.inputTextField)
        XCTAssertNotNil(sut.inputDescriptionLabel)
        XCTAssertNotNil(sut.saveChangesButton)
    }
    
    
    // MARK: - ViewDidLoad
    
    func test_KeepPlayingPopoverViewController_WhenViewDidLoadCalled_ShouldCallUnderlineButtonForButtonStatesOnNoEndButtonWithCorrectParameters() {
        // given
        let sut = viewController!
        sut.loadView()
        sut.game = GameMock()
        
        let button = UIButtonUnderlineButtonForButtonStatesMock()
        sut.noEndButton = button
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(button.underlineButtonForButtonStatesCalledCount, 1)
        XCTAssertEqual(button.underlineButtonForButtonStatesTextSize, 14)
        XCTAssertEqual(button.underlineButtonForButtonStatesTitle, "No End")
    }
    
    func test_KeepPlayingPopoverViewController_WhenViewDidLoadCalled_ShouldCallUnderlineButtonForButtonStatesOnEndGameButtonWithCorrectParameters() {
        // given
        let sut = viewController!
        sut.loadView()
        sut.game = GameMock()
        
        let button = UIButtonUnderlineButtonForButtonStatesMock()
        sut.endGameButton = button
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(button.underlineButtonForButtonStatesCalledCount, 1)
        XCTAssertEqual(button.underlineButtonForButtonStatesTextSize, 14)
        XCTAssertEqual(button.underlineButtonForButtonStatesTitle, "End Game")
    }
    
    func test_KeepPlayingPopoverViewController_WhenViewDidLoadCalled_ShouldAddTargetToInputTextFieldForEditingDidChange() {
        // given
        let sut = getKeepPlayingPopoverVCWithGameMock()
        sut.loadView()
        
        // when
        sut.viewDidLoad()
        
        // then
        let targets = sut.inputTextField.allTargets
        XCTAssertTrue(targets.contains(sut))
    }
    
    func test_KeepPlayingPopoverViewController_WhenViewDidLoadCalled_CallBecomeFirstResponderOnInputTextField() {
        
        class UITextFieldBecomeFirstResponderMock: UITextField {
            var becomeFirstResponderCalledCount = 0
            override func becomeFirstResponder() -> Bool {
                becomeFirstResponderCalledCount += 1
                return true
            }
        }
        
        // given
        let sut = getKeepPlayingPopoverVCWithGameMock()
        sut.loadView()
        let textFieldMock = UITextFieldBecomeFirstResponderMock()
        sut.inputTextField = textFieldMock
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(textFieldMock.becomeFirstResponderCalledCount, 1)
    }
    
    func test_KeepPlayingPopoverViewController_WhenViewDidLoadCalled_HaveSaveChangesDisables() {
        // given
        let sut = getKeepPlayingPopoverVCWithGameMock()
        sut.loadView()
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertFalse(sut.saveChangesButton.isEnabled)
    }
    
    func test_KeepPlayingPopoverViewController_WhenViewDidLoadCalledGameEndTypeScore_ShouldSetInstructionLabelTextToEnterTheNewWinningScore() {
        // given
        let sut = viewController!
        sut.loadView()
        
        let game = GameMock()
        game.gameEndType = .score
        sut.game = game
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(sut.instructionLabel.text, "Set the new winning score")
    }
    
    func test_KeepPlayingPopoverViewController_WhenViewDidLoadCalledGameEndTypeScore_ShouldSetInputDescriptionLabelTextToPoints() {
        // given
        let sut = viewController!
        sut.loadView()
        
        let game = GameMock()
        game.gameEndType = .score
        sut.game = game
        
        sut.inputDescriptionLabel.text = ""
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(sut.inputDescriptionLabel.text, "pts")
    }
    
    func test_KeepPlayingPopoverViewController_WhenViewDidLoadCalledGameEndTypeRound_ShouldSetInstructionLabelTextToEnterTheNewWinningScore() {
        // given
        let sut = viewController!
        sut.loadView()
        
        let game = GameMock()
        game.gameEndType = .round
        sut.game = game
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(sut.instructionLabel.text, "Set the new number of rounds")
    }
    
    func test_KeepPlayingPopoverViewController_WhenViewDidLoadCalledGameEndTypeScore_ShouldSetInputDescriptionLabelTextToRounds() {
        // given
        let sut = viewController!
        sut.loadView()
        
        let game = GameMock()
        game.gameEndType = .round
        sut.game = game
        
        sut.inputDescriptionLabel.text = ""
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(sut.inputDescriptionLabel.text, "rnds")
    }
    
    func test_KeepPlayingPopoverViewController_WhenViewDidLoadCalled_ShouldSetTextFieldDelegateAsDismissingTextFieldDelegate() {
        let sut = viewController!
        sut.loadView()
        
        let game = GameMock()
        game.gameEndType = .round
        sut.game = game
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertTrue(sut.inputTextField.delegate is DismissingTextFieldDelegate)
    }
    
    
    // MARK: - TextField EditingChanged
    
    func test_KeepPlayingPopoverViewController_WhenViewDidLoadCalledAndInputTextFieldTextNotAnIntAndSendActionForEditingChanged_ShouldMakeSaveChangesButtonDisabled() {
        // given
        let sut = getKeepPlayingPopoverVCWithGameMock()
        sut.loadView()
        sut.viewDidLoad()
        
        sut.saveChangesButton.isEnabled = true
        
        // when
        sut.inputTextField.text = "adsf"
        sut.inputTextField.sendActions(for: .editingChanged)
        
        // then
        XCTAssertFalse(sut.saveChangesButton.isEnabled)
    }
    
    func test_KeepPlayingPopoverViewController_WhenGameRoundTypeAndInputTextFieldTextIntLessThanGameCurrentRoundAndSendActionForEditingChanged_ShouldMakeSaveChangesButtonDisabled() {
        // given
        let sut = viewController!
        
        let game = GameMock()
        game.gameEndType = .round
        game.currentRound = 5
        sut.game = game
        
        sut.loadView()
        sut.viewDidLoad()
        
        sut.saveChangesButton.isEnabled = true
        
        let roundInt = 4
        sut.inputTextField.text = "\(roundInt)"
        
        // when
        sut.inputTextField.sendActions(for: .editingChanged)
        
        // then
        XCTAssertFalse(sut.saveChangesButton.isEnabled)
    }
    
    func test_KeepPlayingPopoverViewController_WhenGameEndTypeRoundAndInputTextFieldTextIntLessThanGameCurrentRoundAndSendActionForEditingChanged_ShouldSetTextToNumberOfRoundsMustBeHigherThanCurrentRound() {
        // given
        let sut = viewController!
        
        let game = GameMock()
        game.gameEndType = .round
        let currentRound = 5
        game.currentRound = currentRound
        sut.game = game
        
        sut.loadView()
        sut.viewDidLoad()
        
        sut.saveChangesButton.isEnabled = true
        
        let roundInt = 4
        sut.inputTextField.text = "\(roundInt)"
        
        // when
        sut.inputTextField.sendActions(for: .editingChanged)
        
        // then
        XCTAssertEqual(sut.instructionLabel.text, "Rounds must be higher than \(currentRound - 1)")
    }
    
    func test_KeepPlayingPopoverViewController_WhenGameEndTypeScoreAndInputTextFieldTextIntLessThanGameCurrentRoundAndSendActionForEditingChanged_ShouldMakeSaveChangesButtonDisabled() {
        // given
        let sut = viewController!
        
        let game = GameMock()
        game.gameEndType = .score
        let highScore = 5
        let player = PlayerMock(score: highScore)
        game.winningPlayers = [player]
        sut.game = game
        
        sut.loadView()
        sut.viewDidLoad()
        
        sut.saveChangesButton.isEnabled = true
        
        let scoreInt = 4
        sut.inputTextField.text = "\(scoreInt)"
        
        // when
        sut.inputTextField.sendActions(for: .editingChanged)
        
        // then
        XCTAssertFalse(sut.saveChangesButton.isEnabled)
    }
    
    func test_KeepPlayingPopoverViewController_WhenGameEndTypeScoreAndInputTextFieldTextIntLessThanGameCurrentRoundAndSendActionForEditingChanged_ShouldSetTextToYouMustInputANumberHigherThanHighestPlayersScore() {
        // given
        let sut = viewController!
        
        let game = GameMock()
        game.gameEndType = .score
        let highScore = 5
        let player = PlayerMock(score: highScore)
        game.winningPlayers = [player]
        sut.game = game
        
        sut.loadView()
        sut.viewDidLoad()
        
        sut.saveChangesButton.isEnabled = true
        
        let scoreInt = 4
        sut.inputTextField.text = "\(scoreInt)"
        
        // when
        sut.inputTextField.sendActions(for: .editingChanged)
        
        // then
        XCTAssertEqual(sut.instructionLabel.text, "Score must be higher than \(highScore)")
    }
    
    func test_KeepPlayingPopoverViewController_WhenGameEndTypeScoreAndInputTextFieldTextIntMoreThanGameCurrentRoundAndSendActionForEditingChanged_ShouldSetTextToTapSaveChangesToPlayOnAndEnableSaveChangesButton() {
        // given
        let sut = viewController!
        
        let game = GameMock()
        game.gameEndType = .score
        let highScore = 5
        let player = PlayerMock(score: highScore)

        game.winningPlayers = [player]
        sut.game = game
        
        sut.loadView()
        sut.viewDidLoad()
        
        sut.saveChangesButton.isEnabled = false
        
        let scoreInt = 6
        sut.inputTextField.text = "\(scoreInt)"
        
        // when
        sut.inputTextField.sendActions(for: .editingChanged)
        
        // then
        XCTAssertEqual(sut.instructionLabel.text, "Tap save changes to play on!")
        XCTAssertTrue(sut.saveChangesButton.isEnabled)
    }
    
    
    // MARK: - SaveChangesButton
    
    func test_KeepPlayingPopoverViewController_WhenGameEndTypeRoundSaveChangesButtonTappedCalled_ShouldCallDelegateFunctionUpdateNumberOfRoundsAndCallDismiss() {
        // given
        let sut = KeepPlayingPopoverViewControllerDismissMock()
        sut.loadView()
        
        let game = GameMock()
        game.gameEndType = .round
        sut.game = game
        
        let delegate = KeepPlayingPopoverDelegateMock()
        sut.delegate = delegate
        
        let textField = UITextField()
        let newNumberOfRounds = String(Int.random(in: 1...1000))
        textField.text = newNumberOfRounds
        sut.inputTextField = textField
        
        // when
        sut.saveChangesButtonTapped(0)
        
        // then
        XCTAssertEqual(delegate.updateNumberOfRoundsCalledCount, 1)
        XCTAssertEqual(delegate.updateNumberOfRoundsNewRounds, Int(newNumberOfRounds)!)
        XCTAssertEqual(sut.dismissCalledCount, 1)
    }
    
    func test_KeepPlayingPopoverViewController_WhenGameEndTypeScoreSaveChangesButtonTappedCalled_ShouldCallDelegateFunctionUpdateWinningScoreAndCallDismiss() {
        // given
        let sut = KeepPlayingPopoverViewControllerDismissMock()
        sut.loadView()
        
        let game = GameMock()
        game.gameEndType = .score
        sut.game = game
        
        let delegate = KeepPlayingPopoverDelegateMock()
        sut.delegate = delegate
        
        let textField = UITextField()
        let newScore = String(Int.random(in: 1...1000))
        textField.text = newScore
        sut.inputTextField = textField
        
        // when
        sut.saveChangesButtonTapped(0)
        
        // then
        XCTAssertEqual(delegate.updateWinningScoreCalledCount, 1)
        XCTAssertEqual(delegate.updateWinningScoreNewScore, Int(newScore)!)
        XCTAssertEqual(sut.dismissCalledCount, 1)
    }
    
    
    // MARK: - NoEndButton
    
    func test_KeepPlayingPopoverViewController_WhenSetNoEndButtonTappedCalled_ShouldCallDelegateSetNoEndAndCallDismiss() {
        // given
        let sut = KeepPlayingPopoverViewControllerDismissMock()
        
        let delegate = KeepPlayingPopoverDelegateMock()
        sut.delegate = delegate
        
        // when
        sut.setNoEndButtonTapped(0)
        
        // then
        XCTAssertEqual(delegate.setNoEndCalledCount, 1)
        XCTAssertEqual(sut.dismissCalledCount, 1)
    }
    
    
    // MARK: - EndGameButton
    
    func test_KeepPlayingPopoverViewController_WhenEndGameButtonTappedCalled_ShouldCallDelegateEndGameAndCallDismiss() {
        // given
        let sut = KeepPlayingPopoverViewControllerDismissMock()
        
        let delegate = KeepPlayingPopoverDelegateMock()
        sut.delegate = delegate
        
        // when
        sut.endGameButtonTapped(0)
        
        // then
        XCTAssertEqual(delegate.goToEndGameScreenCalledCount, 1)
        XCTAssertEqual(sut.dismissCalledCount, 1)
    }
    
    // MARK: - Classes
    
    class KeepPlayingPopoverViewControllerDismissMock: KeepPlayingPopoverViewController {
        var dismissCalledCount = 0
        override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
            dismissCalledCount += 1
        }
    }
    
}

class KeepPlayingPopoverDelegateMock: KeepPlayingPopoverDelegate {
    
    var updateNumberOfRoundsCalledCount = 0
    var updateNumberOfRoundsNewRounds: Int?
    func updateNumberOfRounds(to numberOfRounds: Int) {
        updateNumberOfRoundsNewRounds = numberOfRounds
        updateNumberOfRoundsCalledCount += 1
    }
    
    var updateWinningScoreCalledCount = 0
    var updateWinningScoreNewScore: Int?
    func updateWinningScore(to winningScore: Int) {
        updateWinningScoreNewScore = winningScore
        updateWinningScoreCalledCount += 1
    }
    
    var setNoEndCalledCount = 0
    func setNoEnd() {
        setNoEndCalledCount += 1
    }
    
    var goToEndGameScreenCalledCount = 0
    func goToEndGameScreen() {
        goToEndGameScreenCalledCount += 1
    }
}
