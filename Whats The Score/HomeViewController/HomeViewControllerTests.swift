//
//  HomeViewControllerTests.swift
//  What's The Score
//
//  Created by Curt McCune on 12/30/23.
//

import XCTest
@testable import Whats_The_Score

final class HomeViewControllerTests: XCTestCase {
    
    var viewController: HomeViewController!
    
    override func setUp() {
        let viewController = HomeViewController.instantiate()
        self.viewController = viewController
    }

    func test_HomeViewController_WhenViewLoaded_ShouldHaveNotNilForOutlets() {
        // given
        let sut = viewController!
        
        // when
        sut.loadView()
        
        // then
        XCTAssertNotNil(sut.titleLabel)
        XCTAssertNotNil(sut.quickStartButton)
        XCTAssertNotNil(sut.setupGameButton)
        
    }
    
    
    // MARK: - ViewDidLoad
    
    func test_MyGameViewController_WhenViewDidLoadCalled_ShouldSetAttributesForStrokeAndForegroundColorOnTitleLabel() {
        // given
        let sut = viewController!
        sut.loadView()
        
        // when
        sut.viewDidLoad()
        
        // then
        let attributes = sut.titleLabel.attributedText?.attributes(at: 0, effectiveRange: nil)
        XCTAssertEqual(attributes?[.foregroundColor] as? UIColor, .white)
        XCTAssertEqual(attributes?[.strokeWidth] as? CGFloat, -4.0)
        XCTAssertEqual(attributes?[.strokeColor] as? UIColor, .black)
    }
    
    func test_HomeViewController_WhenViewDidLoadHasActiveGame_ShouldSetContinueGameIsHiddenFalse() {
        // given
        let sut = viewController!
        sut.activeGame = GameMock()
        
        // when
        sut.loadView()
        sut.viewDidLoad()
        
        // then
        XCTAssertFalse(sut.continueGameButton.isHidden)
    }
    
    func test_HomeViewController_WhenViewDidLoadActiveGameNil_ShouldSetContinueGameIsHiddenTrue() {
        // given
        let sut = viewController!
        sut.activeGame = nil
        
        // when
        sut.loadView()
        sut.viewDidLoad()
        
        // then
        XCTAssertTrue(sut.continueGameButton.isHidden)
    }
    
    
    // MARK: - SetupGame
    
    func test_HomeViewController_WhenSetupGameButtonTapped_ShouldCallSetupNewGameOnCoordinator() {
        // given
        let sut = viewController!
        
        let coordinator = HomeTabCoordinatorMock(navigationController: RootNavigationController())
        
        sut.coordinator = coordinator
        
        // when
        sut.setupGameButtonTapped(4)
        
        // then
        XCTAssertEqual(coordinator.setupNewGameCalledCount, 1)
    }
    
    
    // MARK: - Quick Start
    
    func test_HomeViewController_WhenQuickStartButtonTapped_ShouldCallCoordinatorsSetupQuickGame() {
        // given
        let sut = viewController!
        
        let coordinator = HomeTabCoordinatorMock(navigationController: RootNavigationController())
        
        sut.coordinator = coordinator
        
        // when
        sut.quickStartButtonTapped(4)
        
        // then
        XCTAssertEqual(coordinator.setupQuickGameCalledCount, 1)
    }
    
    
    // MARK: - ContinueGame
    
    func test_HomeViewController_WhenContinueGameButtonTapped_ShouldCallCoordinatorsPlayActiveGame() {
        // given
        let sut = viewController!
        let coordinator = HomeTabCoordinatorMock(navigationController: RootNavigationController())
        
        sut.coordinator = coordinator
        
        // when
        sut.continueGameButtonTapped(0)
        
        // then
        XCTAssertEqual(coordinator.playActiveGameCalledCount, 1)
    }
    
    // MARK: - MyGamesButtonTapped
    
    func test_HomeViewController_WhenMyGamesButtonTapped_ShouldCallCoordinatorsShowMyGames() {
        // given
        let sut = viewController!
        let coordinator = HomeTabCoordinatorMock(navigationController: RootNavigationController())
        
        sut.coordinator = coordinator
        
        // when
        sut.myGamesButtonTapped(0)
        
        // then
        XCTAssertEqual(coordinator.showMyGamesCalledCount, 1)
    }

}
