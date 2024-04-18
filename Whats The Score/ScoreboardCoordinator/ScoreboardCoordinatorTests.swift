//
//  ScoreboardCoordinatorTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 3/21/24.
//

import XCTest
@testable import Whats_The_Score

final class ScoreboardCoordinatorTests: XCTestCase {
    
    // MARK: - Helper Functions
    
    func getSutAndViewControllerOnTopOfNavigationController() -> (ScoreboardCoordinator, ViewControllerPresentMock) {
        let sut = ScoreboardCoordinator(navigationController: RootNavigationController())
        let viewController = ViewControllerPresentMock()
        sut.navigationController.viewControllers = [viewController]
        
        return (sut, viewController)
    }
    
    
    // MARK: - Properties
    
    func test_ScoreboardCoordinator_WhenInitialized_ShouldSetEndRoundPopoverHeightHelperToObjectIWthHeighOf45AndSeperatorOf3() {
        // given
        let sut = ScoreboardCoordinator(navigationController: RootNavigationController())
        
        // when
        let endRoundPopoverHeightHelper = sut.endRoundPopoverHeightHelper
        
        // then
        XCTAssertTrue(endRoundPopoverHeightHelper is EndRoundPopoverHeightHelper)
        XCTAssertEqual(endRoundPopoverHeightHelper.playerViewHeight, 45)
        XCTAssertEqual(endRoundPopoverHeightHelper.playerSeperatorHeight, 3)
    }
    
    func test_ScoreboardCoordinator_WhenInitialized_ShouldSetDefaultPopoverPresenterToDefaultPopoverPresenter() {
        // given
        // when
        let sut = ScoreboardCoordinator(navigationController: RootNavigationController())
        
        // then
        XCTAssertTrue(sut.defaultPopoverPresenter is DefaultPopoverPresenter)
    }
    
    
    // MARK: - Start

    func test_ScoreboardCoordinator_WhenStartCalledGameNil_ShouldDoNothingToNavigationCoordinator() {
        // given
        let navigationController = RootNavigationController()
        let sut = ScoreboardCoordinator(navigationController: navigationController)
        sut.game = nil
        
        // when
        sut.start()
        
        // then
        XCTAssertTrue(navigationController.viewControllers.isEmpty)
    }
    
    func test_ScoreboardCoordinator_WhenStartCalledGameNotNil_ShouldSetScoreboardViewControllerAsOnlyNavigationControllerViewController() {
        // given
        let navigationController = RootNavigationController()
        let sut = ScoreboardCoordinator(navigationController: navigationController)
        sut.game = GameMock()
        
        // when
        sut.start()
        
        // then
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        XCTAssertTrue(navigationController.viewControllers.first is ScoreboardViewController)
    }
    
    func test_ScoreboardCoordinator_WhenStartCalled_ShouldSetScoreboardViewModelWithGameEqualToItsGameAndSelfAsCoordinator() {
        // given
        let navigationController = RootNavigationController()
        let sut = ScoreboardCoordinator(navigationController: navigationController)
        let game = GameMock()
        sut.game = game
        
        // when
        sut.start()
        
        // then
        let scoreboardVC = navigationController.viewControllers.first as? ScoreboardViewController
        XCTAssertNotNil(scoreboardVC?.viewModel)
        XCTAssertTrue(scoreboardVC?.viewModel?.game.isEqualTo(game: game) ?? false)
        XCTAssertTrue(scoreboardVC?.viewModel?.coordinator === sut)
    }
    
    func test_ScoreboardCoordinator_WhenStartCalled_ShouldSetScoreboardViewModelsCoreDataStoreAsOwnCoreDataStore() {
        // given
        let navigationController = RootNavigationController()
        let coreDataStore = CoreDataStoreMock()
        let sut = ScoreboardCoordinator(navigationController: navigationController, coreDataStore: coreDataStore)
        sut.game = GameMock()
        
        // when
        sut.start()
        
        // then
        let scoreboardVC = navigationController.viewControllers.first as? ScoreboardViewController
        XCTAssertTrue(scoreboardVC?.viewModel?.coreDataStore as? CoreDataStoreMock === coreDataStore)
    }
    
    
    // MARK: - ShowGameHistory
    
