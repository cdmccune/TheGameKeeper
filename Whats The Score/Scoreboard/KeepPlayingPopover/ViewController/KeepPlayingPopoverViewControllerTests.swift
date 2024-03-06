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
        XCTAssertEqual(sut.inputDescriptionLabel.text, "Points")
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
        XCTAssertEqual(sut.inputDescriptionLabel.text, "Rounds")
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
    
    func test_KeepPlayingPopoverViewController_WhenGameEndTypeRoundAndInputTextFieldTextIntLessThanGameCurrentRoundAndSendActionForEditingChanged_ShouldSetInstructionTextColorToRedAndTextToNumberOfRoundsMustBeHigherThanCurrentRound() {
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
        XCTAssertEqual(sut.instructionLabel.textColor, .red)
        XCTAssertEqual(sut.instructionLabel.text, "Rounds must be higher than \(currentRound - 1)")
    }
    
    func test_KeepPlayingPopoverViewController_WhenGameEndTypeScoreAndInputTextFieldTextIntLessThanGameCurrentRoundAndSendActionForEditingChanged_ShouldMakeSaveChangesButtonDisabled() {
        // given
        let sut = viewController!
        
        let game = GameMock()
        game.gameEndType = .score
        let highScore = 5
        let player = Player(name: "", position: 0, score: highScore)
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
    
    func test_KeepPlayingPopoverViewController_WhenGameEndTypeScoreAndInputTextFieldTextIntLessThanGameCurrentRoundAndSendActionForEditingChanged_ShouldSetInstructionTextColorToRedAndTextToYouMustInputANumberHigherThanHighestPlayersScore() {
        // given
        let sut = viewController!
        
        let game = GameMock()
        game.gameEndType = .score
        let highScore = 5
        let player = Player(name: "", position: 0, score: highScore)
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
        XCTAssertEqual(sut.instructionLabel.textColor, .red)
        XCTAssertEqual(sut.instructionLabel.text, "Score must be higher than \(highScore)")
    }
    
    func test_KeepPlayingPopoverViewController_WhenGameEndTypeScoreAndInputTextFieldTextIntMoreThanGameCurrentRoundAndSendActionForEditingChanged_ShouldSetInstructionTextColorToBlueAndTextToTapSaveChangesToPlayOnAndEnableSaveChangesButton() {
        // given
        let sut = viewController!
        
        let game = GameMock()
        game.gameEndType = .score
        let highScore = 5
        let player = Player(name: "", position: 0, score: highScore)
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
        XCTAssertEqual(sut.instructionLabel.textColor, .systemBlue)
        XCTAssertEqual(sut.instructionLabel.text, "Tap save changes to play on!")
        XCTAssertTrue(sut.saveChangesButton.isEnabled)
    }
    
}
