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
    func initializeGame(with gameType: GameType, _ gameEndType: GameEndType, gameEndQuantity: Int, _ playerSettings: [PlayerSettings]) -> GameProtocol
    func endGame(_ game: GameProtocol)
    func makeGameActive(_ game: GameProtocol)
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
        
        _ = Player(game: game,
                             name: "Player 1",
                             position: 0,
                             context: coreDataStore.persistentContainer.viewContext)
        
        _ = Player(game: game,
                             name: "Player 2",
                             position: 1,
                             context: coreDataStore.persistentContainer.viewContext)
        
        coreDataStore.saveContext()
        
        return game
    }
    
    func initializeGame(with gameType: GameType, _ gameEndType: GameEndType, gameEndQuantity: Int, _ playerSettings: [PlayerSettings]) -> GameProtocol {
        
        let game = Game(gameType: gameType,
                        gameEndType: gameEndType,
                        players: [],
                        context: coreDataStore.persistentContainer.viewContext)
        
        if gameType == .round {
            switch gameEndType {
            case .none:
                break
            case .round:
                game.numberOfRounds = gameEndQuantity
            case .score:
                game.endingScore = gameEndQuantity
            }
        }
        
        for (index, playerSetting) in playerSettings.enumerated() {
            _ = Player(game: game, name: playerSetting.name, position: index - 1, context: coreDataStore.persistentContainer.viewContext)
        }
        
        coreDataStore.saveContext()
        
        return game
    }
    
    func endGame(_ game: GameProtocol) {
        game.gameStatus = .completed
        coreDataStore.saveContext()
    }
    
    func makeGameActive(_ game: GameProtocol) {
        game.gameStatus = .active
        coreDataStore.saveContext()
    }
    
}
