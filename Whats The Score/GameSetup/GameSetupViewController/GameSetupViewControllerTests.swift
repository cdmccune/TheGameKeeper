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
    
    func test_GameSetupViewController_WhenViewDidLoad_ShouldSetSelfAsViewModelsDelegate() {
        // given
        let sut = viewController!
        sut.loadView()
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertNotNil(sut.viewModel?.delegate)
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
        XCTAssertEqual(sut.viewModel?.game.gameType, GameType(rawValue: selectedSegment)!)
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
        XCTAssertEqual(sut.viewModel?.game.gameEndType, GameEndType(rawValue: selectedSegment)!)
    }
    
    func test_GameSetupViewController_WhenNumberOfRoundsChangedNonIntValue_ShouldNotChangeViewModelsNumberOfRounds() {
        // given
        let sut = viewController!
        sut.loadView()
        
        let numberOfRounds = Int.random(in: 1...10)
        sut.viewModel?.game.numberOfRounds = numberOfRounds
        sut.numberOfRoundsTextField.text = ""
        
        // when
        sut.numberOfRoundsTextFieldValueChanged(4)
        
        // then
        XCTAssertEqual(sut.viewModel?.game.numberOfRounds, numberOfRounds)
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
        XCTAssertEqual(sut.viewModel?.game.numberOfRounds, numberOfRounds)
    }
    
    func test_GameSetupViewController_WhenEndingScoreChangedNotInt_ShouldNotChangeViewModelEndingScore() {
        // given
        let sut = viewController!
        sut.loadView()
        
        let endingScore = Int.random(in: 1...10)
        sut.viewModel?.game.endingScore = endingScore
        sut.endingScoreTextField.text = ""
        
        // when
        sut.endingScoreTextFieldValueChanged(4)
        
        // then
        XCTAssertEqual(sut.viewModel?.game.endingScore, endingScore)
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
        XCTAssertEqual(sut.viewModel?.game.endingScore, endingScore)
    }
    
    func test_GameSetupViewController_WhenNumberOfPlayersChangedNotInt_ShouldNotChangeViewModelNumberOfPlayers() {
        // given
        let sut = viewController!
        sut.loadView()
        
        let numberOfPlayers = Int.random(in: 1...10)
        sut.viewModel?.game.numberOfPlayers = numberOfPlayers
        sut.numberOfRoundsTextField.text = ""
        
        // when
        sut.numberOfPlayersTextFieldValueChanged(4)
        
        // then
        XCTAssertEqual(sut.viewModel?.game.numberOfPlayers, numberOfPlayers)
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
        XCTAssertEqual(sut.viewModel?.game.numberOfPlayers, numberOfPlayers)
    }
    
    // MARK: - Binding View
    
    func test_GameSetupViewController_WhenBindViewToGameCalled_ShouldSetValuesFromSettingToSegmentedControlsAndTextFields() {
        // given
        let sut = viewController!
        sut.loadView()
        
        let gameType = GameType(rawValue: (Int.random(in: 0..<GameType.allCases.count)))!
        let gameEndType = GameEndType(rawValue: Int.random(in: 0..<GameEndType.allCases.count))!
        let numberOfRounds = Int.random(in: 1...10)
        let endingScore = Int.random(in: 1...10)
        let numberOfPlayers = Int.random(in: 1...10)
        let game = Game(gameType: gameType, gameEndType: gameEndType, numberOfRounds: numberOfRounds, endingScore: endingScore, numberOfPlayers: numberOfPlayers)
        
        // when
        sut.bindViewToGame(with: game)
        
        // then
        XCTAssertEqual(sut.gameTypeSegmentedControl.selectedSegmentIndex, gameType.rawValue)
        XCTAssertEqual(sut.gameEndTypeSegmentedControl.selectedSegmentIndex, gameEndType.rawValue)
        XCTAssertEqual(sut.numberOfRoundsTextField.text, String(numberOfRounds))
        XCTAssertEqual(sut.endingScoreTextField.text, String(endingScore))
        XCTAssertEqual(sut.numberOfPlayersTextField.text, String(numberOfPlayers))
    }
    
    func test_GameSetupViewController_WhenBindViewToGameSettingCalledEndingScoreNil_ShouldSetEndingScoreTextFieldToEmptyString() {
        // given
        let sut = viewController!
        sut.loadView()
        
        let game = Game(gameType: .round,
                                        gameEndType: .round,
                                        numberOfRounds: 0,
                                        endingScore: nil,
                                        numberOfPlayers: 0)
        
        // when
        sut.bindViewToGame(with: game)
        
        // then
        XCTAssertEqual("", sut.endingScoreTextField.text)
    }
    
    func test_GameSetupViewController_WhenBindViewToGameCalledBasicGameType_ShouldHideAndShowCorrectStackViews() {
        // given
        let sut = viewController!
        sut.loadView()
        
        let game = Game(gameType: .basic,
                                        gameEndType: .round,
                                        numberOfRounds: 0,
                                        numberOfPlayers: 0)
        
        // when
        sut.bindViewToGame(with: game)
        
        // then
        XCTAssertFalse(sut.gameTypeStackView.isHidden)
        XCTAssertFalse(sut.endingScoreStackView.isHidden)
        XCTAssertFalse(sut.numberOfPlayersStackView.isHidden)
        XCTAssertTrue(sut.gameEndTypeStackView.isHidden)
        XCTAssertTrue(sut.numberOfRoundsStackView.isHidden)
    }
    
    func test_GameSetupViewController_WhenBindViewToGameCalledRoundGameTypeRoundGameEndType_ShouldHideAndShowCorrectStackViews() {
        // given
        let sut = viewController!
        sut.loadView()
        
        let game = Game(gameType: .round,
                                        gameEndType: .round,
                                        numberOfRounds: 0,
                                        numberOfPlayers: 0)
        
        // when
        sut.bindViewToGame(with: game)
        
        // then
        XCTAssertFalse(sut.gameTypeStackView.isHidden)
        XCTAssertFalse(sut.numberOfPlayersStackView.isHidden)
        XCTAssertFalse(sut.gameEndTypeStackView.isHidden)
        XCTAssertFalse(sut.numberOfRoundsStackView.isHidden)
        XCTAssertTrue(sut.endingScoreStackView.isHidden)
    }
    
    func test_GameSetupViewController_WhenBindViewToGameCalledRoundGameTypeScoreGameEndType_ShouldHideAndShowCorrectStackViews() {
        // given
        let sut = viewController!
        sut.loadView()
        
        let game = Game(gameType: .round,
                                        gameEndType: .score,
                                        numberOfRounds: 0,
                                        numberOfPlayers: 0)
        
        // when
        sut.bindViewToGame(with: game)
        
        // then
        XCTAssertFalse(sut.gameTypeStackView.isHidden)
        XCTAssertFalse(sut.numberOfPlayersStackView.isHidden)
        XCTAssertFalse(sut.gameEndTypeStackView.isHidden)
        XCTAssertFalse(sut.endingScoreStackView.isHidden)
        XCTAssertTrue(sut.numberOfRoundsStackView.isHidden)
    }
    
    func test_GameSetupViewController_WhenBindViewToGameCalledRoundGameTypeNoneGameEndType_ShouldHideAndShowCorrectStackViews() {
        // given
        let sut = viewController!
        sut.loadView()
        
        let game = Game(gameType: .round,
                                        gameEndType: .none,
                                        numberOfRounds: 0,
                                        numberOfPlayers: 0)
        
        // when
        sut.bindViewToGame(with: game)
        
        // then
        XCTAssertFalse(sut.gameTypeStackView.isHidden)
        XCTAssertFalse(sut.numberOfPlayersStackView.isHidden)
        XCTAssertFalse(sut.gameEndTypeStackView.isHidden)
        XCTAssertTrue(sut.endingScoreStackView.isHidden)
        XCTAssertTrue(sut.numberOfRoundsStackView.isHidden)
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
        
        let numberOfPlayers = Int.random(in: 100...10000)
        sut.viewModel?.game.numberOfPlayers = numberOfPlayers
        
        // when
        sut.continueButtonTapped(4)
        
        // then
        let viewModel = (navigationControllerMock.pushedViewController as? PlayerSetupViewController)?.viewModel
        
        XCTAssertEqual((viewModel as? PlayerSetupViewModel)?.game.numberOfPlayers, numberOfPlayers)
    }
    
}