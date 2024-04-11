//
//  MyGamesViewModel.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/11/24.
//

import Foundation

protocol MyGamesViewModelProtocol {
    var games: [GameProtocol] { get set }
    var activeGames: [GameProtocol] { get }
    var pausedGames: [GameProtocol] { get}
    var completedGames: [GameProtocol] { get}
}

class MyGamesViewModel: MyGamesViewModelProtocol {
    var games: [GameProtocol] = []
    var activeGames: [GameProtocol] {
        games.filter { $0.gameStatus == .active }
    }
    var pausedGames: [GameProtocol] { 
        games.filter { $0.gameStatus == .paused }
    }
    var completedGames: [GameProtocol] {
        games.filter { $0.gameStatus == .completed }
    }
}
