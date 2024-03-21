//
//  GameSetupCoordinator.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/20/24.
//

import Foundation

class GameSetupCoordinator: Coordinator {
    
    init(navigationController: RootNavigationController) {
        self.navigationController = navigationController
    }
    
    var childCoordinators: [Coordinator] = []
    var navigationController: RootNavigationController
    
    func start() {
        let gameTypeSelectionVC = GameTypeSelectionViewController.instantiate()
        gameTypeSelectionVC.coordinator = self
        navigationController.viewControllers = [gameTypeSelectionVC]
    }
    
    func gameTypeSelected(_ gameType: GameType) {
        switch gameType {
        case .basic:
            let playerSetupVC = PlayerSetupViewController.instantiate()
            navigationController.pushViewController(playerSetupVC, animated: true)
            
        case .round:
            let gameEndTypeSelectionVC = GameEndTypeSelectionViewController.instantiate()
            gameEndTypeSelectionVC.coordinator = self
            navigationController.pushViewController(gameEndTypeSelectionVC, animated: true)
        }
    }
    
    func gameEndTypeSelected(_ gameEndType: GameEndType) {
        switch gameEndType {
        case .none:
            let playerSetupVC = PlayerSetupViewController.instantiate()
            navigationController.pushViewController(playerSetupVC, animated: true)
        case .round:
            let gameEndQuantityVC = GameEndQuantitySelectionViewController.instantiate()
            gameEndQuantityVC.coordinator = self
            navigationController.pushViewController(gameEndQuantityVC, animated: true)
        case .score:
            let gameEndQuantityVC = GameEndQuantitySelectionViewController.instantiate()
            gameEndQuantityVC.coordinator = self
            navigationController.pushViewController(gameEndQuantityVC, animated: true)
        }
    }
    
    func gameEndQuantitySelected(_ gameEndQuantity: Int) {
        let playerSetupVC = PlayerSetupViewController.instantiate()
        navigationController.pushViewController(playerSetupVC, animated: true)
    }
 }
