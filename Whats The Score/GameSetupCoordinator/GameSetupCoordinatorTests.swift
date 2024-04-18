//
//  GameSetupCoordinatorTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 3/21/24.
//

import XCTest
@testable import Whats_The_Score

final class GameSetupCoordinatorTests: XCTestCase {

    // MARK: - Start
    
    func test_GameSetupCoordinator_WhenStartCalled_ShouldSetNavigationControllerViewControllerAsGameTypeSelectionViewController() {
        // given
        let navigationController = RootNavigationController()
        let sut = GameSetupCoordinator(navigationController: navigationController)
        
        // when
        sut.start()
        
        // then
        XCTAssertTrue(navigationController.viewControllers.first is GameTypeSelectionViewController)
    }
    
    func test_GameSetupCoordinator_WhenStartCalled_ShouldSetGameTypeSelectionViewControllerCoordinatorAsSelf() {
        // given
        let navigationController = RootNavigationController()
        let sut = GameSetupCoordinator(navigationController: navigationController)
        
        // when
        sut.start()
        
        // then
        let gameTypeSelectionVC = navigationController.viewControllers.first as? GameTypeSelectionViewController
        XCTAssertTrue(gameTypeSelectionVC?.coordinator === sut)
    }

    
    // MARK: - GameTypeSelected
    
    func test_GameSetupCoordinator_WhenGameTypeSelected_ShouldStoreGameTypeInGameTypeProperty() {
        // given
        let sut = GameSetupCoordinator(navigationController: RootNavigationController())
        
        let gameType = GameType(rawValue: Int.random(in: 0..<GameType.allCases.count))!
        
        // when
        sut.gameTypeSelected(gameType)
        
        // then
        XCTAssertEqual(sut.gameType, gameType)
    }
    
    func test_GameSetupCoordinator_WhenGameTypeSelectedCalledRound_ShouldPushGameEndTypeSelectionViewController() {
        // given
        let navigationController = RootNavigationControllerPushMock()
        let sut = GameSetupCoordinator(navigationController: navigationController)
        
        // when
        sut.gameTypeSelected(.round)
        
        // then
        XCTAssertEqual(navigationController.pushViewControllerCount, 1)
        XCTAssertTrue(navigationController.pushedViewController is GameEndTypeSelectionViewController)
    }
    
    func test_GameSetupCoordinator_WhenGameTypeSelectedCalledRound_ShouldSetSelfAsGameEndTypeSelectionViewController() {
        // given
        let navigationController = RootNavigationControllerPushMock()
        let sut = GameSetupCoordinator(navigationController: navigationController)
        
        // when
        sut.gameTypeSelected(.round)
        
        // then
        let gameEndTypeSelectionVC = navigationController.pushedViewController as? GameEndTypeSelectionViewController
        XCTAssertTrue(gameEndTypeSelectionVC?.coordinator === sut)
         
    }
    
    func test_GameSetupCoordinator_WhenGameTypeSelectedCalledBasic_ShouldPushPlayerSetupViewController() {
        // given
        let navigationController = RootNavigationControllerPushMock()
        let sut = GameSetupCoordinator(navigationController: navigationController)
        
        // when
        sut.gameTypeSelected(.basic)
        
        // then
        XCTAssertEqual(navigationController.pushViewControllerCount, 1)
        XCTAssertTrue(navigationController.pushedViewController is PlayerSetupViewController)
    }
    
    func test_GameSetupCoordinator_WhenGameTypeSelectedCalledBasic_ShouldSetPlayerSetupViewControllerViewModelWithSelfAsCoordinator() {
        // given
        let navigationController = RootNavigationControllerPushMock()
        let sut = GameSetupCoordinator(navigationController: navigationController)
        
        // when
        sut.gameTypeSelected(.basic)
        
        // then
        let playerSetupVC = navigationController.pushedViewController as? PlayerSetupViewController
        XCTAssertNotNil(playerSetupVC?.viewModel)
        XCTAssertTrue(playerSetupVC?.viewModel?.coordinator === sut)
    }
    
    
    // MARK: - GameEndTypeSelected
    
