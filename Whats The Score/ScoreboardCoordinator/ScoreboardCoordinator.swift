//
//  ScoreboardCoordinator.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/21/24.
//

import Foundation

class ScoreboardCoordinator: Coordinator {
    
    // MARK: - Init
    
    init(navigationController: RootNavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Properties
    
    var childCoordinators: [Coordinator] = []
    var navigationController: RootNavigationController
    var game: GameProtocol?
    
    
    // MARK: - Start
    
    func start() {
        guard let game else { return }
        
        let scoreboardVC = ScoreboardViewController.instantiate()
        let viewModel = ScoreboardViewModel(game: game)
        scoreboardVC.viewModel = viewModel
        
        navigationController.viewControllers = [scoreboardVC]
    }
}