    func test_ScoreboardCoordinator_WhenShowGameHistoryCalled_ShouldPushGameHistoryViewControllerOnNavigationController() {
        // given
        let navigationController = RootNavigationControllerPushMock()
        let sut = ScoreboardCoordinator(navigationController: navigationController)
        
        // when
        sut.showGameHistory(withGame: GameMock(), andDelegate: GameHistoryViewControllerDelegateMock())
        
        // then
        XCTAssertEqual(navigationController.pushViewControllerCount, 1)
        XCTAssertTrue(navigationController.pushedViewController is GameHistoryViewController)
    }
    
    func test_ScoreboardCoordinator_WhenShowGameHistoryCalled_ShouldSetGameHistoryVCViewModelAndGameToInputGameAndSelfAsCoordinator() {
        // given
        let navigationController = RootNavigationControllerPushMock()
        let sut = ScoreboardCoordinator(navigationController: navigationController)
        
        let game = GameMock()
        
        // when
        sut.showGameHistory(withGame: game, andDelegate: GameHistoryViewControllerDelegateMock())
        
        // then
        let gameHistoryVC = navigationController.pushedViewController as? GameHistoryViewController
        XCTAssertNotNil(gameHistoryVC?.viewModel)
        XCTAssertTrue(gameHistoryVC?.viewModel.game.isEqualTo(game: game) ?? false)
        XCTAssertTrue(gameHistoryVC?.viewModel.coordinator === sut)
    }
    
    func test_ScoreboardCoordinator_WhenShowGameHistoryCalled_ShouldSetGameHistoryViewModelCoreDataStoreToSelfCoreDataStore() {
        // given
        let navigationController = RootNavigationControllerPushMock()
        let coreDataStore = CoreDataStoreMock()
        let sut = ScoreboardCoordinator(navigationController: navigationController, coreDataStore: coreDataStore)
        
        // when
        sut.showGameHistory(withGame: GameMock(), andDelegate: GameHistoryViewControllerDelegateMock())
        
        // then
        let gameHistoryVC = navigationController.pushedViewController as? GameHistoryViewController
        XCTAssertTrue(gameHistoryVC?.viewModel.coreDataStore as? CoreDataStoreMock === coreDataStore)
    }
    
    
    func test_ScoreboardCoordinator_WhenShowGameHistoryCalled_ShouldSetGameHistoryVCDelegateEqualToDelegateSent() {
        // given
        let navigationController = RootNavigationControllerPushMock()
        let sut = ScoreboardCoordinator(navigationController: navigationController)
        
        let delegate = GameHistoryViewControllerDelegateMock()
        
        // when
        sut.showGameHistory(withGame: GameMock(), andDelegate: delegate)
        
        // then
        let gameHistoryVC = navigationController.pushedViewController as? GameHistoryViewController
        XCTAssertTrue(gameHistoryVC?.delegate as? GameHistoryViewControllerDelegateMock === delegate)
    }

    
    // MARK: - ShowSettings
    
    func test_ScoreboardCoordinator_WhenShowSettingsCalled_ShouldPushGameSettingsViewControllerOnNavigationController() {
        // given
        let navigationController = RootNavigationControllerPushMock()
        let sut = ScoreboardCoordinator(navigationController: navigationController)
        
        // when
        sut.showSettings(withGame: GameMock(), andDelegate: GameSettingsDelegateMock())
        
        // then
        XCTAssertEqual(navigationController.pushViewControllerCount, 1)
        XCTAssertTrue(navigationController.pushedViewController is GameSettingsViewController)
    }
    
