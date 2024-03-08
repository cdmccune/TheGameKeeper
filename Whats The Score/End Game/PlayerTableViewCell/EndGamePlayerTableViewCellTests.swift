//
//  EndGamePlayerTableViewCellTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 3/8/24.
//

import XCTest
@testable import Whats_The_Score

final class EndGamePlayerTableViewCellTests: XCTestCase {

    // MARK: - Setup
    
    var tableViewCell: EndGamePlayerTableViewCell?
    
    override func setUp() {
        let nibs = Bundle.main.loadNibNamed("EndGamePlayerTableViewCell", owner: nil)
        tableViewCell = nibs?.first(where: { $0 is EndGamePlayerTableViewCell}) as? EndGamePlayerTableViewCell
    }
    
    override func tearDown() {
        tableViewCell = nil
    }
    
    
    // MARK: - Initialization
    
    func test_EndGamePlayerTableViewCell_WhenLoadedFromNib_ShouldHaveNonNilOutlets() {
        // given
        // when
        let sut = tableViewCell!
        
        // then
        XCTAssertNotNil(sut.playerNameLabel)
        XCTAssertNotNil(sut.playerScoreLabel)
    }

    
    // MARK: - SetupNoLosingPlayers
    
    func test_EndGamePlayerTableViewCell_WhenSetupNoLosingPlayersCalled_ShouldSetPlayerNameTextToThereAreNoLosersAndScoreBlank() {
        // given
        let sut = tableViewCell!
        
        // when
        sut.setupNoLosingPlayers()
        
        // then
        XCTAssertEqual(sut.playerNameLabel.text, "There are no losers!")
        XCTAssertEqual(sut.playerScoreLabel.text, "")
    }
    
    
    // MARK: - SetupErrorCell
    
    func test_EndGamePlayerTableViewCell_WhenSetupNoLosingPlayersCalled_ShouldSetPlayerNameTextToThereWasAnErrorandScoreTripleQuestionMarks() {
        // given
        let sut = tableViewCell!
        
        // when
        sut.setupErrorCell()
        
        // then
        XCTAssertEqual(sut.playerNameLabel.text, "There has been an error")
        XCTAssertEqual(sut.playerScoreLabel.text, "???")
    }
    
    
    // MARK: - SetupViewFor
    
    func test_EndGamePlayerTableViewCell_WhenSetupViewForCalled_ShouldSetPlayerNameTextPlayerNamendScoreToScore() {
        // given
        let sut = tableViewCell!
        let playerName = UUID().uuidString
        let playerScore = Int.random(in: 1...10000)
        let player = Player(name: playerName, position: 0, score: playerScore)
        
        // when
        sut.setupViewFor(player)
        
        // then
        XCTAssertEqual(sut.playerNameLabel.text, playerName)
        XCTAssertEqual(sut.playerScoreLabel.text, String(playerScore))
    }
}
