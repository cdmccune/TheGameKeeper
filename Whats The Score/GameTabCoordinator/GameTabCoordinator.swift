//
//  GameTabCoordinator.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/20/24.
//

import Foundation

class GameTabCoordinator: Coordinator {
    
    required init(navigationController: RootNavigationController) {
        self.navigationController = navigationController
    }
    
    lazy var childCoordinators: [Coordinator] = [
        GameSetupCoordinator(navigationController: navigationController, parentCoordinator: self),
        ScoreboardCoordinator(navigationController: navigationController, parentCoordinator: self)
    ]
    var navigationController: RootNavigationController
    
    
    func start() {
        childCoordinators.first { $0 is GameSetupCoordinator }?.start()
    }
    
    func startQuickGame() {
//        let player1 = Player(name: "Player 1", position: 0)
//        let player2 = Player(name: "Player 2", position: 0)
//        var players: [PlayerProtocol] = [player1, player2]
//        players.setPositions()
        
        gameSetupComplete(withGameType: .basic, gameEndType: .none, gameEndQuantity: 0, andPlayers: [])
    }
    
    func gameSetupComplete(withGameType gameType: GameType, gameEndType: GameEndType, gameEndQuantity: Int, andPlayers players: [PlayerProtocol]) {
        
        let scoreboardCoordinator = childCoordinators.first { $0 is ScoreboardCoordinator } as? ScoreboardCoordinator
        
//        var game = Game(gameType: gameType, gameEndType: gameEndType, players: players)
        
//        if gameEndType == .round {
//            game.numberOfRounds = gameEndQuantity
//        } else if gameEndType == .score {
//            game.endingScore = gameEndQuantity
//        }
        
//        scoreboardCoordinator?.game = game
        
        scoreboardCoordinator?.start()
    }
    
    func showEndGameScreen(forGame game: Game) {
        let endGameVC = EndGameViewController.instantiate()
        
        endGameVC.viewModel = EndGameViewModel(game: game)
        endGameVC.coordinator = self
        
        navigationController.viewControllers = [endGameVC]
    }
    
    func goToScoreboard(forGame game: Game) {
        let scoreboardCoordinator = childCoordinators.first { $0 is ScoreboardCoordinator } as? ScoreboardCoordinator
        
        scoreboardCoordinator?.game = game
        scoreboardCoordinator?.start()
    }
    
}
