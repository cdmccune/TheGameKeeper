//
//  GameHistoryEndRoundTableViewCellViewModelTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 3/12/24.
//

import XCTest
@testable import Whats_The_Score

final class GameHistoryEndRoundTableViewCellViewModelTests: XCTestCase {



}

class GameHistoryEndRoundTableViewCellViewModelMock: GameHistoryEndRoundTableViewCellViewModelProtocol {
    var scoreChanges: [Whats_The_Score.ScoreChange] = []
}
