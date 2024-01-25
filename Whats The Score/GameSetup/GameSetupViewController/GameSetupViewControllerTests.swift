//
//  GameSetupViewControllerTests.swift
//  What's The Score Tests
//
//  Created by Curt McCune on 12/30/23.
//

import XCTest
@testable import Whats_The_Score

final class GameSetupViewControllerTests: XCTestCase {

    var viewController: GameSetupViewController!
    
    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "GameSetupViewController") as? GameSetupViewController else {
            fatalError("GameSetupViewControlller Wasn't Found")
        }
        self.viewController = viewController
    }
    
    override func tearDown() {
        viewController = nil
    }
    
    // MARK: - Initialization
    
    func test_GameSetupViewController_WhenLoaded_ShouldHaveNonNilOutlets() {
        // given
        let sut = viewController!

        // when
        sut.loadView()

        // then
        XCTAssertNotNil(sut.gameTypeStackView)
        XCTAssertNotNil(sut.gameTypeLabel)
        XCTAssertNotNil(sut.gameTypeSegmentedControl)
        
        XCTAssertNotNil(sut.gameEndTypeStackView)
        XCTAssertNotNil(sut.gameEndTypeLabel)
        XCTAssertNotNil(sut.gameEndTypeSegmentedControl)
        
        XCTAssertNotNil(sut.numberOfRoundsStackView)
        XCTAssertNotNil(sut.numberOfRoundsLabel)
        XCTAssertNotNil(sut.numberOfRoundsTextField)
        
        XCTAssertNotNil(sut.endingScoreStackView)
        XCTAssertNotNil(sut.endingScoreLabel)
        XCTAssertNotNil(sut.endingScoreTextField)
        
        XCTAssertNotNil(sut.numberOfPlayersStackView)
        XCTAssertNotNil(sut.numberOfPlayersLabel)
        XCTAssertNotNil(sut.numberOfPlayersTextField)
    }
    
    func test_GameSetupViewController_WhenInitialized_ShouldCreateGameSetupViewModel() {
        // given
        let sut = viewController!
        
        // then
        XCTAssertNotNil(sut.viewModel)
    }
    
    func test_GameSetupViewController_WhenViewDidLoadCalled_ShouldCallViewModelsSetInitialValues() {
        // given
        let sut = viewController!
        
        let viewModelMock = GameSetupViewModelMock()
        sut.viewModel = viewModelMock
        
        // when
        sut.loadView()
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(viewModelMock.setInitialValuesCalledCount, 1)
    }
    
    
    // MARK: - Value Changing
    
    func test_GameSetupViewController_WhenGameTypeSegmentedControlChanged_ShouldChangeViewModelsGameType() {
        // given
        let sut = viewController!
        sut.loadView()
        
        let selectedSegment = Int.random(in: 0..<GameType.allCases.count)
        sut.gameTypeSegmentedControl.selectedSegmentIndex = selectedSegment
        
        // when
        sut.gameTypeSegmentedControlValueChanged(4)
        
        // then
        XCTAssertEqual(sut.viewModel?.gameType.value, GameType(rawValue: selectedSegment)!)
    }
    
    func test_GameSetupViewController_WhenGameEndTypeSegmentedControlChanged_ShouldChangeViewModelsGameEndType() {
        // given
        let sut = viewController!
        sut.loadView()
        
        let selectedSegment = Int.random(in: 0..<GameEndType.allCases.count)
        sut.gameEndTypeSegmentedControl.selectedSegmentIndex = selectedSegment
        
        // when
        sut.gameEndTypeSegmentedControlValueChanged(4)
        
        // then
        XCTAssertEqual(sut.viewModel?.gameEndType.value, GameEndType(rawValue: selectedSegment)!)
    }
    
    func test_GameSetupViewController_WhenNumberOfRoundsChangedNonIntValue_ShouldNotChangeViewModelsNumberOfRounds() {
        // given
        let sut = viewController!
        sut.loadView()
        
        let numberOfRounds = Int.random(in: 1...10)
        sut.viewModel?.numberOfRounds.value = numberOfRounds
        sut.numberOfRoundsTextField.text = ""
        
        // when
        sut.numberOfRoundsTextFieldValueChanged(4)
        
        // then
        XCTAssertEqual(sut.viewModel?.numberOfRounds.value, numberOfRounds)
    }
    
    func test_GameSetupViewController_WhenNumberOfRoundsChanged_ShouldChangeViewModelsNumberOfRounds() {
        // given
        let sut = viewController!
        sut.loadView()
        
        let numberOfRounds = Int.random(in: 1...10)
        sut.numberOfRoundsTextField.text = String(numberOfRounds)
        
        // when
        sut.numberOfRoundsTextFieldValueChanged(4)
        
        // then
        XCTAssertEqual(sut.viewModel?.numberOfRounds.value, numberOfRounds)
    }
    
    func test_GameSetupViewController_WhenEndingScoreChangedNotInt_ShouldNotChangeViewModelEndingScore() {
        // given
        let sut = viewController!
        sut.loadView()
        
        let endingScore = Int.random(in: 1...10)
        sut.viewModel?.endingScore.value = endingScore
        sut.endingScoreTextField.text = ""
        
        // when
        sut.endingScoreTextFieldValueChanged(4)
        
        // then
        XCTAssertEqual(sut.viewModel?.endingScore.value, endingScore)
    }
    
    func test_GameSetupViewController_WhenEndingScoreChanged_ShouldChangeViewModelEndingScore() {
        // given
        let sut = viewController!
        sut.loadView()
        
        let endingScore = Int.random(in: 1...10)
        sut.endingScoreTextField.text = String(endingScore)
        
        // when
        sut.endingScoreTextFieldValueChanged(4)
        
        // then
        XCTAssertEqual(sut.viewModel?.endingScore.value, endingScore)
    }
    
    func test_GameSetupViewController_WhenNumberOfPlayersChangedNotInt_ShouldNotChangeViewModelNumberOfPlayers() {
        // given
        let sut = viewController!
        sut.loadView()
        
        let numberOfPlayers = Int.random(in: 1...10)
        sut.viewModel?.numberOfPlayers.value = numberOfPlayers
        sut.numberOfRoundsTextField.text = ""
        
        // when
        sut.numberOfPlayersTextFieldValueChanged(4)
        
        // then
        XCTAssertEqual(sut.viewModel?.numberOfPlayers.value, numberOfPlayers)
    }
    
    func test_GameSetupViewController_WhenNumberOfPlayersChanged_ShouldChangeViewModelNumberOfPlayers() {
        // given
        let sut = viewController!
        sut.loadView()
        
        let numberOfPlayers = Int.random(in: 1...10)
        sut.numberOfPlayersTextField.text = String(numberOfPlayers)
        
        // when
        sut.numberOfPlayersTextFieldValueChanged(4)
        
        // then
        XCTAssertEqual(sut.viewModel?.numberOfPlayers.value, numberOfPlayers)
    }
    
    // MARK: - Binding View
    
    func test_GameSetupViewController_WhenViewDidLoadCalledAndViewModelGameTypeChanged_ShouldSetGameTypeSegmentedControlToNewValue() {
        // given
        let sut = viewController!
        let gameType = GameType(rawValue: 1)!
        
        sut.loadView()
        sut.viewDidLoad()
        
        sut.gameTypeSegmentedControl.selectedSegmentIndex = 0
        
        // when
        sut.viewModel?.gameType.value = gameType
        
        // then
        XCTAssertEqual(sut.gameTypeSegmentedControl.selectedSegmentIndex, 1)
    }
    
    func test_GameSetupViewController_WhenViewDidLoadCalledAndViewModelGameEndTypeChanged_ShouldSetGameTypeSegmentedControlToNewValue() {
        // given
        let sut = viewController!
        let gameEndType = GameEndType(rawValue: 1)!
        
        sut.loadView()
        sut.viewDidLoad()
        
        sut.gameEndTypeSegmentedControl.selectedSegmentIndex = 0
        
        // when
        sut.viewModel?.gameEndType.value = gameEndType
        
        // then
        XCTAssertEqual(sut.gameEndTypeSegmentedControl.selectedSegmentIndex, 1)
    }
    
    func test_GameSetupViewController_WhenViewDidLoadCalledAndViewModelNumberOfRoundsChanged_ShouldSetNumberOfRoundsTextFieldToNewValue() {
        // given
        let sut = viewController!
        
        sut.loadView()
        sut.viewDidLoad()
        
        sut.numberOfRoundsTextField.text = nil
        let numberOfRounds = Int.random(in: 10...10000)
        
        // when
        sut.viewModel?.numberOfRounds.value = numberOfRounds
        
        // then
        XCTAssertEqual(sut.numberOfRoundsTextField.text, String(numberOfRounds))
    }
    
    func test_GameSetupViewController_WhenViewDidLoadCalledAndViewModelNumberOfPlayersChanged_ShouldSetNumberOfPlayersTextFieldToNewValue() {
        // given
        let sut = viewController!
        
        sut.loadView()
        sut.viewDidLoad()
        
        sut.numberOfPlayersTextField.text = nil
        let numberOfPlayers = Int.random(in: 10...10000)
        
        // when
        sut.viewModel?.numberOfPlayers.value = numberOfPlayers
        
        // then
        XCTAssertEqual(sut.numberOfPlayersTextField.text, String(numberOfPlayers))
    }
    
    func test_GameSetupViewController_WhenViewDidLoadCalledAndViewModelEndGameScoreChanged_ShouldSetEndGameScoreTextFieldToNewValue() {
        // given
        let sut = viewController!
        
        sut.loadView()
        sut.viewDidLoad()
        
        sut.endingScoreTextField.text = nil
        let endingScoreTextField = Int.random(in: 10...10000)
        
        // when
        sut.viewModel?.endingScore.value = endingScoreTextField
        
        // then
        XCTAssertEqual(sut.endingScoreTextField.text, String(endingScoreTextField))
    }

    
    func test_GameSetupViewController_WhenViewDidLoadCalledAndViewModelAndGameEndChangedToBasic_ShouldHideGameEndTypeNumberOfRoundsAndEndingScoreStackViews() {
        // given
        let sut = viewController!
        sut.loadView()
        sut.viewDidLoad()
        
        sut.gameEndTypeStackView.isHidden = false
        sut.numberOfRoundsStackView.isHidden = false
        sut.endingScoreStackView.isHidden = false
        
        // when
        sut.viewModel?.gameType.value = .basic
        
        // then
        XCTAssertTrue(sut.gameEndTypeStackView.isHidden)
        XCTAssertTrue(sut.numberOfRoundsStackView.isHidden)
        XCTAssertTrue(sut.endingScoreStackView.isHidden)
    }
    
    func test_GameSetupViewController_WhenViewDidLoadCalledAndViewModelAndGameEndChangedToNotBasic_ShouldShowGameEndTypeStackView() {
        // given
        let sut = viewController!
        sut.loadView()
        sut.viewDidLoad()
        
        sut.gameEndTypeStackView.isHidden = true
        
        // when
        sut.viewModel?.gameType.value = .round
        
        // then
        XCTAssertFalse(sut.gameEndTypeStackView.isHidden)
    }
    
    func test_GameSetupViewController_WhenViewDidLoadCalledAndViewModelAndGameTypeChangedToNotBasicAndGameEndTypeRound_ShouldShowGameEndAndNumberOfRoundsStackViewAndHideScoreEndStackView() {
        // given
        let sut = viewController!
        sut.loadView()
        sut.viewDidLoad()
        
        sut.gameEndTypeStackView.isHidden = true
        sut.numberOfRoundsStackView.isHidden = true
        sut.endingScoreStackView.isHidden = false
        
        // when
        sut.viewModel?.gameEndType.value = .round
        sut.viewModel?.gameType.value = .round
        
        // then
        XCTAssertFalse(sut.gameEndTypeStackView.isHidden)
        XCTAssertFalse(sut.numberOfRoundsStackView.isHidden)
        XCTAssertTrue(sut.endingScoreStackView.isHidden)
    }
    
    func test_GameSetupViewController_WhenViewDidLoadCalledAndViewModelAndGameTypeNotBasicAndGameEndChangedTypeRound_ShouldShowGameEndAndNumberOfRoundsStackViewAndHideScoreEndStackView() {
        // given
        let sut = viewController!
        sut.loadView()
        sut.viewDidLoad()
        
        sut.gameEndTypeStackView.isHidden = true
        sut.numberOfRoundsStackView.isHidden = true
        sut.endingScoreStackView.isHidden = false
        
        // when
        sut.viewModel?.gameType.value = .round
        sut.viewModel?.gameEndType.value = .round
        
        // then
        XCTAssertFalse(sut.gameEndTypeStackView.isHidden)
        XCTAssertFalse(sut.numberOfRoundsStackView.isHidden)
        XCTAssertTrue(sut.endingScoreStackView.isHidden)
    }
    
    func test_GameSetupViewController_WhenViewDidLoadCalledAndViewModelAndGameTypeChangedToNotBasicAndGameEndTypeScore_ShouldShowGameEndAndEndingScoreStackViewAndHideNumberOfRoundsStackView() {
        // given
        let sut = viewController!
        sut.loadView()
        sut.viewDidLoad()
        
        sut.gameEndTypeStackView.isHidden = true
        sut.numberOfRoundsStackView.isHidden = false
        sut.endingScoreStackView.isHidden = true
        
        // when
        sut.viewModel?.gameEndType.value = .score
        sut.viewModel?.gameType.value = .round
        
        // then
        XCTAssertFalse(sut.gameEndTypeStackView.isHidden)
        XCTAssertTrue(sut.numberOfRoundsStackView.isHidden)
        XCTAssertFalse(sut.endingScoreStackView.isHidden)
    }
    
    func test_GameSetupViewController_WhenViewDidLoadCalledAndViewModelAndGameTypeNotBasicAndGameEndChangedTypeScore_ShouldShowGameEndAndEndingScoreStackViewAndHideNumberOfRoundsStackView() {
        // given
        let sut = viewController!
        sut.loadView()
        sut.viewDidLoad()
        
        sut.gameEndTypeStackView.isHidden = true
        sut.numberOfRoundsStackView.isHidden = false
        sut.endingScoreStackView.isHidden = true
        
        // when
        sut.viewModel?.gameType.value = .round
        sut.viewModel?.gameEndType.value = .score
        
        // then
        XCTAssertFalse(sut.gameEndTypeStackView.isHidden)
        XCTAssertTrue(sut.numberOfRoundsStackView.isHidden)
        XCTAssertFalse(sut.endingScoreStackView.isHidden)
    }
    
    // MARK: - Navigation
    
    func test_GameSetupViewController_WhenContinueTapped_ShouldInstantiatePlayerSetupViewController() {
        // given
        let sut = viewController!
        let navigationControllerMock = NavigationControllerPushMock()
        navigationControllerMock.viewControllers = [sut]
        
        // when
        sut.continueButtonTapped(4)
        
        // then
        XCTAssertEqual(navigationControllerMock.pushViewControllerCount, 1)
        XCTAssertTrue(navigationControllerMock.pushedViewController is PlayerSetupViewController)
    }
    
    func test_GameSetupViewController_WhenContinueTapped_ShouldCreatePlayerSetupViewModelWithCorrectSettings() {
        // given
        let sut = viewController!
        let navigationControllerMock = NavigationControllerPushMock()
        navigationControllerMock.viewControllers = [sut]
        
        let numberOfPlayers = Int.random(in: 1...10)
        sut.viewModel?.numberOfPlayers.value = numberOfPlayers
        
        let gameType = GameType.round
        sut.viewModel?.gameType.value = gameType
        
        let gameEndType = GameEndType.score
        sut.viewModel?.gameEndType.value = gameEndType
        
        let numberOfRounds = Int.random(in: 0...100)
        sut.viewModel?.numberOfRounds.value = numberOfRounds
        
        let endingScore = Int.random(in: 0...100)
        sut.viewModel?.endingScore.value = endingScore
    
        
        // when
        sut.continueButtonTapped(4)
        
        // then
        let viewModel = (navigationControllerMock.pushedViewController as? PlayerSetupViewController)?.viewModel
        
        XCTAssertEqual((viewModel as? PlayerSetupViewModel)?.game.players.count, numberOfPlayers)
        XCTAssertEqual((viewModel as? PlayerSetupViewModel)?.game.gameEndType, gameEndType)
        XCTAssertEqual((viewModel as? PlayerSetupViewModel)?.game.gameType, gameType)
        XCTAssertEqual((viewModel as? PlayerSetupViewModel)?.game.numberOfRounds, numberOfRounds)
        XCTAssertEqual((viewModel as? PlayerSetupViewModel)?.game.endingScore, endingScore)
    }
    
}