    func test_ScoreboardCoordinator_WhenShowSettingsCalled_ShouldSetGameSettingsViewModelWithGameAndDelegate() {
        // given
        let navigationController = RootNavigationControllerPushMock()
        let sut = ScoreboardCoordinator(navigationController: navigationController)
        
        let game = GameMock()
        let delegate = GameSettingsDelegateMock()
        
        // when
        sut.showSettings(withGame: game, andDelegate: delegate)
        
        // then
        let gameSettingsVC = navigationController.pushedViewController as? GameSettingsViewController
        XCTAssertNotNil(gameSettingsVC?.viewModel)
        XCTAssertTrue(gameSettingsVC?.viewModel?.game.isEqualTo(game: game) ?? false)
        XCTAssertTrue(gameSettingsVC?.viewModel?.delegate as? GameSettingsDelegateMock === delegate)
    }

    
    // MARK: - ShowEndRoundPopover
    
    func test_ScoreboardCoordinator_WhenShowEndRoundPopoverCalled_ShouldCallPresentEndRoundPopoverOnViewControllerOnTopViewController() {
        // given
        let (sut, viewController) = getSutAndViewControllerOnTopOfNavigationController()
        
        // when
        sut.showEndRoundPopover(withEndRound: EndRoundSettings.getStub(withPlayerCount: 0), andDelegate: EndRoundPopoverDelegateProtocolMock())
        
        // then
        XCTAssertEqual(viewController.presentCalledCount, 1)
        XCTAssertTrue(viewController.presentViewController is EndRoundPopoverViewController)
    }
    
    func test_ScoreboardCoordinator_WhenShowEndRoundPopoverCalled_ShouldSetEndRoundPopoverVCEndRoundSettingsAndDelegateEqualToDelegate() {
        // given
        let (sut, viewController) = getSutAndViewControllerOnTopOfNavigationController()
        
        let delegate = EndRoundPopoverDelegateProtocolMock()
        let endRoundSettings = EndRoundSettings(scoreChangeSettingsArray: [], roundNumber: 0, endRoundID: UUID())
        
        // when
        sut.showEndRoundPopover(withEndRound: endRoundSettings, andDelegate: delegate)
        
        // then
        let endRoundPopoverVC = viewController.presentViewController as? EndRoundPopoverViewController
        XCTAssertTrue(endRoundPopoverVC?.delegate as? EndRoundPopoverDelegateProtocolMock === delegate)
        XCTAssertEqual(endRoundPopoverVC?.endRound, endRoundSettings)
    }
    
    func test_ScoreboardCoordinator_WhenShowEndRoundPopoverCalled_ShouldSetEndRoundPopoverVCPlayerHeightAndSeperatorEqualToEndRoundPopoverHeightHelperValues() {
        // given
        let (sut, viewController) = getSutAndViewControllerOnTopOfNavigationController()
        
        let endRoundHeightHelper = EndRoundPopoverHeightHelperMock()
        let playerHeight = Int.random(in: 1...1000)
        let playerSeperatorHeight = Int.random(in: 1...1000)
        endRoundHeightHelper.playerViewHeight = playerHeight
        endRoundHeightHelper.playerSeperatorHeight = playerSeperatorHeight
        sut.endRoundPopoverHeightHelper = endRoundHeightHelper

        // when
        sut.showEndRoundPopover(withEndRound: EndRoundSettings.getStub(withPlayerCount: 0), andDelegate: EndRoundPopoverDelegateProtocolMock())
        
        // then
        let endRoundPopoverVC = viewController.presentViewController as? EndRoundPopoverViewController
        XCTAssertEqual(endRoundPopoverVC?.playerViewHeight, playerHeight)
        XCTAssertEqual(endRoundPopoverVC?.playerSeparatorHeight, playerSeperatorHeight)
    }
    