    func test_GameSetupCoordinator_WhenGameEndTypeSelectedCalled_ShouldStoreGameEndTypeInGameEndTypeProperty() {
        // given
        let sut = GameSetupCoordinator(navigationController: RootNavigationController())
        
        let gameEndType = GameEndType(rawValue: Int.random(in: 0..<GameEndType.allCases.count))!
        
        // when
        sut.gameEndTypeSelected(gameEndType)
        
        // then
        XCTAssertEqual(sut.gameEndType, gameEndType)
    }
    
    func test_GameSetupCoordinator_WhenGameEndTypeSelectedCalledNone_ShouldPushPlayerSetupViewController() {
        // given
        let navigationController = RootNavigationControllerPushMock()
        let sut = GameSetupCoordinator(navigationController: navigationController)
        
        // when
        sut.gameEndTypeSelected(GameEndType.none)
        
        // then
        XCTAssertEqual(navigationController.pushViewControllerCount, 1)
        XCTAssertTrue(navigationController.pushedViewController is PlayerSetupViewController)
    }
    
    func test_GameSetupCoordinator_WhenGameEndTypeSelectedCalledNone_ShouldSetPlayerSetupViewControllerViewModelWithSelfAsCoordinator() {
        // given
        let navigationController = RootNavigationControllerPushMock()
        let sut = GameSetupCoordinator(navigationController: navigationController)
        
        // when
        sut.gameEndTypeSelected(GameEndType.none)
        
        // then
        let playerSetupVC = navigationController.pushedViewController as? PlayerSetupViewController
        XCTAssertNotNil(playerSetupVC?.viewModel)
        XCTAssertTrue(playerSetupVC?.viewModel?.coordinator === sut)
    }
    
    func test_GameSetupCoordinator_WhenGameEndTypeSelectedCalledRound_ShouldPresentGameEndQuantitySelectionPopoverViewControllerOnTopViewController() {
        // given
        let sut = GameSetupCoordinator(navigationController: RootNavigationController())
        let viewController = ViewControllerPresentMock()
        sut.navigationController.viewControllers = [viewController]
        
        // when
        sut.gameEndTypeSelected(GameEndType.round)
        
        // then
        XCTAssertEqual(viewController.presentCalledCount, 1)
        XCTAssertTrue(viewController.presentViewController is GameEndQuantitySelectionPopoverViewController)
    }
    
    func test_GameSetupCoordinator_WhenGameEndTypeSelectedCalledScore_ShouldPresentGameEndQuantitySelectionPopoverViewControllerOnTopViewController() {
        // given
        let sut = GameSetupCoordinator(navigationController: RootNavigationController())
        let viewController = ViewControllerPresentMock()
        sut.navigationController.viewControllers = [viewController]
        
        // when
        sut.gameEndTypeSelected(GameEndType.score)
        
        // then
        XCTAssertEqual(viewController.presentCalledCount, 1)
        XCTAssertTrue(viewController.presentViewController is GameEndQuantitySelectionPopoverViewController)
    }
    
    func test_GameSetupCoordinator_WhenGameEndTypeSelectionCalledRoundOrScore_ShouldPassGameEndTypeToVCAndSetSelfAsCoordinator() {
        let sut = GameSetupCoordinator(navigationController: RootNavigationController())
        let viewController = ViewControllerPresentMock()
        sut.navigationController.viewControllers = [viewController]
        
        let gameEndType: GameEndType = Bool.random() ? .score : .round
        
        // when
        sut.gameEndTypeSelected(gameEndType)
        
        // then
        let gameEndQuantityPopover = viewController.presentViewController as? GameEndQuantitySelectionPopoverViewController
        XCTAssertEqual(gameEndQuantityPopover?.gameEndType, gameEndType)
        XCTAssertIdentical(gameEndQuantityPopover?.coordinator, sut)
    }
    
