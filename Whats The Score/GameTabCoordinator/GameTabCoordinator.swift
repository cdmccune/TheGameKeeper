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
        ScoreboardCoordinator(navigationController: navigationController, parentCoordinator: self, coreDataStore: coreDataStore)
    ]
    
    weak var coordinator: MainCoordinator?
    var activeGame: GameProtocol?
    var coreDataStore: CoreDataStoreProtocol
    var navigationController: RootNavigationController
    lazy var coreDataHelper: GameTabCoreDataHelperProtocol = GameTabCoreDataHelper(coreDataStore: coreDataStore)
    
    
    func start() {
        if let activeGame {
            let scoreboardCoordinator = childCoordinators.first { $0 is ScoreboardCoordinator} as? ScoreboardCoordinator
            scoreboardCoordinator?.game = activeGame
            scoreboardCoordinator?.start()
            
        } else {
            childCoordinators.first { $0 is GameSetupCoordinator }?.start()
        }
        
    }
    
    func startQuickGame() {
        let game = coreDataHelper.startQuickGame()
        coordinator?.gameTabGameMadeActive(game)
        startScoreboard(with: game)
    }
    
    func gameSetupComplete(withGameType gameType: GameType, gameEndType: GameEndType, gameEndQuantity: Int, players: [PlayerSettings], andName name: String) {
        
        _ = childCoordinators.first { $0 is ScoreboardCoordinator } as? ScoreboardCoordinator
        
        let game = coreDataHelper.initializeGame(with: gameType, gameEndType, gameEndQuantity: gameEndQuantity, players, andName: name)
        
        coordinator?.gameTabGameMadeActive(game)
        startScoreboard(with: game)
    }
    
    func startScoreboard(with game: GameProtocol) {
        let scoreboardCoordinator = childCoordinators.first { $0 is ScoreboardCoordinator } as? ScoreboardCoordinator
        
        scoreboardCoordinator?.game = game
        scoreboardCoordinator?.start()
        
    }
    
    func showEndGameScreen(forGame game: GameProtocol) {
        let endGameVC = EndGameViewController.instantiate()
        coreDataHelper.endGame(game)
        coordinator?.gameTabActiveGameCompleted()
        
        endGameVC.viewModel = EndGameViewModel(game: game)
        endGameVC.coordinator = self
        
        navigationController.viewControllers = [endGameVC]
    }
    
    func goToScoreboard(forGame game: GameProtocol) {
        coreDataHelper.makeGameActive(game)
        coordinator?.gameTabGameMadeActive(game)
        
        let scoreboardCoordinator = childCoordinators.first { $0 is ScoreboardCoordinator } as? ScoreboardCoordinator
        
        scoreboardCoordinator?.game = game
        scoreboardCoordinator?.start()
    }
    
}
