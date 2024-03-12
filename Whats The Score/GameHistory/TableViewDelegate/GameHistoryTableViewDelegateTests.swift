//
//  GameHistoryTableViewDelegateTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 3/11/24.
//

import XCTest
@testable import Whats_The_Score

final class GameHistoryTableViewDelegateTests: XCTestCase {

    // MARK: - Setup Functions

    var tableViewMock: UITableView?
    
    override func setUp() {
        tableViewMock = UITableView()
        tableViewMock?.register(GameHistoryScoreChangeTableViewCellMock.self, forCellReuseIdentifier: "GameHistoryScoreChangeTableViewCell")
        tableViewMock?.register(GameHistoryEndRoundTableViewCellMock.self, forCellReuseIdentifier: "GameHistoryEndRoundTableViewCell")
        tableViewMock?.register(GameHistoryErrorTableViewCell.self, forCellReuseIdentifier: "GameHistoryErrorTableViewCell")
    }
    
    override func tearDown() {
        tableViewMock = nil
    }
    
    func getSutAndTableView() -> (GameHistoryTableViewDelegate, UITableView) {
        let viewModelMock = GameHistoryViewModelMock()
        
        let sut = GameHistoryTableViewDelegate(viewModel: viewModelMock)
        let tableView = tableViewMock!
        tableView.delegate = sut
        tableView.dataSource = sut
        
        return (sut, tableView)
    }
    
    
    // MARK: - NumberOfRowsInSection
    
    func test_GameHistoryTableViewDelegate_WhenNumberRowsInSectionCalled_ShouldReturnViewModelGameHistorySegmentsCount() {
        // given
        let (sut, tableView) = getSutAndTableView()
        let gameSegmentCount = Int.random(in: 2...10)
        let gameSegments = Array(repeating: GameHistorySegment.scoreChange(ScoreChange.getBlankScoreChange()), count: gameSegmentCount)
        sut.viewModel.game.historySegments = gameSegments
        
        // when
        let count = sut.tableView(tableView, numberOfRowsInSection: 0)
        
        // then
        XCTAssertEqual(count, gameSegmentCount)
    }
    
    
    // MARK: - CellForRowAt
    
    func test_GameHistoryTableViewDelegate_WhenCellForRowAtCalledOutOfIndex_ShouldReturnErroCell() {
        // given
        let (sut, tableView) = getSutAndTableView()
        sut.viewModel.game.historySegments = []
        
        // when
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        
        // then
        XCTAssertTrue(cell is GameHistoryErrorTableViewCell)
    }
    
    func test_GameHistoryTableViewDelegate_WhenCellForRowAtCalledIndexIsScoreChange_ShouldReturnScoreChangeCell() {
        // given
        let (sut, tableView) = getSutAndTableView()
        sut.viewModel.game.historySegments = [GameHistorySegment.scoreChange(ScoreChange.getBlankScoreChange())]
        
        // when
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        
        // then
        XCTAssertTrue(cell is GameHistoryScoreChangeTableViewCell)
    }
    
    func test_GameHistoryTableViewDelegate_WhenCellForRowAtCalledIndexIsScoreChange_ShouldCallSetupPropertiesForWithCorrectScoreChange() {
        // given
        let (sut, tableView) = getSutAndTableView()
        let scoreChangeID = UUID()
        let scoreChange = ScoreChange(playerID: scoreChangeID, scoreChange: 0, playerName: "")
        sut.viewModel.game.historySegments = [GameHistorySegment.scoreChange(scoreChange)]
        
        // when
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? GameHistoryScoreChangeTableViewCellMock
        
        // then
        XCTAssertEqual(cell?.setupPropertiesForCalledCount, 1)
        XCTAssertEqual(cell?.setupPropertiesForScoreChange?.playerID, scoreChangeID)
    }
    
    func test_GameHistoryTableViewDelegate_WhenCellForRowAtCalledIndexIsEndRound_ShouldReturnEndRoundCell() {
        // given
        let (sut, tableView) = getSutAndTableView()
        sut.viewModel.game.historySegments = [GameHistorySegment.scoreChange(ScoreChange.getBlankScoreChange())]
        
        // when
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        
        // then
        XCTAssertTrue(cell is GameHistoryScoreChangeTableViewCell)
    }
    
    func test_GameHistoryTableViewDelegate_WhenCellForRowAtCalledIndexIsEndRound_ShouldCallSetupCellForWithCorrectScoreChangesAndRoundNumber() {
        // given
        let (sut, tableView) = getSutAndTableView()
        let scoreChangeID = UUID()
        let scoreChanges = [ScoreChange(playerID: scoreChangeID, scoreChange: 0, playerName: "")]
        let roundNumber = Int.random(in: 1...10)
        sut.viewModel.game.historySegments = [GameHistorySegment.endRound(roundNumber, scoreChanges)]
        
        // when
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? GameHistoryEndRoundTableViewCellMock
        
        // then
        XCTAssertEqual(cell?.setupCellForCalledCount, 1)
        XCTAssertEqual(cell?.setupCellForRound, roundNumber)
        XCTAssertEqual(cell?.setupCellForScoreChanges?.first?.playerID, scoreChangeID)
    }
    
    
    // MARK: - HeightForRowAt
    
    func test_GameHistoryTableViewDelegate_WhenHeightForRowAtCalledIndexIsScoreChange_ShouldReturn44() {
        // given
        let (sut, tableView) = getSutAndTableView()
        sut.viewModel.game.historySegments = [GameHistorySegment.scoreChange(ScoreChange.getBlankScoreChange())]
        
        // when
        let height = sut.tableView(tableView, heightForRowAt: IndexPath(row: 0, section: 0))
        
        // then
        XCTAssertEqual(height, 44)
    }
    
    func test_GameHistoryTableViewDelegate_WhenHeightForRowAtCalledIndexIsEndRound_ShouldReturnNumberCalculatedCorrectly() {
        // given
        let (sut, tableView) = getSutAndTableView()
        let scoreChangeCount = Int.random(in: 0...10)
        let scoreChanges = Array(repeating: ScoreChange.getBlankScoreChange(), count: scoreChangeCount)
        sut.viewModel.game.historySegments = [GameHistorySegment.endRound(0, scoreChanges)]
        
        
        // when
        let height = sut.tableView(tableView, heightForRowAt: IndexPath(row: 0, section: 0))
        
        // then
        let expectedHeight = CGFloat(44 + (44*scoreChangeCount) - (scoreChangeCount > 0 ? 1 : 0))
        XCTAssertEqual(height, expectedHeight)
    }

}
