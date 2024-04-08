//
//  GameTabCoordinator.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/20/24.
//

import Foundation

class GameTabCoordinator: Coordinator {
    
    required init(navigationController: RootNavigationController, coreDataStore: CoreDataStoreProtocol  = CoreDataStore(.inMemory)) {
        self.coreDataStore = coreDataStore
        self.navigationController = navigationController
    }
    
    lazy var childCoordinators: [Coordinator] = [
        GameSetupCoordinator(navigationController: navigationController, parentCoordinator: self),
        ScoreboardCoordinator(navigationController: navigationController, parentCoordinator: self)
    ]
    
    var coreDataStore: CoreDataStoreProtocol
    var navigationController: RootNavigationController
    lazy var coreDataHelper: GameTabCoreDataHelperProtocol = GameTabCoreDataHelper(coreDataStore: coreDataStore)
    
    
    func start() {
        childCoordinators.first { $0 is GameSetupCoordinator }?.start()
    }
    
    func startQuickGame() {
        let game = coreDataHelper.startQuickGame()
        startScoreboard(with: game)
    }
    
    func gameSetupComplete(withGameType gameType: GameType, gameEndType: GameEndType, gameEndQuantity: Int, andPlayers players: [PlayerSettings]) {
        
        let scoreboardCoordinator = childCoordinators.first { $0 is ScoreboardCoordinator } as? ScoreboardCoordinator
        
        let game = coreDataHelper.initializeGame(with: gameType, gameEndType, gameEndQuantity: gameEndQuantity, players)
        
        startScoreboard(with: game)
    }
    
    func startScoreboard(with game: GameProtocol) {
        let scoreboardCoordinator = childCoordinators.first { $0 is ScoreboardCoordinator } as? ScoreboardCoordinator
        
        scoreboardCoordinator?.game = game
        scoreboardCoordinator?.start()
        
    }
    
    func showEndGameScreen(forGame game: GameProtocol) {
        let endGameVC = EndGameViewController.instantiate()
        
        endGameVC.viewModel = EndGameViewModel(game: game)
        endGameVC.coordinator = self
        
        navigationController.viewControllers = [endGameVC]
    }
    
    func goToScoreboard(forGame game: GameProtocol) {
        let scoreboardCoordinator = childCoordinators.first { $0 is ScoreboardCoordinator } as? ScoreboardCoordinator
        
        scoreboardCoordinator?.game = game
        scoreboardCoordinator?.start()
    }
    
}