    func test_ScoreCoordinator_WhenGameEndTypeSelectedCalledNotNone_ShouldCallDefaultPopoverPresenterSetupPopoverCenteredWithCorrectArguments() {
        // given
        let sut = GameSetupCoordinator(navigationController: RootNavigationController())
        let viewController = ViewControllerPresentMock()
        sut.navigationController.viewControllers = [viewController]
        
        let view = UIView()
        viewController.view = view
        
        let defaultPopoverPresenterMock = DefaultPopoverPresenterMock()
        sut.defaultPopoverPresenter = defaultPopoverPresenterMock
        
        // when
        sut.gameEndTypeSelected(.round)
        
        // then
        XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredCalledCount, 1)
        XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredWidth, 300)
        XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredHeight, 151)
        XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredView, view)
        XCTAssertTrue(defaultPopoverPresenterMock.setupPopoverCenteredPopoverVC is GameEndQuantitySelectionPopoverViewController)
        XCTAssertTrue(defaultPopoverPresenterMock.setupPopoverCenteredTapToExit ?? false)
    }
    
    
    // MARK: - GameEndQuantitySelected
    
    func test_GameSetupCoordinator_WhenGameEndQuatitySelectedCalled_ShouldStoreGameEndQuantityInGameEndQuantityProperty() {
        // given
        let sut = GameSetupCoordinator(navigationController: RootNavigationController())
        
        let gameEndQuantity = Int.random(in: 0...1000)
        
        // when
        sut.gameEndQuantitySelected(gameEndQuantity)
        
        // then
        XCTAssertEqual(sut.gameEndQuantity, gameEndQuantity)
    }
    
    func test_GameSetupCoordinator_WhenGameEndQuantitySelectedCalled_ShouldPushPlayerSetupViewController() {
        // given
        let navigationController = RootNavigationControllerPushMock()
        let sut = GameSetupCoordinator(navigationController: navigationController)
        
        // when
        sut.gameEndQuantitySelected(0)
        
        // then
        XCTAssertEqual(navigationController.pushViewControllerCount, 1)
        XCTAssertTrue(navigationController.pushedViewController is PlayerSetupViewController)
    }
    
    func test_GameSetupCoordinator_WhenGameEndQuantitySelectedCalled_ShouldSetPlayerSetupViewControllerViewModelWithSelfAsCoordinator() {
        // given
        let navigationController = RootNavigationControllerPushMock()
        let sut = GameSetupCoordinator(navigationController: navigationController)
        
        // when
        sut.gameEndQuantitySelected(0)
        
        // then
        let playerSetupVC = navigationController.pushedViewController as? PlayerSetupViewController
        XCTAssertNotNil(playerSetupVC?.viewModel)
        XCTAssertTrue(playerSetupVC?.viewModel?.coordinator === sut)
    }
    
    
    // MARK: - PlayersSetup
    
//    func test_GameSetupCoordinator_WhenPlayersSetupCalled_ShouldSetPlayerSettingsToPlayerSettingsVariable() {
//        // given
//        let sut = GameSetupCoordinator(navigationController: RootNavigationController())
////        let playerSettings = [PlayerSettings(name: UUID().uuidString)]
//        
//        // when
//        sut.playersSetup([])
//        
//        // then
//        <#then#>
//    }
    
    func test_GameSetupCoordinator_WhenPlayersSetupCalled_ShouldPushGameNameViewControllerWithCoordinatorAsSelf() {
        // given
        let navigationController = RootNavigationControllerPushMock()
        let sut = GameSetupCoordinator(navigationController: navigationController)
        
        // when
        sut.playersSetup([])
        
        // then
        let gameNameVC = navigationController.pushedViewController as? GameNameViewController
        XCTAssertIdentical(gameNameVC?.coordinator, sut)
    }
    
    
    // MARK: - GameNameSet
    
    func test_GameSetupCoordinator_WhenGameNameCalled_ShouldCallGameTabCoordinatorGameSetupCompleteWithCorrectArguments() {
        // given
        let sut = GameSetupCoordinator(navigationController: RootNavigationController())

        let coordinator = GameTabCoordinatorMock()
        sut.coordinator = coordinator
        
        let gameType = GameType.allCases.randomElement()!
        let gameEndType = GameEndType.allCases.randomElement()!
        let gameEndQuantity = Int.random(in: 1...1000)
        let gameName = UUID().uuidString
//        let players = [PlayerMock()]
        
        sut.gameType = gameType
        sut.gameEndType = gameEndType
        sut.gameEndQuantity = gameEndQuantity
        
        // when
        sut.gameNameSet(gameName)
        
        // then
        XCTAssertEqual(coordinator.gameSetupCompleteGameType, gameType)
        XCTAssertEqual(coordinator.gameSetupCompleteGameEndType, gameEndType)
        XCTAssertEqual(coordinator.gameSetupCompleteGameEndQuantity, gameEndQuantity)
        XCTAssertEqual(coordinator.gameSetupCompleteName, gameName)
//        XCTAssertEqual(coordinator.gameSetupCompletePlayers as? [PlayerMock], players)
    }
}
