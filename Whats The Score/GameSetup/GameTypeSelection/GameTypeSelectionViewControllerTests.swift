//
//  GameTypeSelectionViewControllerTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 4/1/24.
//

import XCTest
@testable import Whats_The_Score

final class GameTypeSelectionViewControllerTests: XCTestCase {
    
    // MARK: - Setup

    var viewController: GameTypeSelectionViewController!
    
    override func setUp() {
        viewController = GameTypeSelectionViewController.instantiate()
    }
    
    override func tearDown() {
        viewController = nil
    }
    
    
    // MARK: - Outlets
    
    func test_GameTypeSelectionViewController_WhenLoaded_ShouldHaveNonNilOutlets() {
        // given
        let sut = viewController!
        
        // when
        sut.loadView()
        
        // then
        XCTAssertNotNil(sut.gameTypeLabel)
        XCTAssertNotNil(sut.basicButton)
        XCTAssertNotNil(sut.roundButton)
    }
    
    
    // MARK: - ViewDidLoad
    
    func test_GameTypeSelectionViewController_WhenViewDidLoadCalled_ShouldCallSetAttributedUnderlinedTitleWithSubtextOnRoundButtonWithCorrectParameters() {
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
        XCTAssertEqual(button.setAttributedUnderlinedTitleWithSubtextSubtext, "Round based game where points are added to players when the round is ended. Allows for conditions for winning to be set.")
    }
    
    func test_GameTypeSelectionViewController_WhenViewDidLoadCalled_ShouldCallSetAttributedUnderlinedTitleWithSubtextOnBasicButtonWithCorrectParameters() {
        // given
        let sut = viewController!
        sut.loadView()
        
        let button = UIButtonSetAttributedUnderlinedTitleWithSubtextMock()
        sut.basicButton = button
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(button.setAttributedUnderlinedTitleWithSubtextCalledCount, 1)
        XCTAssertEqual(button.setAttributedUnderlinedTitleWithSubtextTitle, "Basic")
        XCTAssertEqual(button.setAttributedUnderlinedTitleWithSubtextSubtext, "A simple game where points are added individually to players and game is manually ended")
    }
    
    func test_GameTypeSelectedViewController_WhenViewDidLoadCalled_ShouldSetGameTypeLabelWithCorrectStrokeWidthAndColor() {
        // given
        let sut = viewController!
        sut.loadView()
        
        // when
        sut.viewDidLoad()
        
        // then
        let attributedString = sut.gameTypeLabel.attributedText
        XCTAssertEqual(attributedString?.string, "GameType")
        XCTAssertEqual(attributedString?.attributes(at: 0, effectiveRange: nil)[NSAttributedString.Key.strokeWidth] as? CGFloat, -4.0)
        XCTAssertEqual(attributedString?.attributes(at: 0, effectiveRange: nil)[NSAttributedString.Key.strokeColor] as? UIColor, .black)
    }
    
    // MARK: - BasicButtonTapped
    
    func test_GameTypeSelectionViewController_WhenBasicButtonTappedCalled_ShouldCallCoordinatorGameTypeSelectedWithBasic() {
        // given
        let sut = viewController!
        
        let coordinator = GameSetupCoordinatorMock()
        sut.coordinator = coordinator
        
        // when
        sut.basicButtonTapped(0)
        
        // then
        XCTAssertEqual(coordinator.gameType, .basic)
        XCTAssertEqual(coordinator.gameTypeSelectedCalledCount, 1)
    }
    
    // MARK: - roundButtonTapped
    
    func test_GameTypeSelectionViewController_WhenRoundButtonTappedCalled_ShouldCallCoordinatorGameTypeSelectedWithRound() {
        // given
        let sut = viewController!
        
        let coordinator = GameSetupCoordinatorMock()
        sut.coordinator = coordinator
        
        // when
        sut.roundButtonTapped(0)
        
        // then
        XCTAssertEqual(coordinator.gameType, .round)
        XCTAssertEqual(coordinator.gameTypeSelectedCalledCount, 1)
    }

}
