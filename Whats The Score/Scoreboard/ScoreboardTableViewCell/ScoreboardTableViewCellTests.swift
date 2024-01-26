//
//  ScoreboardTableViewCellTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 1/24/24.
//

import XCTest
@testable import Whats_The_Score

final class ScoreboardTableViewCellTests: XCTestCase {
    
    // MARK: - Setup
    
    var tableViewCell: ScoreboardTableViewCell?
    
    override func setUp() {
        let nibs = Bundle.main.loadNibNamed("ScoreboardTableViewCell", owner: nil)
        tableViewCell = nibs?.first(where: { $0 is ScoreboardTableViewCell}) as? ScoreboardTableViewCell
    }
    
    override func tearDown() {
        tableViewCell = nil
    }
    
    // MARK: - LoadedFromNib

    func test_ScoreboardTableViewCell_WhenLoadedFromNibCalled_ShouldHaveNonNilOutlets() {
        // given
        // when
        let sut = tableViewCell!
        
        // then
        XCTAssertNotNil(sut.playerNameLabel)
        XCTAssertNotNil(sut.playerScoreLabel)
    }
    
    
    // MARK: - SetupCellWith
    
    func test_ScoreboardTableViewCell_WhenSetupCellWithCalled_ShouldSetPlayerNameToPlayerNameLabel() {
        // given
        let sut = tableViewCell!
        let playerName = UUID().uuidString
        let player = Player(name: playerName, position: 0)
        
        // when
        sut.setupCellWith(player)
        
        // then
        XCTAssertEqual(sut.playerNameLabel.text, playerName)
    }
    
    func test_ScoreboardTableViewCell_WhenSetupCellWithCalled_ShouldSetPlayerScoreLabelTextToScore() {
        // given
        let sut = tableViewCell!
        let playerScore = Int.random(in: 0...1000)
        let player = Player(name: "", position: 0, score: playerScore)
        
        // when
        sut.setupCellWith(player)
        
        // then
        XCTAssertEqual(sut.playerScoreLabel.text, String(playerScore))
    }
    
    
    // MARK: - SetupCellForError
    
    func test_ScoreboardTableViewCell_WhenSetupCellForErrorCalled_ShouldSetPlayerNameLabelToErrorAndPlayerScoreToTripleZeros() {
        // given
        let sut = tableViewCell!
        
        // when
        sut.setupCellForError()
        
        // then
        XCTAssertEqual(sut.playerNameLabel.text, "Error")
        XCTAssertEqual(sut.playerScoreLabel.text, "000")
    }

}