    func test_ScoreboardCoordinator_WhenShowEndRoundPopoverCalled_ShouldCallEndRoundPopoverHeightGetPopoverHeightForWithCorrectProperties() {
        // given
        let (sut, viewController) = getSutAndViewControllerOnTopOfNavigationController()
        
        // Property 1 - Player count
        let playerCount = Int.random(in: 1...5)
        
        // Property 2 - Safe area height
        let safeAreaHeight = CGFloat.random(in: 1...1000)
        let view = UIViewSafeAreaLayoutFrameMock(safeAreaFrame: CGRect(x: 0, y: 0, width: 0, height: safeAreaHeight))
        viewController.view = view
        
        let endRoundHeightHelper = EndRoundPopoverHeightHelperMock()
        sut.endRoundPopoverHeightHelper = endRoundHeightHelper
        
        // when
        sut.showEndRoundPopover(withEndRound: EndRoundSettings.getStub(withPlayerCount: playerCount), andDelegate: EndRoundPopoverDelegateProtocolMock())
        
        // then
        XCTAssertEqual(endRoundHeightHelper.getPopoverHeightForCalledCount, 1)
        XCTAssertEqual(endRoundHeightHelper.getPopoverHeightForPlayerCount, playerCount)
        XCTAssertEqual(endRoundHeightHelper.getPopoverHeightForSafeAreaHeight, safeAreaHeight)
    }
    
    func test_ScoreboardCoordinator_WhenShowEndRoundPopoverCalled_ShouldCallDefaultPopoverPresenterSetupPopoverCenteredWithHeightFromEndRoundPopoverPresenterGetPopoverHeightFor() {
        // given
        let (sut, viewController) = getSutAndViewControllerOnTopOfNavigationController()
        
        let view = UIView()
        viewController.view = view
        
        let getPopoverHeightForHeight = CGFloat.random(in: 1...1000)
        let endRoundPopoverHeightHelper = EndRoundPopoverHeightHelperMock()
        endRoundPopoverHeightHelper.heightToReturn = getPopoverHeightForHeight
        sut.endRoundPopoverHeightHelper = endRoundPopoverHeightHelper
        
        let defaultPopoverPresenter = DefaultPopoverPresenterMock()
        sut.defaultPopoverPresenter = defaultPopoverPresenter
        
        
        // when
        sut.showEndRoundPopover(withEndRound: EndRoundSettings.getStub(withPlayerCount: 0), andDelegate: EndRoundPopoverDelegateProtocolMock())
        
        // then
        XCTAssertEqual(defaultPopoverPresenter.setupPopoverCenteredCalledCount, 1)
        XCTAssertEqual(defaultPopoverPresenter.setupPopoverCenteredHeight, getPopoverHeightForHeight)
    }
    
