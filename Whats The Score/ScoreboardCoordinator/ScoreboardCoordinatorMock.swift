//
//  ScoreboardCoordinatorMock.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 3/21/24.
//

import Foundation
@testable import Whats_The_Score

class ScoreboardCoordinatorMock: ScoreboardCoordinator {
    
    var startCalledCount = 0
    override func start() {
        startCalledCount += 1
    }
}
