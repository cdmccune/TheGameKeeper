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
        let homeTabCoordinator = homeTabbarCoordinatorType.init(navigationController: homeNavigationController, coreDataStore: coreDataStore)
        homeTabCoordinator.coordinator = self
        
        let gameTabbarItem = UITabBarItem(title: "Game", image: UIImage(systemName: "dice"), tag: 0)
        let gameNavigationController = RootNavigationController()
        gameNavigationController.tabBarItem = gameTabbarItem
        let gameTabCoordinator = gameTabbarCoordinatorType.init(navigationController: gameNavigationController, coreDataStore: coreDataStore)
        gameTabCoordinator.coordinator = self
        
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
        let gameTabCoordinator = childCoordinators.first { $0 is GameTabCoordinator } as? GameTabCoordinator
        gameTabCoordinator?.activeGame = nil
        gameTabCoordinator?.start()
        tabbarController.selectedIndex = 1
    }
    
    func setupQuickGame() {
        let gameTabCoordinator = childCoordinators.first { $0 is GameTabCoordinator } as? GameTabCoordinator
        gameTabCoordinator?.startQuickGame()
        tabbarController.selectedIndex = 1
    }
    
    func playActiveGame() {
        tabbarController.selectedIndex = 1
    }
    
    func gameTabGameMadeActive(_ game: GameProtocol) {
        let homeTabCoordinator = childCoordinators.first { $0 is HomeTabCoordinator } as? HomeTabCoordinator
        homeTabCoordinator?.activeGame = game
        homeTabCoordinator?.start()
    }
    
    func gameTabActiveGameCompleted() {
        let homeTabCoordinator = childCoordinators.first { $0 is HomeTabCoordinator } as? HomeTabCoordinator
        homeTabCoordinator?.activeGame = nil
        homeTabCoordinator?.start()
    }
    
    func homeTabGameMadeActive(_ game: GameProtocol) {
        let gameTabCoordinator = childCoordinators.first { $0 is GameTabCoordinator } as? GameTabCoordinator
        gameTabCoordinator?.activeGame = game
        gameTabCoordinator?.start()
        tabbarController.selectedIndex = 1
    }
    
    func homeTabActiveGameDeleted() {
        let gameTabCoordinator = childCoordinators.first { $0 is GameTabCoordinator } as? GameTabCoordinator
        gameTabCoordinator?.activeGame = nil
        gameTabCoordinator?.start()
    }
}
