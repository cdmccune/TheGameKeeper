//
//  GameSetupCoordinator.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/20/24.
//

import Foundation

class GameSetupCoordinator: Coordinator {
    
    // MARK: - Init
    
    init(navigationController: RootNavigationController, parentCoordinator: GameTabCoordinator? = nil) {
        self.navigationController = navigationController
        self.coordinator = parentCoordinator
    }
    
    
    // MARK: - Properties
    
    weak var coordinator: GameTabCoordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: RootNavigationController
    
    
    var gameType: GameType = .basic
    var gameEndType: GameEndType = .none
    var gameEndQuantity: Int = 0
    
    
    // MARK: - Functions
    
    func start() {
        let gameTypeSelectionVC = GameTypeSelectionViewController.instantiate()
        gameTypeSelectionVC.coordinator = self
        navigationController.viewControllers = [gameTypeSelectionVC]
    }
    
    func gameTypeSelected(_ gameType: GameType) {
        self.gameType = gameType
        switch gameType {
        case .basic:
            let playerSetupVC = PlayerSetupViewController.instantiate()
            let viewModel = PlayerSetupViewModel()
            viewModel.coordinator = self
            playerSetupVC.viewModel = viewModel
            navigationController.pushViewController(playerSetupVC, animated: true)
            
        case .round:
            let gameEndTypeSelectionVC = GameEndTypeSelectionViewController.instantiate()
            gameEndTypeSelectionVC.coordinator = self
            navigationController.pushViewController(gameEndTypeSelectionVC, animated: true)
        }
    }
    
    func gameEndTypeSelected(_ gameEndType: GameEndType) {
        self.gameEndType = gameEndType
        switch gameEndType {
        case .none:
            let playerSetupVC = PlayerSetupViewController.instantiate()
            let viewModel = PlayerSetupViewModel()
            viewModel.coordinator = self
            playerSetupVC.viewModel = viewModel
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
        self.gameEndQuantity = gameEndQuantity
        
        let playerSetupVC = PlayerSetupViewController.instantiate()
        let viewModel = PlayerSetupViewModel()
        viewModel.coordinator = self
        playerSetupVC.viewModel = viewModel
        navigationController.pushViewController(playerSetupVC, animated: true)
    }
    
    func playersSetup(_ players: [PlayerProtocol]) {
        coordinator?.gameSetupComplete(withGameType: gameType,
                                       gameEndType: gameEndType,
                                       gameEndQuantity: gameEndQuantity,
                                       andPlayers: [])
//                                       andPlayers: players)
    }
 }
