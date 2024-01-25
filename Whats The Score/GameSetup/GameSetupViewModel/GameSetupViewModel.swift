//
//
//  GameSetupViewModel.swift
//  What's The Score
//
//  Created by Curt McCune on 12/30/23.
//

import Foundation

class GameSetupViewModel {
    
    var gameType: Observable<GameType> = Observable(.basic)
    var gameEndType: Observable<GameEndType> = Observable(.none)
    var numberOfRounds: Observable<Int> = Observable(1)
    var endingScore: Observable<Int> = Observable(0)
    var numberOfPlayers: Observable<Int> = Observable(2)
    
    
    func setInitialValues() {
        gameType.value = .basic
        gameEndType.value = GameEndType.none
        numberOfRounds.value = nil
        endingScore.value = nil
        numberOfPlayers.value = 2
    }
}
