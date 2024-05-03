//
//  MainCoordinatorCoreDataHelper.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/10/24.
//

import Foundation

protocol MainCoordinatorCoreDataHelperProtocol {
    var coreDataStore: CoreDataStoreProtocol { get set }
    
    func getActiveGame() throws -> GameProtocol?
}

class MainCoordinatorCoreDataHelper: MainCoordinatorCoreDataHelperProtocol {
    init(coreDataStore: CoreDataStoreProtocol) {
        self.coreDataStore = coreDataStore
    }
    
    var coreDataStore: CoreDataStoreProtocol
    
    func getActiveGame() throws -> GameProtocol? {
        let request = Game.fetchRequest()
        let activeStatusString = "active"
        request.predicate = NSPredicate(format: "gameStatus_ == %@", activeStatusString)
        
        let games = try coreDataStore.makeFetchRequest(with: request) as? [Game]
        
        if (games?.count ?? 0) > 1 {
            throw CoreDataStoreError.dataError(description: "Error - there are multiple active games")
        }
        
        return games?.first
    }
}
