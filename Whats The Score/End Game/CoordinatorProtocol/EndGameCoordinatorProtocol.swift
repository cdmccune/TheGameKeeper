//
//  EndGameCoordinatorProtocol.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/24/24.
//

import Foundation

protocol EndGameCoordinatorProtocol: AnyObject {
    func reopenNonActiveGame(_ game: GameProtocol)
}
