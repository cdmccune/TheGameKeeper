//
//  GameHistorySegment.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/11/24.
//

import Foundation

enum GameHistorySegment {
    case scoreChange((UUID, Int))
    case endRound(Int, [(UUID, Int)])
}
