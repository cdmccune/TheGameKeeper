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
    
    func test_GameSettingsViewController_WhenSaveBarButtonLoaded_ShouldHaveTitleSaveAndTargetOfVC() {
        // given
        let sut = viewController!
        
        // when
        let saveBarButton = sut.saveBarButton
        
        // then
        XCTAssertEqual(saveBarButton.title, "Save")
        XCTAssertTrue(saveBarButton.target is GameSettingsViewController)
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
    
    
    // MARK: - numberOfRoundsTextFieldEditingDidEnd
    
    func test_GameSettingsViewController_WhenNumberOfRoundsTextFieldEditingDidEndCalledTextIsInt_ShouldSetViewModelNumberOfRoundsToText() {
        // given
        let sut = viewController!
        let viewModel = GameSettingsViewModelMock()
        sut.viewModel = viewModel
        
        let textField = UITextField()
        let numberOfRounds = Int.random(in: 1...1000)
        textField.text = String(numberOfRounds)
        sut.numberOfRoundTextField = textField
        
        // when
        sut.numberOfRoundsTextFieldEditingDidEnd(0)
        
        // then
        XCTAssertEqual(viewModel.numberOfRounds, numberOfRounds)
    }
    
    func test_GameSettingsViewController_WhenNumberOfRoundsTextFieldEditingDidEndCalledTextNotInt_ShouldNotChangeViewModelNumberOfRounds() {
        // given
        let sut = viewController!
        let viewModel = GameSettingsViewModelMock()
        sut.viewModel = viewModel
        
        let numberOfRounds = Int.random(in: 1...1000)
        viewModel.numberOfRounds = numberOfRounds
        
        let textField = UITextField()
        textField.text = "fdsf"
        sut.numberOfRoundTextField = textField
        
        // when
        sut.numberOfRoundsTextFieldEditingDidEnd(0)
        
        // then
        XCTAssertEqual(viewModel.numberOfRounds, numberOfRounds)
    }
    
    
    // MARK: - endingScoreTextFieldEditingDidEnd
    
    func test_GameSettingsViewController_WhenEndingScoreTextFieldEditingDidEndCalledTextIsInt_ShouldSetViewModeEndingScoreToText() {
        // given
        let sut = viewController!
        let viewModel = GameSettingsViewModelMock()
        sut.viewModel = viewModel
        
        let textField = UITextField()
        let endingScore = Int.random(in: 1...1000)
        textField.text = String(endingScore)
        sut.endingScoreTextField = textField
        
        // when
        sut.endingScoreTextFieldEditingDidEnd(0)
        
        // then
        XCTAssertEqual(viewModel.endingScore, endingScore)
    }
    
    func test_GameSettingsViewController_WhenEndingScoreTextFieldEditingDidEndCalledTextNotInt_ShouldNotChangeViewModelEndingScore() {
        // given
        let sut = viewController!
        let viewModel = GameSettingsViewModelMock()
        sut.viewModel = viewModel
        
        let endingScore = Int.random(in: 1...1000)
        viewModel.endingScore = endingScore
        
        let textField = UITextField()
        textField.text = "fdsf"
        sut.endingScoreTextField = textField
        
        // when
        sut.endingScoreTextFieldEditingDidEnd(0)
        
        // then
        XCTAssertEqual(viewModel.endingScore, endingScore)
    }
    
    
    // MARK: - GameEndTypeSegmentedControlValueChanged
    
    func test_GameSettingsViewController_WhenGameEndTypeSegmentedControlValueChangedCalled_ShouldSetViewModelGameEndTypeValueToGameEndTypeSegmentedControlValue() {
        // given
        let sut = viewController!
        sut.loadView()
        let viewModel = GameSettingsViewModelMock()
        sut.viewModel = viewModel
        
        let gameEndTypeRawValue = Int.random(in: 0...2)
        sut.gameEndTypeSegmentedControl.selectedSegmentIndex = gameEndTypeRawValue
        
        let expectation = XCTestExpectation(description: "GameEndType's value should be changed")
        
        viewModel.gameEndType.valueChanged = { gameEndType in
            expectation.fulfill()
            XCTAssertEqual(GameEndType(rawValue: gameEndTypeRawValue), gameEndType)
        }
        
        // when
        sut.gameEndTypeSegmentedControlValueChanged(0)
        
        // then
        wait(for: [expectation], timeout: 0.1)
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
}