    func test_ScoreboardCoordinator_WhenShowEndRoundPopoverCalled_ShouldCallDefaultPopoverPresenterSetupPopoverCenteredWithRestOfTheCorrectArguments() {
        // given
        let (sut, viewController) = getSutAndViewControllerOnTopOfNavigationController()
        
        let view = UIView()
        viewController.view = view
        
        let defaultPopoverPresenterMock = DefaultPopoverPresenterMock()
        sut.defaultPopoverPresenter = defaultPopoverPresenterMock
        
        // when
        sut.showEndRoundPopover(withEndRound: EndRoundSettings.getStub(withPlayerCount: 0), andDelegate: EndRoundPopoverDelegateProtocolMock())
        
        // then
        XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredView, view)
        XCTAssertTrue(defaultPopoverPresenterMock.setupPopoverCenteredPopoverVC is EndRoundPopoverViewController)
        XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredWidth, 300)
        XCTAssertTrue(defaultPopoverPresenterMock.setupPopoverCenteredTapToExit ?? false)
    }
    
    
    // MARK: - ShowEditPlayerPopover
    
    func test_ScoreboardCoordinator_WhenShowEditPlayerPopoverCalled_ShouldCallPresentEditPlayerPopoverViewControllerOnViewControllerOnTopViewController() {
        // given
        let (sut, viewController) = getSutAndViewControllerOnTopOfNavigationController()
        
        // when
        sut.showEditPlayerPopover(withPlayer: PlayerMock(), andDelegate: EditPlayerPopoverDelegateProtocolMock())
        
        // then
        XCTAssertEqual(viewController.presentCalledCount, 1)
        XCTAssertTrue(viewController.presentViewController is EditPlayerPopoverViewController)
    }
    
    func test_ScoreboardCoordinator_WhenShowEditPlayerPopoverCalled_ShouldSetEditPlayerPopoverVCsDelegateAndPlayerSettings() {
        // given
        let (sut, viewController) = getSutAndViewControllerOnTopOfNavigationController()
        
        let delegate = EditPlayerPopoverDelegateProtocolMock()
        let player = PlayerMock()
        
        // when
        sut.showEditPlayerPopover(withPlayer: player, andDelegate: delegate)
        
        // then
        let editPlayerPopoverVC = viewController.presentViewController as? EditPlayerPopoverViewController
        XCTAssertEqual(editPlayerPopoverVC?.player?.id, player.id)
        XCTAssertEqual(editPlayerPopoverVC?.player?.name, player.name)
        XCTAssertTrue(editPlayerPopoverVC?.delegate as? EditPlayerPopoverDelegateProtocolMock === delegate)
    }
    
    func test_ScoreboardCoordinator_WhenShowEditPlayerPopoverCalled_ShouldCallDefaultPopoverPresenterSetupPopoverCenteredWithCorrectArguments() {
        // given
        let (sut, viewController) = getSutAndViewControllerOnTopOfNavigationController()
        
        let view = UIView()
        viewController.view = view
        
        let defaultPopoverPresenterMock = DefaultPopoverPresenterMock()
        sut.defaultPopoverPresenter = defaultPopoverPresenterMock
        
        // when
        sut.showEditPlayerPopover(withPlayer: PlayerMock(), andDelegate: EditPlayerPopoverDelegateProtocolMock())
        
        // then
        XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredCalledCount, 1)
        XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredWidth, 300)
        XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredHeight, 165)
        XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredView, view)
        XCTAssertTrue(defaultPopoverPresenterMock.setupPopoverCenteredPopoverVC is EditPlayerPopoverViewController)
        XCTAssertTrue(defaultPopoverPresenterMock.setupPopoverCenteredTapToExit ?? false)
    }
    
    
    // MARK: - ShowEditPlayerScorePopover
    
    func test_ScoreboardCoordinator_WhenShowEditPlayerScorePopoverCalled_ShouldPresentEditPlayerScorePopoverViewControllerOnViewControllerOnTopViewController() {
        // given
        let (sut, viewController) = getSutAndViewControllerOnTopOfNavigationController()
        
        // when
        sut.showEditPlayerScorePopover(withScoreChange: ScoreChangeSettings.getStub(), andDelegate: ScoreboardPlayerEditScorePopoverDelegateMock())
        
        // then
        XCTAssertEqual(viewController.presentCalledCount, 1)
        XCTAssertTrue(viewController.presentViewController is ScoreboardPlayerEditScorePopoverViewController)
    }
    
    func test_ScoreboardCoordinator_WhenShowEditPlayerScorePopoverCalled_ShouldSetEditPlayerScorePopoverVsDelegateAndScoreChange() {
        // given
        let (sut, viewController) = getSutAndViewControllerOnTopOfNavigationController()
        
        let scoreChange = ScoreChangeSettings.getStub()
        let delegate = ScoreboardPlayerEditScorePopoverDelegateMock()
        
        // when
        sut.showEditPlayerScorePopover(withScoreChange: scoreChange, andDelegate: delegate)
        
        // then
        let editPlayerScorePopoverVC = viewController.presentViewController as? ScoreboardPlayerEditScorePopoverViewController
        XCTAssertTrue(editPlayerScorePopoverVC?.scoreChangeSettings == scoreChange)
        XCTAssertTrue(editPlayerScorePopoverVC?.delegate as? ScoreboardPlayerEditScorePopoverDelegateMock === delegate)
    }
    
    func test_ScoreboardCoordinator_WhenShowEditPlayerScorePopoverCalled_ShouldCallDefaultPopoverPresenterSetupPopoverCenteredWithCorrectArguements() {
        // given
        let (sut, viewController) = getSutAndViewControllerOnTopOfNavigationController()
        
        let view = UIView()
        viewController.view = view
        
        let defaultPopoverPresenterMock = DefaultPopoverPresenterMock()
        sut.defaultPopoverPresenter = defaultPopoverPresenterMock
        
        // when
        sut.showEditPlayerScorePopover(withScoreChange: ScoreChangeSettings.getStub(), andDelegate: ScoreboardPlayerEditScorePopoverDelegateMock())
        
        // then
        XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredCalledCount, 1)
        XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredWidth, 300)
        XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredHeight, 200)
        XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredView, view)
        XCTAssertTrue(defaultPopoverPresenterMock.setupPopoverCenteredPopoverVC is ScoreboardPlayerEditScorePopoverViewController)
        XCTAssertTrue(defaultPopoverPresenterMock.setupPopoverCenteredTapToExit ?? false)
    }
    
    
    // MARK: - ShowEndGamePopover
    
    func test_ScoreboardCoordinator_WhenShowEndGamePopoverCalled_ShouldSetEndGamePopoverVCGameAndDelegate() {
        // given
        let (sut, viewController) = getSutAndViewControllerOnTopOfNavigationController()
        
        let game = GameMock()
        let delegate = EndGamePopoverDelegateMock()
        sut.dispatchQueue = DispatchQueueMainMock()
        
        // when
        sut.showEndGamePopover(withGame: game, andDelegate: delegate)
        
        // then
        let endGamePopoverVC = viewController.presentViewController as? EndGamePopoverViewController
        XCTAssertTrue(endGamePopoverVC?.game?.isEqualTo(game: game) ?? false)
        XCTAssertTrue(endGamePopoverVC?.delegate as? EndGamePopoverDelegateMock === delegate)
    }
    
    func test_ScoreboardCoordinator_WhenShowEndGamePopoverCalledGameIsOver_ShouldCallDefaultPopoverPresenterSetupPopoverCenteredWithTapToExitFalse() {
        // given
        let (sut, _) = getSutAndViewControllerOnTopOfNavigationController()
        
        let defaultPopoverPresenterMock = DefaultPopoverPresenterMock()
        sut.defaultPopoverPresenter = defaultPopoverPresenterMock
        
        let game = GameIsEndOfGameMock()
        game.isEndOfGameBool = true
        
        // when
        sut.showEndGamePopover(withGame: game, andDelegate: EndGamePopoverDelegateMock())
        
        // then
        XCTAssertFalse(defaultPopoverPresenterMock.setupPopoverCenteredTapToExit ?? true)
    }
    
    func test_ScoreboardCoordinator_WhenShowEndGamePopoverCalledGameIsOverFalse_ShouldCallDefaultPopoverPresenterSetupPopoverCenteredWithTapToExitTrue() {
        // given
        let (sut, _) = getSutAndViewControllerOnTopOfNavigationController()
        
        let defaultPopoverPresenterMock = DefaultPopoverPresenterMock()
        sut.defaultPopoverPresenter = defaultPopoverPresenterMock
        
        let game = GameIsEndOfGameMock()
        game.isEndOfGameBool = false
        
        // when
        sut.showEndGamePopover(withGame: game, andDelegate: EndGamePopoverDelegateMock())
        
        // then
        XCTAssertTrue(defaultPopoverPresenterMock.setupPopoverCenteredTapToExit ?? false)
    }
    
    func test_ScoreboardCoordinator_WhenShowEndGamePopoverCalled_ShouldCallDefaultPopoverPresenterSetupPopoverCenteredWithRestOfArgumentsCorrect() {
        // given
        let (sut, viewController) = getSutAndViewControllerOnTopOfNavigationController()
        
        let view = UIView()
        viewController.view = view
        
        let defaultPopoverPresenterMock = DefaultPopoverPresenterMock()
        sut.defaultPopoverPresenter = defaultPopoverPresenterMock
        
        // when
        sut.showEndGamePopover(withGame: GameMock(), andDelegate: EndGamePopoverDelegateMock())
        
        // then
        XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredCalledCount, 1)
        XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredWidth, 300)
        XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredHeight, 165)
        XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredView, view)
        XCTAssertTrue(defaultPopoverPresenterMock.setupPopoverCenteredPopoverVC is EndGamePopoverViewController)
    }
    
    func test_ScoreboardCoordinator_WhenShowEndGamePopoverCalledDispatchQueueNil_ShouldNotPresentViewController() {
        // given
        let (sut, viewController) = getSutAndViewControllerOnTopOfNavigationController()
        
        sut.dispatchQueue = nil
        
        // when
        sut.showEndGamePopover(withGame: GameMock(), andDelegate: EndGamePopoverDelegateMock())
        
        // then
        XCTAssertEqual(viewController.presentCalledCount, 0)
    }
    
    func test_ScoreboardCoordinator_WhenShowEndGamePopoverCalled_ShouldCallDispatchQueueWithDelaySentFromFunctionCallAndPresentViewController() {
        // given
        let (sut, viewController) = getSutAndViewControllerOnTopOfNavigationController()
        
        let dispatchQueueMock = DispatchQueueMainMock()
        sut.dispatchQueue = dispatchQueueMock
        let delay = CGFloat.random(in: 1...10)
        
        // when
        sut.showEndGamePopover(withGame: GameMock(), andDelegate: EndGamePopoverDelegateMock(), delay: delay)
        
        // then
        XCTAssertEqual(dispatchQueueMock.asyncAfterDelay, delay)
        XCTAssertEqual(dispatchQueueMock.asyncAfterCalledCount, 1)
        XCTAssertEqual(viewController.presentCalledCount, 1)
    }
    
    
    // MARK: - ShowKeepPlayingPopover
    
    func test_ScoreCoordinator_WhenShowKeepPlayingPopoverCalled_ShouldSetKeepPlayingPopoverGameAndDelegate() {
        // given
        let (sut, viewController) = getSutAndViewControllerOnTopOfNavigationController()
        
        let delegate = KeepPlayingPopoverDelegateMock()
        let game = GameMock()
        sut.dispatchQueue = DispatchQueueMainMock()
        
        // when
        sut.showKeepPlayingPopover(withGame: game, andDelegate: delegate)
        
        // then
        let keepPlayingPopoverVC = viewController.presentViewController as? KeepPlayingPopoverViewController
        XCTAssertTrue(keepPlayingPopoverVC?.game?.isEqualTo(game: game) ?? false)
        XCTAssertTrue(keepPlayingPopoverVC?.delegate as? KeepPlayingPopoverDelegateMock === delegate)
    }
    
    func test_ScoreCoordinator_WhenShowKeepPlayingPopoverCalled_ShouldCallDefaultPopoverPresenterSetupPopoverCenteredWithCorrectArguments() {
        // given
        let (sut, viewController) = getSutAndViewControllerOnTopOfNavigationController()
        
        let view = UIView()
        viewController.view = view
        
        let defaultPopoverPresenterMock = DefaultPopoverPresenterMock()
        sut.defaultPopoverPresenter = defaultPopoverPresenterMock
        
        // when
        sut.showKeepPlayingPopover(withGame: GameMock(), andDelegate: KeepPlayingPopoverDelegateMock())
        
        // then
        XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredCalledCount, 1)
        XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredWidth, 300)
        XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredHeight, 217)
        XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredView, view)
        XCTAssertTrue(defaultPopoverPresenterMock.setupPopoverCenteredPopoverVC is KeepPlayingPopoverViewController)
    }
    
    func test_ScoreboardCoordinator_WhenShowKeepPlayingPopoverCalledDispatchQueueNil_ShouldNotPresentViewController() {
        // given
        let (sut, viewController) = getSutAndViewControllerOnTopOfNavigationController()
        
        sut.dispatchQueue = nil
        
        // when
        sut.showKeepPlayingPopover(withGame: GameMock(), andDelegate: KeepPlayingPopoverDelegateMock())
        
        // then
        XCTAssertEqual(viewController.presentCalledCount, 0)
    }
    
    func test_ScoreboardCoordinator_WhenShowKeepPlayingPopoverCalled_ShouldCallDispatchQueueWithDelaySentFromFunctionCallAndPresentViewController() {
        // given
        let (sut, viewController) = getSutAndViewControllerOnTopOfNavigationController()
        
        let dispatchQueueMock = DispatchQueueMainMock()
        sut.dispatchQueue = dispatchQueueMock
        let delay = CGFloat.random(in: 1...10)
        
        // when
        sut.showKeepPlayingPopover(withGame: GameMock(), andDelegate: KeepPlayingPopoverDelegateMock(), delay: delay)
        
        // then
        XCTAssertEqual(dispatchQueueMock.asyncAfterDelay, delay)
        XCTAssertEqual(dispatchQueueMock.asyncAfterCalledCount, 1)
        XCTAssertEqual(viewController.presentCalledCount, 1)
    }
    
    
    // MARK: - ShowEndGameScreen
    
    func test_ScoreboardCoordinator_WhenShowEndGameScreenCalledDispatchQueueNil_ShouldNotCallGameTabCoordinatorShowEndGameScreen() {
        // given
        let (sut, _) = getSutAndViewControllerOnTopOfNavigationController()
        
        let coordinator = GameTabCoordinatorMock()
        sut.coordinator = coordinator
        sut.dispatchQueue = nil
        
        // when
        sut.showEndGameScreen(withGame: GameMock())
        
        // then
        XCTAssertEqual(coordinator.showEndGameScreenCalledCount, 0)
    }
    
    func test_ScoreboardCoordinator_WhenShowEndGameScreenCalled_ShouldCallDispatchQueueWithDelayAndGameTabCoordinatorShowEndGameScreen() {
        // given
        let (sut, _) = getSutAndViewControllerOnTopOfNavigationController()
        
        let coordinator = GameTabCoordinatorMock()
        sut.coordinator = coordinator
        
        let dispatchQueue = DispatchQueueMainMock()
        sut.dispatchQueue = dispatchQueue
        
        let game = GameMock()
        let delay = CGFloat.random(in: 1...10)
        
        // when
        sut.showEndGameScreen(withGame: game, delay: delay)
        
        // then
        XCTAssertEqual(coordinator.showEndGameScreenCalledCount, 1)
        XCTAssertTrue(coordinator.showEndGameScreenGame?.isEqualTo(game: game) ?? false)
        XCTAssertEqual(dispatchQueue.asyncAfterDelay, delay)
    }
    
    
    // MARK: - DeleteGame
    
    func test_ScoreboardCoordinator_WhenDeleteGameCalled_ShouldCallGameTabCoordinatorDeleteGame() {
        // given
        let sut = ScoreboardCoordinator(navigationController: RootNavigationController())
        
        let gameTabCoordinator = GameTabCoordinatorMock()
        sut.coordinator = gameTabCoordinator
        
        // when
        sut.deleteGame()
        
        // then
        XCTAssertEqual(gameTabCoordinator.deleteGameCalledCount, 1)
    }
}
