//
//  GameSettingsViewControllerTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 3/19/24.
//

import XCTest
@testable import Whats_The_Score

final class GameSettingsViewControllerTests: XCTestCase {

    // MARK: - Setup
    
    var viewController: GameSettingsViewController!

    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "GameSettingsViewController") as? GameSettingsViewController else {
            fatalError("GameSettingsViewController wasn't found")
        }
        self.viewController = viewController
    }
    
    override func tearDown() {
        viewController = nil
    }
    
    // MARK: - Properties
    
    func test_GameSettingsViewController_WhenSaveBarButtonLoaded_ShouldHaveTitleSaveAndTargetOfVCAndTint() {
        // given
        let sut = viewController!
        
        // when
        let saveBarButton = sut.saveBarButton
        
        // then
        XCTAssertEqual(saveBarButton.title, "Save")
        XCTAssertEqual(saveBarButton.tintColor, .textColor)
        XCTAssertTrue(saveBarButton.target is GameSettingsViewController)
    }
    
    func test_GameSettingsViewController_WhenHistoryBarButtonSet_ShouldBePressPlay2PRegularSize15() {
        // given
        let sut = viewController!
        
        // when
        let barButton = sut.saveBarButton
        
        // then
        let normalAttributes = barButton.titleTextAttributes(for: .normal)
        let highlightedAttributes = barButton.titleTextAttributes(for: .highlighted)
        let disabledAttributes = barButton.titleTextAttributes(for: .disabled)
        
        let expectedFont = UIFont.pressPlay2PRegular(withSize: 15)
        
        XCTAssertEqual(normalAttributes?[.font] as? UIFont, expectedFont)
        XCTAssertEqual(highlightedAttributes?[.font] as? UIFont, expectedFont)
        XCTAssertEqual(disabledAttributes?[.font] as? UIFont, expectedFont)
    }
    
    func test_GameSettingsViewController_WhenSaveBarButtonActionTriggered_ShouldCallSaveChanges() {
        
        class GameSettingsViewControllerSaveChangesMock: GameSettingsViewController {
            var saveChangesCalledCount = 0
            override func saveChanges() {
                saveChangesCalledCount += 1
            }
        }
        
        // given
        let sut = GameSettingsViewControllerSaveChangesMock()
        
        // when
        _ = sut.saveBarButton.target?.perform(sut.saveBarButton.action, with: sut.saveBarButton)
        
        // then
        XCTAssertEqual(sut.saveChangesCalledCount, 1)
    }
    
    
    // MARK: - ViewLoaded
    
    func test_GameSettingsViewController_WhenViewLoaded_ShouldHaveNonNilOutlets() {
        // given
        let sut = viewController!
        
        // when
        sut.loadView()
        
        // then
        
    }
    
    
    // MARK: - ViewDidLoad
    
    func test_GameSettingsViewController_WhenViewDidLoadCalled_ShouldSetTextAttributesForSegmentedControl() {
        // given
        let sut = viewController!
        sut.loadView()
        
        // when
        sut.viewDidLoad()
        
        // then
        let normalAttributes = sut.gameEndTypeSegmentedControl.titleTextAttributes(for: .normal)
        let selectedAttributes = sut.gameEndTypeSegmentedControl.titleTextAttributes(for: .selected)
        XCTAssertEqual(normalAttributes?[NSAttributedString.Key.font] as? UIFont, UIFont.pressPlay2PRegular(withSize: 10))
        XCTAssertEqual(selectedAttributes?[NSAttributedString.Key.font] as? UIFont, UIFont.pressPlay2PRegular(withSize: 10))
        XCTAssertEqual(normalAttributes?[NSAttributedString.Key.foregroundColor] as? UIColor, UIColor.textColor)
        XCTAssertEqual(selectedAttributes?[NSAttributedString.Key.foregroundColor] as? UIColor, UIColor.textColor)
    }
    
    func test_GameSettingsViewController_WhenViewDidLoadCalled_ShouldSetCorrectStrokeOnTitleLabel() {
        // given
        let sut = viewController!
        sut.loadView()
        
        // when
        sut.viewDidLoad()
        
        // then
        let attributedString = sut.titleLabel.attributedText
        XCTAssertEqual(attributedString?.string, "Settings")
        XCTAssertEqual(attributedString?.attributes(at: 0, effectiveRange: nil)[NSAttributedString.Key.strokeWidth] as? CGFloat, -4.0)
        XCTAssertEqual(attributedString?.attributes(at: 0, effectiveRange: nil)[NSAttributedString.Key.strokeColor] as? UIColor, .black)
    }
    
    func test_GameSettingsViewController_WhenViewDidLoadCalled_ShouldCallSetInitialValues() {
        // given
        let sut = viewController!
        let viewModel = GameSettingsViewModelMock()
        sut.viewModel = viewModel
        
        // when
        sut.loadView()
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(viewModel.setInitialValuesCalledCount, 1)
    }
    
    func test_GameSettingsViewController_WhenViewDidLoadCalled_ShouldSetGameIsLowestEndingOnSwitch() {
        // given
        let sut = viewController!
        let viewModel = GameSettingsViewModelMock()
        sut.viewModel = viewModel
        
        // when
        sut.loadView()
        let lowestIsWinning = Bool.random()
        viewModel.lowestIsWinning = lowestIsWinning
        sut.lowestWinsSwitch.isOn = !lowestIsWinning
        sut.viewDidLoad()
        
        
        // then
        XCTAssertEqual(lowestIsWinning, sut.lowestWinsSwitch.isOn)
    }
    
    func test_GameSettingsViewController_WhenViewDidLoadCalled_ShouldSetEndingScoreTextFieldTextToViewModelEndingScore() {
        // given
        let sut = viewController!
        let viewModel = GameSettingsViewModelMock()
        sut.viewModel = viewModel
        
        let endingScore = Int.random(in: 1...1000)
        viewModel.endingScore = endingScore
        
        // when
        sut.loadView()
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(sut.endingScoreTextField.text, String(endingScore))
    }
    
    func test_GameSettingsViewController_WhenViewDidLoadCalled_ShouldSetNumberOfRoundsTextFieldTextToViewModelNumberOfRounds() {
        // given
        let sut = viewController!
        let viewModel = GameSettingsViewModelMock()
        sut.viewModel = viewModel
        
        let numberOfRounds = Int.random(in: 1...1000)
        viewModel.numberOfRounds = numberOfRounds
        
        // when
        sut.loadView()
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(sut.numberOfRoundTextField.text, String(numberOfRounds))
    }
    
    func test_GameSettingsViewController_WhenViewDidLoadGameTypeBasic_ShouldHideGameEndStackView() {
        // given
        let sut = viewController!
        let game = GameMock(gameType: .basic)
        let viewModel = GameSettingsViewModelMock()
        viewModel.game = game
        sut.viewModel = viewModel
        
        // when
        sut.loadView()
        sut.viewDidLoad()
        
        // then
        XCTAssertTrue(sut.gameEndStackView.isHidden)
    }
    
    func test_GameSettingsViewController_WhenViewDidLoadGameTypeRound_ShouldShowGameEndStackView() {
        // given
        let sut = viewController!
        let game = GameMock(gameType: .round)
        let viewModel = GameSettingsViewModelMock()
        viewModel.game = game
        sut.viewModel = viewModel
        
        // when
        sut.loadView()
        sut.viewDidLoad()
        
        // then
        XCTAssertFalse(sut.gameEndStackView.isHidden)
    }
    
    func test_GameSettingsViewController_WhenViewDidLoadCalled_ShouldAddSaveBarButtonToNavigationItemRightBarButton() {
        // given
        let sut = viewController!
        sut.viewModel = GameSettingsViewModelMock()
        
        // when
        sut.loadView()
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(sut.navigationItem.rightBarButtonItem, sut.saveBarButton)
    }

    func test_GameSettingsViewController_WhenViewDidLoadCalled_ShouldSetGameNameTextFieldTextToViewModelGameName() {
        // given
        let sut = viewController!
        let viewModel = GameSettingsViewModelMock()
        let gameName = UUID().uuidString
        viewModel.gameName = gameName
        sut.viewModel = viewModel
        sut.loadView()
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(sut.gameNameTextField.text, viewModel.gameName)
    }
    
    func test_GameSettingsViewController_WhenViewDidLoadCalled_ShouldAddTargetToGameNameTextFieldForGameSettingsViewController() {
        // given
        let sut = viewController!
        sut.loadView()
        
        // when
        sut.viewDidLoad()
        
        // then
        let targets = sut.gameNameTextField.allTargets
        XCTAssertTrue(targets.contains(sut))
    }

    func test_GameSettingsViewController_WhenViewDidLoadCalled_ShouldAddTargetToEndingScoreTextFieldForGameSettingsViewController() {
        // given
        let sut = viewController!
        sut.loadView()
        
        // when
        sut.viewDidLoad()
        
        // then
        let targets = sut.endingScoreTextField.allTargets
        XCTAssertTrue(targets.contains(sut))
    }

    func test_GameSettingsViewController_WhenViewDidLoadCalled_ShouldAddTargetToNumberOfRoundsTextFieldForGameSettingsViewController() {
        // given
        let sut = viewController!
        sut.loadView()
        
        // when
        sut.viewDidLoad()
        
        // then
        let targets = sut.numberOfRoundTextField.allTargets
        XCTAssertTrue(targets.contains(sut))
    }
    
    
    // MARK: - gameEndType Binding
    
    func test_GameSettingsViewController_WhenBindingsSetGameEndTypeValueNone_ShouldSetGameTypeSegmentedControlToNone() {
        // given
        let sut = viewController!
        let viewModel = GameSettingsViewModelMock()
        sut.viewModel = viewModel
        sut.loadView()
        sut.gameEndTypeSegmentedControl.selectedSegmentIndex = 1
        
        // when
        sut.viewDidLoad()
        viewModel.gameEndType.value = GameEndType.none
        
        // then
        XCTAssertEqual(GameEndType(rawValue: sut.gameEndTypeSegmentedControl.selectedSegmentIndex)!, .none)
    }
    
    func test_GameSettingsViewController_WhenBindingsSetGameEndTypeNone_ShouldSetIsHiddenForEndingScoreAndNumberOfRoundStackViewsToTrue() {
        // given
        let sut = viewController!
        let viewModel = GameSettingsViewModelMock()
        sut.viewModel = viewModel
        sut.loadView()
        
        // when
        sut.viewDidLoad()
        viewModel.gameEndType.value = GameEndType.none
        
        // then
        XCTAssertTrue(sut.endingScoreStackView.isHidden)
        XCTAssertTrue(sut.numberOfRoundsStackView.isHidden)
    }
    
    func test_GameSettingsViewController_WhenBindingsSetGameEndTypeRound_ShouldSetIsHiddenForEndingScoreTrueAndNumberOfRoundsFalse() {
        // given
        let sut = viewController!
        let viewModel = GameSettingsViewModelMock()
        sut.viewModel = viewModel
        sut.loadView()
        
        // when
        sut.viewDidLoad()
        viewModel.gameEndType.value = GameEndType.round
        
        // then
        XCTAssertTrue(sut.endingScoreStackView.isHidden)
        XCTAssertFalse(sut.numberOfRoundsStackView.isHidden)
    }
    
    func test_GameSettingsViewController_WhenBindingsSetGameEndTypeScore_ShouldSetIsHiddenForEndingScoreFalseAndNumberOfRoundsTrue() {
        // given
        let sut = viewController!
        let viewModel = GameSettingsViewModelMock()
        sut.viewModel = viewModel
        sut.loadView()
        
        // when
        sut.viewDidLoad()
        viewModel.gameEndType.value = GameEndType.score
        
        // then
        XCTAssertFalse(sut.endingScoreStackView.isHidden)
        XCTAssertTrue(sut.numberOfRoundsStackView.isHidden)
    }
    
    
    // MARK: - dataValidationString
    
    func test_GameSettingsViewController_WhenBindingsSetDataValidationStringSetToBlank_ShouldSetInstructionLabelToBlankAndEnableSaveButton() {
        // given
        let sut = viewController!
        let viewModel = GameSettingsViewModelMock()
        sut.viewModel = viewModel
        sut.loadView()
        sut.viewDidLoad()
        
        // when
        viewModel.dataValidationString.value = ""
        
        // then
        XCTAssertEqual(sut.instructionLabel.text, "")
        XCTAssertTrue(sut.saveBarButton.isEnabled)
    }

    func test_GameSettingsViewController_WhenBindingsSetDataValidationStringSetToNotBlank_ShouldSetInstructionLabelToStringAndDisableSaveButton() {
        // given
        let sut = viewController!
        let viewModel = GameSettingsViewModelMock()
        sut.viewModel = viewModel
        sut.loadView()
        sut.viewDidLoad()
        
        // when
        viewModel.dataValidationString.value = "This is a test"
        
        // then
        XCTAssertEqual(sut.instructionLabel.text, "This is a test")
        XCTAssertFalse(sut.saveBarButton.isEnabled)
    }
    
    
    // MARK: - GameEndTypeSegmentedControlValueChanged
    
    func test_GameSettingsViewController_WhenGameEndTypeSegmentedControlValueChangedCalled_ShouldCallViewModelGameEndTypeChangedToRawValueWithGameEndTypeSegmentedControlValue() {
        // given
        let sut = viewController!
        let viewModel = GameSettingsViewModelMock()
        sut.viewModel = viewModel
        sut.loadView()
        sut.viewDidLoad()

        let gameEndTypeRawValue = Int.random(in: 0...2)
        sut.gameEndTypeSegmentedControl.selectedSegmentIndex = gameEndTypeRawValue
        
        // when
        sut.gameEndTypeSegmentedControlValueChanged(0)
        
        // then
        XCTAssertEqual(viewModel.gameEndTypeChangedCalledCount, 1)
        XCTAssertEqual(viewModel.gameEndTypeChangedRawValue, gameEndTypeRawValue)
    }
    
    
    // MARK: - ResetGameTapped
    
    func test_GameSettingsViewController_WhenResetGameButtonTapped_ShouldPresentAlertWithCorrectTitle() {
        // given
        let sut = GameSettingsViewControllerPresentMock()
        
        // when
        sut.resetButtonTapped(0)
        
        // then
        XCTAssertEqual(sut.presentCalledCount, 1)
        XCTAssertEqual((sut.viewControllerPresented as? UIAlertController)?.title, "Are you sure you want to reset?")
    }
    
    func test_GameSettingsViewController_WhenResetGameButtonTapped_ShouldPresentAlertWithCorrectMessage() {
        // given
        let sut = GameSettingsViewControllerPresentMock()
        
        // when
        sut.resetButtonTapped(0)
        
        // then
        XCTAssertEqual(sut.presentCalledCount, 1)
        XCTAssertEqual((sut.viewControllerPresented as? UIAlertController)?.message, "This will erase all of the game data and player scores")
    }
    
    func test_GameSettingsViewController_WhenResetButtonTapped_ShouldPresentAlertWithFirstActionCancel() {
        // given
        let sut = GameSettingsViewControllerPresentMock()
        
        // when
        sut.resetButtonTapped(0)
        
        // then
        let cancelAction = (sut.viewControllerPresented as? UIAlertController)?.actions.first
        XCTAssertNotNil(cancelAction)
        XCTAssertEqual(cancelAction?.title, "Cancel")
        XCTAssertEqual(cancelAction?.style, .cancel)
    }
    
    func test_GameSettingsViewController_WhenResetButtonTapped_ShouldPresentAlertWithTwoActions() {
        // given
        let sut = GameSettingsViewControllerPresentMock()
        
        // when
        sut.resetButtonTapped(0)
        
        // then
        let actions = (sut.viewControllerPresented as? UIAlertController)?.actions
        XCTAssertEqual(actions?.count, 2)
    }
    
    func test_GameSettingsViewController_WhenResetButtonTapped_ShouldPresentAlertWithFirstActionReset() {
        // given
        let sut = GameSettingsViewControllerPresentMock()
        
        // when
        sut.resetButtonTapped(0)
        
        // then
        let resetAction = (sut.viewControllerPresented as? UIAlertController)?.actions.last
        XCTAssertNotNil(resetAction)
        XCTAssertEqual(resetAction?.title, "Reset")
        XCTAssertEqual(resetAction?.style, .destructive)
    }
    
    func test_GameSettingsViewController_WhenResetButtonTapped_ShouldSetResetActionHandlerToBeResetHandler() {
        // given
        let sut = GameSettingsViewControllerPresentMock()
        let viewModelMock = GameSettingsViewModelMock()
        sut.viewModel = viewModelMock
        
        // when
        sut.resetButtonTapped(0)
        let resetAction = (sut.viewControllerPresented as? UIAlertController)?.actions.last as? TestableUIAlertAction
      
        resetAction?.handler!(UIAlertAction(title: "", style: .destructive))
        
        // then
        XCTAssertEqual(viewModelMock.resetGameCalledCount, 1)
    }
    
    
    // MARK: - DeleteGameButtonTapped
    
    func test_GameSettingsViewController_WhenDeleteGameButtonTappedCalled_ShouldPresentAlert() {
        // given
        let sut = GameSettingsViewControllerPresentMock()
        
        // when
        sut.deleteGameButtonTapped(0)
        
        // then
        XCTAssertEqual(sut.presentCalledCount, 1)
        XCTAssertTrue(sut.viewControllerPresented is UIAlertController)
    }
    
    func test_GameSettingsViewController_WhenDeleteGameButtonTappedCalled_ShouldPresentAlertWithCorrectTitleAndMessage() {
        // given
        let sut = GameSettingsViewControllerPresentMock()
        
        // when
        sut.deleteGameButtonTapped(0)
        
        // then
        let alertVC = sut.viewControllerPresented as? UIAlertController
        XCTAssertEqual(alertVC?.title, "Delete Game")
        XCTAssertEqual(alertVC?.message, "Are you sure? This will delete all data associated with this game.")
    }
    
    func test_GameSettingsViewController_WhenDeleteGameButtonTappedCalled_ShouldSetTwoActionsWithCorrectTitlesAndStyles() {
        // given
        let sut = GameSettingsViewControllerPresentMock()
        
        // when
        sut.deleteGameButtonTapped(0)
        
        // then
        let alertVC = sut.viewControllerPresented as? UIAlertController
        XCTAssertEqual(alertVC?.actions.count, 2)
        XCTAssertEqual(alertVC?.actions.first?.title, "Cancel")
        XCTAssertEqual(alertVC?.actions.first?.style, .cancel)
        XCTAssertEqual(alertVC?.actions[1].title, "Delete")
        XCTAssertEqual(alertVC?.actions[1].style, .destructive)
    }
    
    func test_GameSettingsViewController_WhenDeleteGameButtonTappedDeleteActionTriggered_ShouldCallViewModelDeleteGame() {
        // given
        let sut = GameSettingsViewControllerPresentMock()
        
        let viewModel = GameSettingsViewModelMock()
        sut.viewModel = viewModel
        
        // when
        sut.deleteGameButtonTapped(0)
        let alertVC = sut.viewControllerPresented as? UIAlertController
        let deleteAction = alertVC?.actions[1] as? TestableUIAlertAction
        
        deleteAction?.handler?(deleteAction!)
        
        // then
        XCTAssertEqual(viewModel.deleteGameCalledCount, 1)
    }
    
    // MARK: - GameNameEditingChanged
    
    func test_GameSettingsViewController_WhenGameNameTextFieldEditingChanged_ShouldCallViewModelSetGameName() {
        // given
        let sut = viewController!
        let viewModel = GameSettingsViewModelMock()
        sut.viewModel = viewModel

        sut.loadView()
        sut.viewDidLoad()

        let gameName = UUID().uuidString
        sut.gameNameTextField.text = gameName
        
        // when
        sut.gameNameTextField.sendActions(for: .editingChanged)
        
        // then
        XCTAssertEqual(viewModel.gameNameChangedCalledCount, 1)
        XCTAssertEqual(viewModel.gameNameChangedName, gameName)
    }
    
    // MARK: - EndingScoreEditingChanged

     func test_GameSettingsViewController_WhenEndingScoreTextFieldEditingChanged_ShouldCallViewModelSetEndingScore() {
        // given
        let sut = viewController!
        let viewModel = GameSettingsViewModelMock()
        sut.viewModel = viewModel

        sut.loadView()
        sut.viewDidLoad()

        let endingScore = Int.random(in: 1...1000)
        sut.endingScoreTextField.text = String(endingScore)
        
        // when
        sut.endingScoreTextField.sendActions(for: .editingChanged)
        
        // then
        XCTAssertEqual(viewModel.gameEndQuantityChangedCalledCount, 1)
        XCTAssertEqual(viewModel.gameEndQuantityChangedQuantity, endingScore)
    }
    
    
    // MARK: - NumberOfRoundsEditingChanged
    
    func test_GameSettingsViewController_WhenNumberOfRoundsTextFieldEditingChanged_ShouldCallViewModelSetNumberOfRounds() {
        // given
        let sut = viewController!
        let viewModel = GameSettingsViewModelMock()
        sut.viewModel = viewModel

        sut.loadView()
        sut.viewDidLoad()

        let numberOfRounds = Int.random(in: 1...1000)
        sut.numberOfRoundTextField.text = String(numberOfRounds)
        
        // when
        sut.numberOfRoundTextField.sendActions(for: .editingChanged)
        
        // then
        XCTAssertEqual(viewModel.gameEndQuantityChangedCalledCount, 1)
        XCTAssertEqual(viewModel.gameEndQuantityChangedQuantity, numberOfRounds)
    }
    
    
    // MARK: - LowestIsWinningChanged
    
    func test_GameSettingsViewController_WhenLowestIsWinningSwitchValueChanged_ShouldCallViewModelSetLowestIsWinning() {
        // given
        let sut = viewController!
        let viewModel = GameSettingsViewModelMock()
        sut.viewModel = viewModel

        sut.loadView()
        sut.viewDidLoad()
        
        // when
        let lowestIsWinning = Bool.random()
        sut.lowestWinsSwitch.isOn = lowestIsWinning

        sut.lowestIsWinningSwitchValueChanged(0)
        
        // then
        XCTAssertEqual(viewModel.lowestIsWinningValueChangedCalledCount, 1)
        XCTAssertEqual(viewModel.lowestIsWinningValueChangedBool, lowestIsWinning)
    }
    
    // MARK: - Save Changes
    
    func test_GameSettingsViewController_WhenSaveChangesCalled_ShouldCallViewModelSaveChanges() {
        // given
        let sut = viewController!
        let viewModel = GameSettingsViewModelMock()
        sut.viewModel = viewModel
        
        // when
        sut.saveChanges()
        
        // then
        XCTAssertEqual(viewModel.saveChangesCalledCount, 1)
    }
    
    func test_GameSettingsViewController_WhenSaveChangesCalled_ShouldCallPopViewControllerOnNavigationController() {
        
        // given
        let sut = viewController!
        let navigationController = NavigationControllerPopMock()
        
        navigationController.viewControllers = [sut]
        
        // when
        sut.saveChanges()
        
        // then
        XCTAssertEqual(navigationController.popViewControllerCount, 1)
    }
    
    
    class GameSettingsViewControllerPresentMock: GameSettingsViewController {
        var presentCalledCount = 0
        var viewControllerPresented: UIViewController?
        override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
            presentCalledCount += 1
            self.viewControllerPresented = viewControllerToPresent
        }
    }
}
