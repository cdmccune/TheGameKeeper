//
//  ScoreboardCoordinator.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/21/24.
//

import Foundation
import UIKit

class ScoreboardCoordinator: Coordinator {
    
    // MARK: - Init
    
    init(navigationController: RootNavigationController, parentCoordinator: GameTabCoordinator? = nil) {
        self.navigationController = navigationController
        self.coordinator = parentCoordinator
    }
    
    // MARK: - Properties
    
    weak var coordinator: GameTabCoordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: RootNavigationController
    var game: GameProtocol?
    
    lazy var endRoundPopoverHeightHelper: EndRoundPopoverHeightHelperProtocol = EndRoundPopoverHeightHelper(playerViewHeight: 45, playerSeperatorHeight: 3)
    lazy var defaultPopoverPresenter: DefaultPopoverPresenterProtocol = DefaultPopoverPresenter()
    lazy var dispatchQueue: DispatchQueueProtocol? = DispatchQueue.main
    
    // MARK: - Functions
    
    func start() {
        guard let game else { return }
        
        let scoreboardVC = ScoreboardViewController.instantiate()
        let viewModel = ScoreboardViewModel(game: game)
        viewModel.coordinator = self
        scoreboardVC.viewModel = viewModel
        
        navigationController.viewControllers = [scoreboardVC]
    }
    
    func showGameHistory(withGame game: GameProtocol, andDelegate delegate: GameHistoryViewControllerDelegate) {
        
        let gameHistoryVC = GameHistoryViewController.instantiate()
        let viewModel = GameHistoryViewModel(game: game)
        gameHistoryVC.viewModel = viewModel
        gameHistoryVC.delegate = delegate
        
        navigationController.pushViewController(gameHistoryVC, animated: true)
    }
    
    func showSettings(withGame game: GameProtocol, andDelegate delegate: GameSettingsDelegate) {
        let gameSettingsVC = GameSettingsViewController.instantiate()
        let viewModel = GameSettingsViewModel(game: game, delegate: delegate)
        gameSettingsVC.viewModel = viewModel
        
        navigationController.pushViewController(gameSettingsVC, animated: true)
    }
    
    func showEndRoundPopover(withGame game: GameProtocol, andDelegate delegate: EndRoundPopoverDelegateProtocol) {
        guard let viewController = navigationController.topViewController else { return }
        let endRoundPopoverVC = EndRoundPopoverViewController.instantiate()
        
        var scoreChangeSettingsArray = [ScoreChangeSettings]()
        for player in game.players {
            scoreChangeSettingsArray.append(ScoreChangeSettings(player: player))
        }
        let endRoundSettings = EndRoundSettings(scoreChangeSettingsArray: scoreChangeSettingsArray, roundNumber: game.currentRound)
        
        endRoundPopoverVC.endRound = endRoundSettings
        endRoundPopoverVC.delegate = delegate
        
        endRoundPopoverVC.playerViewHeight = endRoundPopoverHeightHelper.playerViewHeight
        endRoundPopoverVC.playerSeparatorHeight = endRoundPopoverHeightHelper.playerSeperatorHeight
        let height = endRoundPopoverHeightHelper.getPopoverHeightFor(playerCount: game.players.count, andSafeAreaHeight: viewController.view.safeAreaFrame.height)
        
        defaultPopoverPresenter.setupPopoverCentered(onView: viewController.view, withPopover: endRoundPopoverVC, withWidth: 300, andHeight: height, tapToExit: true)
        
        viewController.present(endRoundPopoverVC, animated: true)
    }
    
    func showEditPlayerPopover(withPlayer player: PlayerProtocol, andDelegate delegate: EditPlayerPopoverDelegateProtocol) {
        guard let viewController = navigationController.topViewController else { return }
        let editPlayerPopoverVC = EditPlayerPopoverViewController.instantiate()
        
        editPlayerPopoverVC.player = player
        editPlayerPopoverVC.delegate = delegate
        
        defaultPopoverPresenter.setupPopoverCentered(onView: viewController.view, withPopover: editPlayerPopoverVC, withWidth: 300, andHeight: 100, tapToExit: true)
        
        viewController.present(editPlayerPopoverVC, animated: true)
    }
    
    func showEditPlayerScorePopover(withScoreChange scoreChange: ScoreChangeSettings, andDelegate delegate: ScoreboardPlayerEditScorePopoverDelegate) {
        guard let viewController = navigationController.topViewController else { return }
        let editPlayerScorePopoverVC = ScoreboardPlayerEditScorePopoverViewController.instantiate()
        
        editPlayerScorePopoverVC.scoreChangeSettings = scoreChange
        editPlayerScorePopoverVC.delegate = delegate
        
        defaultPopoverPresenter.setupPopoverCentered(onView: viewController.view, withPopover: editPlayerScorePopoverVC, withWidth: 300, andHeight: 200, tapToExit: true)
        
        viewController.present(editPlayerScorePopoverVC, animated: true)
    }
    
    func showEndGamePopover(withGame game: GameProtocol, andDelegate delegate: EndGamePopoverDelegate, delay: CGFloat = 0) {
        guard let viewController = navigationController.topViewController else { return }
        let endGamePopoverVC = EndGamePopoverViewController.instantiate()
        
        endGamePopoverVC.game = game
        endGamePopoverVC.delegate = delegate
        
        defaultPopoverPresenter.setupPopoverCentered(onView: viewController.view, withPopover: endGamePopoverVC, withWidth: 300, andHeight: 165, tapToExit: !game.isEndOfGame())
        
        dispatchQueue?.asyncAfterWrapper(delay: delay, work: {
            viewController.present(endGamePopoverVC, animated: true)
        })
    }
    
    func showKeepPlayingPopover(withGame game: GameProtocol, andDelegate delegate: KeepPlayingPopoverDelegate, delay: CGFloat = 0) {
        guard let viewController = navigationController.topViewController else { return }
        let keepPlayingPopoverVC = KeepPlayingPopoverViewController.instantiate()
        
        keepPlayingPopoverVC.game = game
        keepPlayingPopoverVC.delegate = delegate
        
        defaultPopoverPresenter.setupPopoverCentered(onView: viewController.view, withPopover: keepPlayingPopoverVC, withWidth: 300, andHeight: 217, tapToExit: false)
        
        dispatchQueue?.asyncAfterWrapper(delay: delay, work: {
            viewController.present(keepPlayingPopoverVC, animated: true)
        })
    }
    
    func showEndGameScreen(withGame game: GameProtocol, delay: CGFloat = 0) {
        dispatchQueue?.asyncAfterWrapper(delay: delay, work: {
            self.coordinator?.showEndGameScreen(forGame: game)
        })
    }
    
    
}
