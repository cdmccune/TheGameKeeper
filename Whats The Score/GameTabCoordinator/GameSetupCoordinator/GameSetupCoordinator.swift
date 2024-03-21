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
        
    }
}
