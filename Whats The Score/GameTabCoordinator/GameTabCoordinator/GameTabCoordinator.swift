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
        GameSetupCoordinator(navigationController: navigationController)
    ]
    var navigationController: RootNavigationController
    
    
    func start() {
        childCoordinators.first { $0 is GameSetupCoordinator }?.start()
    }
}
