//
//  ScoreChangeProtocol.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/8/24.
//

import Foundation

protocol ScoreChangeProtocol {
    var endRound: EndRound? { get set }
    var game: Game? { get set }
    var player: PlayerProtocol { get }
    var scoreChange: Int { get set }
    var position: Int { get set }
    var id: UUID { get set }
}
