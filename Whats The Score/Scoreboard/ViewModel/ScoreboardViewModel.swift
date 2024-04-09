//
//  ScoreboardViewModel.swift
//  Whats The Score
//
//  Created by Curt McCune on 1/19/24.
//

import Foundation

class ScoreboardViewModel: NSObject, ScoreboardViewModelProtocol {
    
    // MARK: - Init
    
    init(game: GameProtocol, coreDataStore: CoreDataStoreProtocol = CoreDataStore(.inMemory)) {
        self.game = game
        self.coreDataStore = coreDataStore
    }
    
    
    // MARK: - Properties
    
    var coreDataStore: CoreDataStoreProtocol
    
    var game: GameProtocol
    weak var coordinator: ScoreboardCoordinator?
    weak var delegate: ScoreboardViewModelViewProtocol? {
        didSet {
            delegate?.bindViewToViewModel(dispatchQueue: DispatchQueue.main)
        }
    }
    
    var sortedPlayers: [PlayerProtocol] {
        return game.players.sorted {player1, player2 in
            switch sortPreference.value ?? .score {
            case .score:
                return player1.score > player2.score
            case .position:
                return player1.position < player2.position
            }
        }
    }
    
    var dispatchQueue: DispatchQueueProtocol = DispatchQueue.main
    
    
    // MARK: - Observables

    var sortPreference: Observable<ScoreboardSortPreference> = Observable(.score)
    var playerToDelete: Observable<PlayerProtocol> = Observable(nil)
    
}
