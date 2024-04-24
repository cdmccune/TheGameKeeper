//
//  HomeTabCoordinatorCoreDataHelper.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/11/24.
//

import Foundation

protocol HomeTabCoordinatorCoreDataHelperProtocol {
    var coreDataStore: CoreDataStoreProtocol { get set }
    
    func getAllGames() throws -> [GameProtocol]
    func pauseGame(game: GameProtocol)
    func makeGameActive(game: GameProtocol)
}

class HomeTabCoordinatorCoreDataHelper: HomeTabCoordinatorCoreDataHelperProtocol {
    init(coreDataStore: CoreDataStoreProtocol) {
        self.coreDataStore = coreDataStore
    }
    
    var coreDataStore: CoreDataStoreProtocol
    
    
    func getAllGames() throws -> [GameProtocol] {
        
        let games = try coreDataStore.makeFetchRequest(with: Game.fetchRequest()) as? [Game]
        
        return games ?? []
    }
    
    func pauseGame(game: GameProtocol) {
        game.gameStatus = .paused
        coreDataStore.saveContext()
    }
    
    func makeGameActive(game: GameProtocol) {
        game.gameStatus = .active
        coreDataStore.saveContext()
    }
}
