//
//  MyGamesViewModel.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/11/24.
//

import Foundation

protocol MyGamesViewModelProtocol {
    var coordinator: HomeTabCoordinator? { get set }
    var games: [GameProtocol] { get set }
    var activeGames: [GameProtocol] { get }
    var pausedGames: [GameProtocol] { get}
    var completedGames: [GameProtocol] { get}
    
    func didSelectRowAt(_ indexPath: IndexPath)
}

class MyGamesViewModel: MyGamesViewModelProtocol {
    weak var coordinator: HomeTabCoordinator?
    
    var games: [GameProtocol] = []
    var activeGames: [GameProtocol] {
        games.filter { $0.gameStatus == .active }.sorted { $0.lastModified > $1.lastModified }
    }
    var pausedGames: [GameProtocol] { 
        games.filter { $0.gameStatus == .paused }.sorted { $0.lastModified > $1.lastModified }
    }
    var completedGames: [GameProtocol] {
        games.filter { $0.gameStatus == .completed }.sorted { $0.lastModified > $1.lastModified }
    }
    
    func didSelectRowAt(_ indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            coordinator?.playActiveGame()
        case 1:
            guard pausedGames.indices.contains(indexPath.row) else { return }
            coordinator?.reopenPausedGame(pausedGames[indexPath.row])
        case 2:
            guard completedGames.indices.contains(indexPath.row) else { return }
            coordinator?.showGameReportFor(game: completedGames[indexPath.row])
        default:
            fatalError("Invalid Section")
        }
    }
}
