//
//  HomeTabCoordinator.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/20/24.
//

import Foundation
import UIKit

class HomeTabCoordinator: Coordinator {
    
    required init(navigationController: RootNavigationController) {
        self.navigationController = navigationController
    }
    
    var activeGame: GameProtocol?
    var activeGameError: CoreDataStoreError?
    var childCoordinators: [Coordinator] = []
    var navigationController: RootNavigationController
    weak var coordinator: MainCoordinator?
    
    lazy var dispatchQueue: DispatchQueueProtocol? = DispatchQueue.main
    
    
    func start() {
        let homeVC = HomeViewController.instantiate()
        homeVC.coordinator = self
        homeVC.activeGame = activeGame
        
        if let activeGameError { showActiveGameError(activeGameError) }
        
        navigationController.viewControllers = [homeVC]
    }
    
    func setupNewGame() {
        coordinator?.setupNewGame()
    }
    
    func setupQuickGame() {
        coordinator?.setupQuickGame()
    }
    
    func showActiveGameError(_ error: CoreDataStoreError) {
        dispatchQueue?.asyncAfterWrapper(delay: 0.25, work: {
            let alertController = UIAlertController(title: "Error", message: error.getDescription(), preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(OKAction)
            
            self.navigationController.topViewController?.present(alertController, animated: true)
        })
    }
}
