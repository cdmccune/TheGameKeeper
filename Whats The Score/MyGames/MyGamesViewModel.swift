//
//  MyGamesViewModel.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/11/24.
//

import Foundation

protocol MyGamesViewModelProtocol {
    var games: [GameProtocol] { get set }
}

class MyGamesViewModel: MyGamesViewModelProtocol {
    var games: [GameProtocol] = []
}
