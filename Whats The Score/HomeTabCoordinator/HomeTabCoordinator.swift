//
//  HomeTabCoordinator.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/20/24.
//

import Foundation

class HomeTabCoordinator: Coordinator {
    
    required init(navigationController: RootNavigationController) {
        self.navigationController = navigationController
    }
    
    var childCoordinators: [Coordinator] = []
    var navigationController: RootNavigationController
    weak var coordinator: MainCoordinator?
    
    
    func start() {
        let homeVC = HomeViewController.instantiate()
        homeVC.coordinator = self
        
        navigationController.viewControllers = [homeVC]
    }
    
    func setupNewGame() {
        coordinator?.setupNewGame()
    }
}
