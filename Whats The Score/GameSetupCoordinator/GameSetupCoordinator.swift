//
//  GameSetupCoordinator.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/20/24.
//

import Foundation

class GameSetupCoordinator: Coordinator {
    
    // MARK: - Init
    
    init(navigationController: RootNavigationController, parentCoordinator: GameTabCoordinator? = nil) {
        self.navigationController = navigationController
        self.coordinator = parentCoordinator
    }
    
    
    // MARK: - Properties
    
    weak var coordinator: GameTabCoordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: RootNavigationController
    lazy var defaultPopoverPresenter: DefaultPopoverPresenterProtocol = DefaultPopoverPresenter()
    
    
    var gameType: GameType = .basic
    var gameEndType: GameEndType = .none
    var gameEndQuantity: Int = 0
    var gameName: String = ""
    
    
    // MARK: - Functions
    
    func start() {
        let gameNameVC = GameNameViewController.instantiate()
        gameNameVC.coordinator = self
        navigationController.viewControllers = [gameNameVC]
    }
    
    func gameNameSet(_ name: String) {
        gameName = name
        
        let gameTypeSelectionVC = GameTypeSelectionViewController.instantiate()
        gameTypeSelectionVC.coordinator = self
        navigationController.pushViewController(gameTypeSelectionVC, animated: true)
    }
    
    func gameTypeSelected(_ gameType: GameType) {
        self.gameType = gameType
        switch gameType {
        case .basic:
            let playerSetupVC = PlayerSetupViewController.instantiate()
            let viewModel = PlayerSetupViewModel()
            viewModel.coordinator = self
            playerSetupVC.viewModel = viewModel
            navigationController.pushViewController(playerSetupVC, animated: true)
            
        case .round:
            let gameEndTypeSelectionVC = GameEndTypeSelectionViewController.instantiate()
            gameEndTypeSelectionVC.coordinator = self
            navigationController.pushViewController(gameEndTypeSelectionVC, animated: true)
        }
    }
    
    func gameEndTypeSelected(_ gameEndType: GameEndType) {
        self.gameEndType = gameEndType
        
        guard gameEndType != .none else {
            let playerSetupVC = PlayerSetupViewController.instantiate()
            let viewModel = PlayerSetupViewModel()
            viewModel.coordinator = self
            playerSetupVC.viewModel = viewModel
            navigationController.pushViewController(playerSetupVC, animated: true)
            return
        }
        
        guard let topViewController = navigationController.topViewController else {
            return
        }
        
        let gameEndQuantitySelectionPopoverVC = GameEndQuantitySelectionPopoverViewController.instantiate()
        
        gameEndQuantitySelectionPopoverVC.coordinator = self
        gameEndQuantitySelectionPopoverVC.gameEndType = gameEndType
        
        defaultPopoverPresenter.setupPopoverCentered(onView: topViewController.view, withPopover: gameEndQuantitySelectionPopoverVC, withWidth: 300, andHeight: 151, tapToExit: true)
        
        navigationController.topViewController?.present(gameEndQuantitySelectionPopoverVC, animated: true)
    }
    
    func gameEndQuantitySelected(_ gameEndQuantity: Int) {
        self.gameEndQuantity = gameEndQuantity
        
        let playerSetupVC = PlayerSetupViewController.instantiate()
        let viewModel = PlayerSetupViewModel()
        viewModel.coordinator = self
        playerSetupVC.viewModel = viewModel
        navigationController.pushViewController(playerSetupVC, animated: true)
    }
    
    // MARK: - Player Setup Functions
    
    func playersSetup(_ players: [PlayerSettings]) {
        coordinator?.gameSetupComplete(withGameType: gameType,
                                       gameEndType: gameEndType,
                                       gameEndQuantity: gameEndQuantity,
                                       players: [],
                                       andName: gameName)
    }
    
    func showAddPlayerPopover(withPlayerSettings playerSettings: PlayerSettings, andDelegate delegate: EditPlayerPopoverDelegateProtocol) {
        guard let viewController = navigationController.topViewController else { return }
        let editPlayerPopoverViewController = EditPlayerPopoverViewController.instantiate()
        
        editPlayerPopoverViewController.delegate = delegate
        editPlayerPopoverViewController.player = playerSettings
        
        defaultPopoverPresenter.setupPopoverCentered(onView: viewController.view, withPopover: editPlayerPopoverViewController, withWidth: 300, andHeight: 165, tapToExit: true)
        
        viewController.present(editPlayerPopoverViewController, animated: true)
    }
}
