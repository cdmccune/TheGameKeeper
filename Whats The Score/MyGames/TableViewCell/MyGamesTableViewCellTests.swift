//
//  MyGamesTableViewCellTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 4/24/24.
//

import XCTest
@testable import Whats_The_Score

final class MyGamesTableViewCellTests: XCTestCase {

    // MARK: - Setup
    
    var tableViewCell: MyGamesTableViewCell?
    
    override func setUp() {
        let nibs = Bundle.main.loadNibNamed("MyGamesTableViewCell", owner: nil)
        tableViewCell = nibs?.first(where: { $0 is MyGamesTableViewCell}) as? MyGamesTableViewCell
    }
    
    override func tearDown() {
        tableViewCell = nil
    }
    
    // MARK: - Outlets

    func test_MyGamesTableViewCell_WhenAwakeFromNibCalled_ShouldHaveNonNilOutlets() {
        // given
        // when
        let sut = tableViewCell!
        
        // then
        XCTAssertNotNil(sut.titleLabel)
        XCTAssertNotNil(sut.dateLabel)
        XCTAssertNotNil(sut.winnerNameLabel)
    }
    
    
    // MARK: - SetupCellFor
    
    func test_MyGamesTableViewCell_WhenSetupCellForCalled_ShouldSetTitleLabelTextToGameTitle() {
        // given
        let sut = tableViewCell!
        
        let gameName = UUID().uuidString
        let game = GameMock(name: gameName)
        
        // when
        sut.setupCellFor(game)
        
        // then
        XCTAssertEqual(sut.titleLabel.text, gameName)
    }
    
    func test_MyGamesTableViewCell_WhenSetupCellForCalled_ShouldSetDateLabelTextToFormatted() {
        // given
        let sut = tableViewCell!
        
        let date = Date(timeIntervalSince1970: 0)
        let game = GameMock(lastModified: date)
        
        // when
        sut.setupCellFor(game)
        
        // then
        XCTAssertEqual(sut.dateLabel.text, "Dec 31, 1969")
    }
    
    func test_MyGamesTableViewCell_WhenSetupCellForCalledGameNotCompleted_ShouldSetWinningLabelTextToWinning() {
        // given
        let sut = tableViewCell!
        
        let game = GameMock(gameStatus: .active)

        
        // when
        sut.setupCellFor(game)
        
        // then
        XCTAssertEqual(sut.winnerLabel.text, "Winning")
    }
    
    func test_MyGamesTableViewCell_WhenSetupCellForCalledGameCompleted_ShouldSetWinningLabelTextToWinning() {
        // given
        let sut = tableViewCell!
        
        let game = GameMock(gameStatus: .completed)

        
        // when
        sut.setupCellFor(game)
        
        // then
        XCTAssertEqual(sut.winnerLabel.text, "Winner")
    }
    
    func test_MyGamesTableViewCell_WhenSetupCellForCalledZeroWinners_ShouldSetNoWinnersWinnerNameLabelText() {
        // given
        let sut = tableViewCell!
        
        let game = GameMock()
        game.winningPlayers = []
        
        // when
        sut.setupCellFor(game)
        
        // then
        XCTAssertEqual(sut.winnerNameLabel.text, "No winners")
    }
    
    func test_MyGamesTableViewCell_WhenSetupCellForCalledOneWinner_ShouldPlayerNameAsWinnerNameLabelText() {
        // given
        let sut = tableViewCell!
        
        let playerName = UUID().uuidString
        let game = GameMock()
        game.winningPlayers = [PlayerMock(name: playerName)]
        
        // when
        sut.setupCellFor(game)
        
        // then
        XCTAssertEqual(sut.winnerNameLabel.text, playerName)
    }
    
    func test_MyGamesTableViewCell_WhenSetupCellForCalledMultipleWinners_ShouldSetMultipleAsWinnerNameLabelText() {
        // given
        let sut = tableViewCell!
        
        let game = GameMock()
        game.winningPlayers = [PlayerMock(), PlayerMock()]
        
        // when
        sut.setupCellFor(game)
        
        // then
        XCTAssertEqual(sut.winnerNameLabel.text, "Multiple")
    }
}
