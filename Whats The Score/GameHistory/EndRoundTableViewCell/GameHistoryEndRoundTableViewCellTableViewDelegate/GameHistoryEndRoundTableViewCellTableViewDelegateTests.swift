//
//  GameHistoryEndRoundTableViewCellTableViewDelegateTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 3/12/24.
//

import XCTest
@testable import Whats_The_Score

final class GameHistoryEndRoundTableViewCellTableViewDelegateTests: XCTestCase {

    // MARK: - Setup Functions

    var tableViewMock: UITableView?
    
    override func setUp() {
        tableViewMock = UITableView()
        tableViewMock?.register(GameHistoryScoreChangeTableViewCellMock.self, forCellReuseIdentifier: "GameHistoryScoreChangeTableViewCell")
        tableViewMock?.register(GameHistoryErrorTableViewCell.self, forCellReuseIdentifier: "GameHistoryErrorTableViewCell")
    }
    
    override func tearDown() {
        tableViewMock = nil
    }
    
    func getSutAndTableView() -> (GameHistoryEndRoundTableViewCellTableViewDelegate, UITableView) {
        let viewModelMock = GameHistoryEndRoundTableViewCellViewModelMock()
        
        let sut = GameHistoryEndRoundTableViewCellTableViewDelegate(viewModel: viewModelMock)
        let tableView = tableViewMock!
        tableView.delegate = sut
        tableView.dataSource = sut
        
        return (sut, tableView)
    }
    
    
    // MARK: - NumberOfRowsInSection

    func test_GameHistoryEndRoundTableViewCellTableViewDelegate_WhenNumberOfRowsInSectionCalled_ShouldReturnViewModelsScoreChangesCount() {
        // given
        let (sut, tableView) = getSutAndTableView()
        
        let scoreChangesCount = Int.random(in: 1...10)
        let scoreChanges = Array(repeating: ScoreChange.getBlankScoreChange(), count: scoreChangesCount)
        sut.viewModel.scoreChanges = scoreChanges
        
        // when
        let count = sut.tableView(tableView, numberOfRowsInSection: 0)
        
        // then
        XCTAssertEqual(scoreChangesCount, count)
    }
    
    // MARK: - CellForRowAt
    
    func test_GameHistoryEndRoundTableViewCellTableViewDelegate_WhenCellForRowAtOutOfIndex_ShouldReturnErrorCell() {
        // given
        let (sut, tableView) = getSutAndTableView()
        
        // when
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 1, section: 0))
        
        // then
        XCTAssertTrue(cell is GameHistoryErrorTableViewCell)
    }
    
    func test_GameHistoryEndRoundTableViewCellTableViewDelegate_WhenCellForRowAtInIndex_ShouldReturnScoreChangeCell() {
        // given
        let (sut, tableView) = getSutAndTableView()
        sut.viewModel.scoreChanges = [ScoreChange.getBlankScoreChange()]
        
        
        // when
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        
        // then
        XCTAssertTrue(cell is GameHistoryScoreChangeTableViewCell)
    }
    
    func test_GameHistoryEndRoundTableViewCellTableViewDelegate_WhenCellForRowAtInIndex_ShouldCallSetupPropertiesForOnScoreChangeCell() {
        // given
        let (sut, tableView) = getSutAndTableView()
        let scoreChangeID = UUID()
        let scoreChange = ScoreChange(playerID: scoreChangeID, scoreChange: 0, playerName: "")
        
        sut.viewModel.scoreChanges = [scoreChange]
        
        // when
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? GameHistoryScoreChangeTableViewCellMock
        
        // then
        XCTAssertEqual(cell?.setupPropertiesForCalledCount, 1)
        XCTAssertEqual(cell?.setupPropertiesForScoreChange?.playerID, scoreChangeID)
    }
    
    
    // MARK: - HeightForRowAt
    
    func test_GameHistoryEndRoundTableViewCellTableViewDelegate_WhenHeightForRowAtCallled_Should44() {
        // given
        let (sut, tableView) = getSutAndTableView()
        
        // when
        let height = sut.tableView(tableView, heightForRowAt: IndexPath(row: 0, section: 0))
        
        // then
        XCTAssertEqual(height, 44)
    }
}
