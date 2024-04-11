//
//  MainCoordinator.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/20/24.
//

import Foundation
import UIKit

class MainCoordinator {
    
    init(coreDataStore: CoreDataStoreProtocol = CoreDataStore(.inMemory)) {
        self.coreDataStore = coreDataStore
    }
    
    var tabbarController = UITabBarController()
    var childCoordinators = [Coordinator]()
    var coreDataStore: CoreDataStoreProtocol
    
    lazy var coreDataHelper: MainCoordinatorCoreDataHelperProtocol = MainCoordinatorCoreDataHelper(coreDataStore: coreDataStore)
    
    var homeTabbarCoordinatorType: HomeTabCoordinator.Type = HomeTabCoordinator.self
    var gameTabbarCoordinatorType: GameTabCoordinator.Type = GameTabCoordinator.self
    
    func start() {
        
        let homeTabbarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        let homeNavigationController = RootNavigationController()
        homeNavigationController.tabBarItem = homeTabbarItem
        let homeTabCoordinator = homeTabbarCoordinatorType.init(navigationController: homeNavigationController)
        homeTabCoordinator.coordinator = self
        
        let gameTabbarItem = UITabBarItem(title: "Game", image: UIImage(systemName: "dice"), tag: 0)
        let gameNavigationController = RootNavigationController()
        gameNavigationController.tabBarItem = gameTabbarItem
        let gameTabCoordinator = gameTabbarCoordinatorType.init(navigationController: gameNavigationController, coreDataStore: coreDataStore)
        
        childCoordinators = [homeTabCoordinator, gameTabCoordinator]
        
        tabbarController.viewControllers = [homeNavigationController, gameNavigationController]
        
        do {
            let activeGame = try coreDataHelper.getActiveGame()
            homeTabCoordinator.activeGame = activeGame
            gameTabCoordinator.activeGame = activeGame
    
        } catch let error as CoreDataStoreError {
            homeTabCoordinator.activeGameError = error
        } catch let error {
            fatalError("unhandled error \(error.localizedDescription)")
        }
        
        homeTabCoordinator.start()
        gameTabCoordinator.start()
    }
    
    func setupNewGame() {
        tabbarController.selectedIndex = 1
    }
    
    func setupQuickGame() {
        let gameTabCoordinator = childCoordinators.first { $0 is GameTabCoordinator } as? GameTabCoordinator
        gameTabCoordinator?.startQuickGame()
        tabbarController.selectedIndex = 1
    }
}
