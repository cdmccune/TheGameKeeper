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
    
    
    // MARK: - AwakeFromNib
    
    func test_GameHistoryEndRoundTableViewCell_WhenAwakeFromNibCalled_ShouldRegisterScoreChangeAndErrorCellsOnTableview() {
        // given
        let sut = tableViewCell!
        let tableViewMock = UITableViewRegisterMock()
        sut.tableView = tableViewMock
        
        let errorIdentifierNibName = "GameHistoryErrorTableViewCell"
        let scoreChangeIdentifierNibName = "GameHistoryScoreChangeTableViewCell"
        
        // when
        sut.awakeFromNib()
        
        // then
        XCTAssertTrue(tableViewMock.registerCellReuseIdentifiers.contains(scoreChangeIdentifierNibName))
        XCTAssertTrue(tableViewMock.registerCellReuseIdentifiers.contains(errorIdentifierNibName))
    }
    
    
    // MARK: - SetupCellFor
    
    func test_GameHistoryEndRoundTableViewCell_WhenSetupCellForCalled_ShouldSetRoundNumberLabelTextToRoundAndCorrectNumber() {
        // given
        let sut = tableViewCell!
        let roundNumber = Int.random(in: 1...10000)
        
        // when
        sut.setupCellFor(round: roundNumber, and: [], andTotalScores: [])
        
        // then
        XCTAssertEqual(sut.roundNumberLabel.text, "Round \(roundNumber)")
    }
    
    func test_GameHistoryEndRoundTableViewCell_WhenSetupCellForCalled_ShouldSetViewModelWithScoreChangesAndTotalScores() {
        // given
        let sut = tableViewCell!
        let player = Player.getBasicPlayer()
        let scoreChangeObject = ScoreChange(player: player, scoreChange: 0)
        let totalScores = [Int.random(in: 1...1000)]
        
        
        // when
        sut.setupCellFor(round: 0, and: [scoreChangeObject], andTotalScores: totalScores)
        
        // then
        XCTAssertNotNil(sut.viewModel)
        XCTAssertEqual(sut.viewModel?.scoreChanges.first?.playerID, player.id)
        XCTAssertEqual(sut.viewModel?.totalScores, totalScores)
    }
    
    func test_GameHistoryEndRoundTableViewCell_WhenSetupCellForCalled_ShouldSetTableViewDelegateDatasourceAsGameHistoryEndRoundTableViewCellTableViewDelegate() {
        // given
        let sut = tableViewCell!
        
        // when
        sut.setupCellFor(round: 0, and: [], andTotalScores: [])
        
        // then
        XCTAssertTrue(sut.tableView.delegate is GameHistoryEndRoundTableViewCellTableViewDelegate)
    }
    
    func test_GameHistoryEndRoundTableViewCell_WhenSetupCellForCalled_ShouldSetTableViewDelegatesViewModelToCellsViewModel() {
        // given
        let sut = tableViewCell!
        
        // when
        sut.setupCellFor(round: 0, and: [], andTotalScores: [])
        
        // then
        let tableViewDelegate = sut.tableView.delegate as? GameHistoryEndRoundTableViewCellTableViewDelegate
        XCTAssertTrue(tableViewDelegate?.viewModel as? GameHistoryEndRoundTableViewCellViewModel === sut.viewModel)
    }
    
    func test_GameHistoryEndRoundTableViewCell_WhenSetupCellForCalled_ShouldCallTableViewReloadData() {
        // given
        let sut = tableViewCell!
        
        let tableView = UITableViewReloadDataMock()
        sut.tableView = tableView
        
        // when
        sut.setupCellFor(round: 0, and: [], andTotalScores: [])
        
        // then
        XCTAssertEqual(tableView.reloadDataCalledCount, 1)
    }
}

class GameHistoryEndRoundTableViewCellMock: GameHistoryEndRoundTableViewCell {
    var setupCellForCalledCount = 0
    var setupCellForRound: Int?
    var setupCellForScoreChanges: [ScoreChange]?
    var setupCellForTotalScores: [Int]?
    
    override func setupCellFor(round: Int, and scoreChanges: [ScoreChange], andTotalScores totalScores: [Int]) {
        self.setupCellForCalledCount += 1
        self.setupCellForRound = round
        self.setupCellForScoreChanges = scoreChanges
        self.setupCellForTotalScores = totalScores
    }
}
