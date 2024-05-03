//
//  GameEndTypeSelectionViewControllerTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 4/1/24.
//

import XCTest
@testable import Whats_The_Score

final class GameEndTypeSelectionViewControllerTests: XCTestCase {

    // MARK: - Setup

    var viewController: GameEndTypeSelectionViewController!
    
    override func setUp() {
        viewController = GameEndTypeSelectionViewController.instantiate()
    }
    
    override func tearDown() {
        viewController = nil
    }
    
    
    // MARK: - Outlets
    
    func test_GameEndTypeSelectionViewController_WhenLoaded_ShouldHaveNonNilOutlets() {
        // given
        let sut = viewController!
        
        // when
        sut.loadView()
        
        // then
        XCTAssertNotNil(sut.gameEndLabel)
        XCTAssertNotNil(sut.noneButton)
        XCTAssertNotNil(sut.roundButton)
        XCTAssertNotNil(sut.scoreButton)
    }
    
    
    // MARK: - ViewDidLoad
    
    func test_GameEndTypeSelectionViewController_WhenViewDidLoadCalled_ShouldCallSetAttributedUnderlinedTitleWithSubtextOnNoneButtonWithCorrectParameters() {
        // given
        let sut = viewController!
        sut.loadView()
        
        let button = UIButtonSetAttributedUnderlinedTitleWithSubtextMock()
        sut.noneButton = button
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(button.setAttributedUnderlinedTitleWithSubtextCalledCount, 1)
        XCTAssertEqual(button.setAttributedUnderlinedTitleWithSubtextTitle, "None")
        XCTAssertEqual(button.setAttributedUnderlinedTitleWithSubtextSubtext, "You will manually end the game when you are finished.")
    }
    
    func test_GameEndTypeSelectionViewController_WhenViewDidLoadCalled_ShouldCallSetAttributedUnderlinedTitleWithSubtextOnRoundButtonWithCorrectParameters() {
        // given
        let sut = viewController!
        sut.loadView()
        
        let button = UIButtonSetAttributedUnderlinedTitleWithSubtextMock()
        sut.roundButton = button
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(button.setAttributedUnderlinedTitleWithSubtextCalledCount, 1)
        XCTAssertEqual(button.setAttributedUnderlinedTitleWithSubtextTitle, "Round")
        XCTAssertEqual(button.setAttributedUnderlinedTitleWithSubtextSubtext, "The game ends after a certain number of rounds.")
    }

    func test_GameEndTypeSelectionViewController_WhenViewDidLoadCalled_ShouldCallSetAttributedUnderlinedTitleWithSubtextOnScoreButtonWithCorrectParameters() {
        // given
        let sut = viewController!
        sut.loadView()
        
        let button = UIButtonSetAttributedUnderlinedTitleWithSubtextMock()
        sut.scoreButton = button
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(button.setAttributedUnderlinedTitleWithSubtextCalledCount, 1)
        XCTAssertEqual(button.setAttributedUnderlinedTitleWithSubtextTitle, "Score")
        XCTAssertEqual(button.setAttributedUnderlinedTitleWithSubtextSubtext, "The game ends once a player reaches the end score.")
    }
    
    func test_GameEndTypeSelectedViewController_WhenViewDidLoadCalled_ShouldSetGameEndLabelWithCorrectStrokeWidthAndColor() {
        // given
        let sut = viewController!
        sut.loadView()
        
        // when
        sut.viewDidLoad()
        
        // then
        let attributedString = sut.gameEndLabel.attributedText
        XCTAssertEqual(attributedString?.string, "Game End")
        XCTAssertEqual(attributedString?.attributes(at: 0, effectiveRange: nil)[NSAttributedString.Key.strokeWidth] as? CGFloat, -4.0)
        XCTAssertEqual(attributedString?.attributes(at: 0, effectiveRange: nil)[NSAttributedString.Key.strokeColor] as? UIColor, .black)
    }
    
    
    // MARK: - NoneButtonTapped
    
    func test_GameEndTypeSelectionViewController_WhenNoneButtonTapped_ShouldCallGameSetupCoordinatorGameEndTypeSelectedWithNoneType() {
        // given
        let sut = viewController!
        
        let coordinator = GameSetupCoordinatorMock()
        sut.coordinator = coordinator
        
        // when
        sut.noneButtonTapped(0)
        
        // then
        XCTAssertEqual(coordinator.gameEndType, GameEndType.none)
        XCTAssertEqual(coordinator.gameEndTypeSelectedCalledCount, 1)
    }
    
    
    // MARK: - RoundButtonTapped
    
    func test_GameEndTypeSelectionViewController_WhenRoundButtonTapped_ShouldCallGameSetupCoordinatorGameEndTypeSelectedWithRoundType() {
        // given
        let sut = viewController!
        
        let coordinator = GameSetupCoordinatorMock()
        sut.coordinator = coordinator
        
        // when
        sut.roundButtonTapped(0)
        
        // then
        XCTAssertEqual(coordinator.gameEndType, GameEndType.round)
        XCTAssertEqual(coordinator.gameEndTypeSelectedCalledCount, 1)
    }
    
    
    // MARK: - RoundButtonTapped
    
    func test_GameEndTypeSelectionViewController_WhenScoreButtonTapped_ShouldCallGameSetupCoordinatorGameEndTypeSelectedWithScoreType() {
        // given
        let sut = viewController!
        
        let coordinator = GameSetupCoordinatorMock()
        sut.coordinator = coordinator
        
        // when
        sut.scoreButtonTapped(0)
        
        // then
        XCTAssertEqual(coordinator.gameEndType, GameEndType.score)
        XCTAssertEqual(coordinator.gameEndTypeSelectedCalledCount, 1)
    }
    
}
