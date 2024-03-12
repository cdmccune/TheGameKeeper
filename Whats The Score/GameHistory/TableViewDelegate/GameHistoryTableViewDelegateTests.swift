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
        tableViewMock?.register(GameHistoryScoreChangeTableViewCell.self, forCellReuseIdentifier: "GameHistoryScoreChangeTableViewCell")
        tableViewMock?.register(GameHistoryEndRoundTableViewCell.self, forCellReuseIdentifier: "GameHistoryEndRoundTableViewCell")
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
    
    func test_GameHistoryTableViewDelegate_WhenCellForRowAtCalledIndexIsEndRound_ShouldReturnEndRoundCell() {
        // given
        let (sut, tableView) = getSutAndTableView()
        sut.viewModel.game.historySegments = [GameHistorySegment.scoreChange(ScoreChange.getBlankScoreChange())]
        
        // when
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        
        // then
        XCTAssertTrue(cell is GameHistoryScoreChangeTableViewCell)
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

}
