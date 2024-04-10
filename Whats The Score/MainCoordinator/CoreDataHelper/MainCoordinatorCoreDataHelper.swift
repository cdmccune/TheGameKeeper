//
//  MainCoordinatorCoreDataHelper.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/10/24.
//

import Foundation

protocol MainCoordinatorCoreDataHelperProtocol {
    var coreDataStore: CoreDataStoreProtocol { get set }
    
    func getActiveGame() -> Game?
}

class MainCoordinatorCoreDataHelper: MainCoordinatorCoreDataHelperProtocol {
    init(coreDataStore: CoreDataStoreProtocol) {
        self.coreDataStore = coreDataStore
    }
    
    var coreDataStore: CoreDataStoreProtocol
    
    func getActiveGame() -> Game? {
        let request = Game.fetchRequest()
        let activeStatusString = "active"
        request.predicate = NSPredicate(format: "gameStatus_ == %@", activeStatusString)
        
        try? coreDataStore.makeFetchRequest(with: request)
        
        
        return nil
    }
}
