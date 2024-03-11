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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "Home View Controller") as? HomeViewController else {
            fatalError("HomeViewController wasn't found")
        }
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
    
    
    // MARK: - SetupGame
    
    func test_HomeViewController_WhenSetupGameButtonTapped_ShouldNavigateToSecondTabInTabbarController() {
        // given
        let sut = viewController!
        let viewController2 = UIViewController()
        let tabbarItem = UITabBarItem()
        viewController2.tabBarItem = tabbarItem
        
        let tabbarController = TabbarControllerMock()
        tabbarController.viewControllers = [sut, viewController2]
        
        // when
        sut.setupGameButtonTapped(4)
        
        // then
        XCTAssertEqual(tabbarController.selectedIndex, 1)
    }
    
    
    // MARK: - Quick Start
    
    func test_HomeViewController_WhenQuickStartButtonTapped_ShouldPushScoreboardViewController() {
        // given
        let sut = viewController!
        
        let navigationControllerMock = NavigationControllerPushMock()
        navigationControllerMock.viewControllers = [sut]
        
        // when
        sut.quickStartButtonTapped(0)
        
        // then
        XCTAssertEqual(navigationControllerMock.pushViewControllerCount, 1)
        XCTAssertTrue(navigationControllerMock.pushedViewController is ScoreboardViewController)
    }
    
    func test_HomeViewController_WhenQuickStartButtonTapped_ShouldPushScoreboardViewControllerWithViewModel() {
        // given
        let sut = viewController!
        
        let navigationControllerMock = NavigationControllerPushMock()
        navigationControllerMock.viewControllers = [sut]
        
        // when
        sut.quickStartButtonTapped(0)
        
        // then
        let scoreboardVC = navigationControllerMock.pushedViewController as? ScoreboardViewController
        let scoreboardViewModel = scoreboardVC?.viewModel
        XCTAssertNotNil(scoreboardViewModel)
    }
    
    func test_HomeViewController_WhenQuickStartButtonTapped_ShouldPushScoreboardViewControllerWithViewModelWithCorrectGameSettings() {
        // given
        let sut = viewController!
        
        let navigationControllerMock = NavigationControllerPushMock()
        navigationControllerMock.viewControllers = [sut]
        
        // when
        sut.quickStartButtonTapped(0)
        
        // then
        let scoreboardVC = navigationControllerMock.pushedViewController as? ScoreboardViewController
        let scoreboardViewModel = scoreboardVC?.viewModel
        let game = scoreboardViewModel?.game
        XCTAssertEqual(game?.gameEndType, GameEndType.none)
        XCTAssertEqual(game?.gameType, .basic)
        XCTAssertEqual(game?.players.count, 2)
        XCTAssertEqual(scoreboardViewModel?.sortPreference.value, .score)
    }

}
