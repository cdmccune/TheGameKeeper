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
    func initializeGame(with gameType: GameType, _ gameEndType: GameEndType, gameEndQuantity: Int, _ playerSettings: [PlayerSettings], andName name: String) -> GameProtocol
    func endGame(_ game: GameProtocol)
    func makeGameActive(_ game: GameProtocol)
    func deleteGame(_ game: GameProtocol)
}

class GameTabCoreDataHelper: GameTabCoreDataHelperProtocol {
    init(coreDataStore: CoreDataStoreProtocol) {
        self.coreDataStore = coreDataStore
    }
    
    var coreDataStore: CoreDataStoreProtocol
    
    func startQuickGame() -> GameProtocol {
        let game = Game(name: "Quick Game",
                        gameType: .basic,
                        gameEndType: .none,
                        players: [],
                        context: coreDataStore.persistentContainer.viewContext)
        
        _ = Player(game: game,
                   name: "Player 1",
                   position: 0,
                   icon: .alien,
                   context: coreDataStore.persistentContainer.viewContext)
        
        _ = Player(game: game,
                   name: "Player 2",
                   position: 1,
                   icon: .alien,
                   context: coreDataStore.persistentContainer.viewContext)
        
        coreDataStore.saveContext()
        
        return game
    }
    
    func initializeGame(with gameType: GameType, _ gameEndType: GameEndType, gameEndQuantity: Int, _ playerSettings: [PlayerSettings], andName name: String) -> GameProtocol {
        
        let game = Game(name: name,
                        gameType: gameType,
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
            _ = Player(game: game, name: playerSetting.name, position: index - 1, icon: playerSetting.icon, context: coreDataStore.persistentContainer.viewContext)
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
    
    func deleteGame(_ game: GameProtocol) {
        guard let game = game as? Game else { return }
        coreDataStore.deleteObject(game)
        coreDataStore.saveContext()
    }
}
