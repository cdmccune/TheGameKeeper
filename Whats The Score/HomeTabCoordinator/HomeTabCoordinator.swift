//
//  HomeTabCoordinator.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/20/24.
//

import Foundation
import UIKit

class HomeTabCoordinator: Coordinator {
    
    // MARK: - Init
    
    required init(navigationController: RootNavigationController, coreDataStore: CoreDataStoreProtocol = CoreDataStore(.inMemory)) {
        self.navigationController = navigationController
        self.coreDataStore = coreDataStore
    }
    
    
    // MARK: - Properties
    
    var activeGame: GameProtocol?
    var activeGameError: CoreDataStoreError?
    var childCoordinators: [Coordinator] = []
    var navigationController: RootNavigationController
    var coreDataStore: CoreDataStoreProtocol
    
    lazy var coreDataHelper: HomeTabCoordinatorCoreDataHelperProtocol = HomeTabCoordinatorCoreDataHelper(coreDataStore: coreDataStore)
    lazy var dispatchQueue: DispatchQueueProtocol? = DispatchQueue.main
    
    weak var coordinator: MainCoordinator?
    
    
    // MARK: - Functions
    
    func start() {
        let homeVC = HomeViewController.instantiate()
        homeVC.coordinator = self
        homeVC.activeGame = activeGame
        
        if let activeGameError { showError(activeGameError) }
        
        navigationController.viewControllers = [homeVC]
    }
    
    func setupNewGame() {
        pauseCurrentGame()
        coordinator?.setupNewGame()
    }
    
    func setupQuickGame() {
        pauseCurrentGame()
        coordinator?.setupQuickGame()
    }
    
    func playActiveGame() {
        coordinator?.playActiveGame()
    }
    
    func showMyGames() {
        let myGamesVC = MyGamesViewController.instantiate()
        
        let viewModel = MyGamesViewModel()
        
        do {
            let games = try coreDataHelper.getAllGames()
            viewModel.games = games
        } catch let error as CoreDataStoreError {
            showError(error)
        } catch {
            fatalError("Unhandled error \(error.localizedDescription)")
        }
        
        viewModel.coordinator = self
        myGamesVC.viewModel = viewModel
        
        navigationController.pushViewController(myGamesVC, animated: true)
    }
    
    
    func pauseCurrentGame(andOpenGame newGame: GameProtocol? = nil) {
        if let activeGame {
            coreDataHelper.pauseGame(game: activeGame)
        }
        
        if let newGame {
            coreDataHelper.makeGameActive(game: newGame)
        }
        
        self.activeGame = newGame
        start()
    }
    
    func showError(_ error: CoreDataStoreError) {
        dispatchQueue?.asyncAfterWrapper(delay: 0.25, work: {
            let alertController = UIAlertController(title: "Error", message: error.getDescription(), preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(OKAction)
            
            self.navigationController.topViewController?.present(alertController, animated: true)
        })
    }
    
    func reopenPausedGame(_ game: GameProtocol) {
        pauseCurrentGame(andOpenGame: game)
        coordinator?.homeTabGameMadeActive(game)
    }
    
    func showGameReportFor(game: GameProtocol) {
        
    }
}
