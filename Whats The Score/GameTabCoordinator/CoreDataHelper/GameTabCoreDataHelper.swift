//
//  GameTabCoreDataHelper.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/5/24.
//

import Foundation

protocol GameTabCoreDataHelperProtocol {
    var coreDataStore: CoreDataStoreProtocol { get set }
    
    func startQuickGame() -> GameProtocol
}

class GameTabCoreDataHelper: GameTabCoreDataHelperProtocol {
    init(coreDataStore: CoreDataStoreProtocol) {
        self.coreDataStore = coreDataStore
    }
    
    var coreDataStore: CoreDataStoreProtocol
    
    func startQuickGame() -> GameProtocol {
        let game = Game(gameType: .basic,
                        gameEndType: .none,
                        players: [],
                        context: coreDataStore.persistentContainer.viewContext)
        
        let player1 = Player(game: game,
                             name: "Player1",
                             position: 1,
                             context: coreDataStore.persistentContainer.viewContext)
        
        let player2 = Player(game: game,
                             name: "Player2",
                             position: 1,
                             context: coreDataStore.persistentContainer.viewContext)
        
        return game
    }
}
