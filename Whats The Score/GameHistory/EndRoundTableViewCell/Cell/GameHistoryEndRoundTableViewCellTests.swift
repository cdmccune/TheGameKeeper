//
//  GameHistoryEndRoundTableViewCellTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 3/11/24.
//

import XCTest
@testable import Whats_The_Score

final class GameHistoryEndRoundTableViewCellTests: XCTestCase {

    // MARK: - Setup
    
    var tableViewCell: GameHistoryEndRoundTableViewCell?
    
    override func setUp() {
        let nibs = Bundle.main.loadNibNamed("GameHistoryEndRoundTableViewCell", owner: nil)
        tableViewCell = nibs?.first(where: { $0 is GameHistoryEndRoundTableViewCell}) as? GameHistoryEndRoundTableViewCell
    }
    
    override func tearDown() {
        tableViewCell = nil
    }
    
    
    // MARK: - LoadedFromNib

    func test_GameHistoryEndRoundTableViewCell_WhenLoadedFromNib_ShouldHaveNonNilOutlets() {
        // given
        // when
        let sut = tableViewCell!
        
        // then
        XCTAssertNotNil(sut.roundNumberLabel)
        XCTAssertNotNil(sut.tableView)
    }
    
    
    // MARK: - SetupCellFor
    
    func test_GameHistoryEndRoundTableViewCell_WhenSetupCellForCalled_ShouldSetViewModelWithScoreChangeObject() {
        // given
        let sut = tableViewCell!
        var scoreChangeObject = ScoreChange.getBlankScoreChange()
        let id = UUID()
        scoreChangeObject.playerID = id
        
        // when
        sut.setupCellFor(round: 0, and: [scoreChangeObject])
        
        // then
        XCTAssertNotNil(sut.viewModel)
        XCTAssertEqual(sut.viewModel?.scoreChanges.first?.playerID, id)
    }
    
}
