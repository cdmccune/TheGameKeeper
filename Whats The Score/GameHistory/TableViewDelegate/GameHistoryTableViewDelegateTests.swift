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
        let gameSegments = Array(repeating: GameHistorySegment.scoreChange(ScoreChange.getBlankScoreChange(), PlayerMock()), count: gameSegmentCount)
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
        sut.viewModel.game.historySegments = [GameHistorySegment.scoreChange(ScoreChange.getBlankScoreChange(), PlayerMock())]
        
        // when
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        
        // then
        XCTAssertTrue(cell is GameHistoryScoreChangeTableViewCell)
    }
    
    func test_GameHistoryTableViewDelegate_WhenCellForRowAtCalledIndexIsScoreChange_ShouldCallSetupPropertiesForWithCorrectScoreChangeAndIsInRoundEndFalseAndPlayer() {
        // given
        let (sut, tableView) = getSutAndTableView()
        let player = Player.getBasicPlayer()
        let scoreChange = ScoreChange(player: player, scoreChange: 0)
        sut.viewModel.game.historySegments = [GameHistorySegment.scoreChange(scoreChange, player)]
        
        // when
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? GameHistoryScoreChangeTableViewCellMock
        
        // then
        XCTAssertEqual(cell?.setupPropertiesForCalledCount, 1)
        XCTAssertEqual(cell?.setupPropertiesForScoreChange?.playerID, player.id)
        XCTAssertEqual(cell?.setupPropertiesForPlayer?.id, player.id)
        XCTAssertFalse(cell?.setupPropertiesForIsInRoundEndBool ?? true)
    }
    
    func test_GameHistoryTableViewDelegate_WhenCellForRowAtCalledIndexIsEndRound_ShouldReturnEndRoundCell() {
        // given
        let (sut, tableView) = getSutAndTableView()
        let endRound = EndRound(roundNumber: 0, scoreChangeArray: [])
        let endRoundSegment = GameHistorySegment.endRound(endRound, [PlayerMock()])
        sut.viewModel.game.historySegments = [endRoundSegment]
        
        // when
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        
        // then
        XCTAssertTrue(cell is GameHistoryEndRoundTableViewCell)
    }
    
    func test_GameHistoryTableViewDelegate_WhenCellForRowAtCalledIndexIsEndRound_ShouldCallSetupCellForWithCorrectScoreChangesAndRoundNumberAndPlayers() {
        // given
        let (sut, tableView) = getSutAndTableView()
        let player = Player.getBasicPlayer()
        let scoreChanges = [ScoreChange(player: player, scoreChange: 0)]
        let roundNumber = Int.random(in: 1...10)
        let endRound = EndRound(roundNumber: roundNumber, scoreChangeArray: scoreChanges)
        sut.viewModel.game.historySegments = [GameHistorySegment.endRound(endRound, [player])]
        
        // when
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? GameHistoryEndRoundTableViewCellMock
        
        // then
        XCTAssertEqual(cell?.setupCellForCalledCount, 1)
        XCTAssertEqual(cell?.setupCellForRound, roundNumber)
        XCTAssertEqual(cell?.setupCellForScoreChanges?.first?.playerID, player.id)
        XCTAssertEqual(cell?.setupCellForPlayers?.first?.id, player.id)
    }
    
    
    // MARK: - HeightForRowAt
    
    func test_GameHistoryTableViewDelegate_WhenHeightForRowAtCalledIndexIsScoreChange_ShouldReturn44() {
        // given
        let (sut, tableView) = getSutAndTableView()
        sut.viewModel.game.historySegments = [GameHistorySegment.scoreChange(ScoreChange.getBlankScoreChange(), PlayerMock())]
        
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
        let endRound = EndRound(roundNumber: 0, scoreChangeArray: scoreChanges)
        sut.viewModel.game.historySegments = [GameHistorySegment.endRound(endRound, [])]
        
        
        // when
        let height = sut.tableView(tableView, heightForRowAt: IndexPath(row: 0, section: 0))
        
        // then
        let expectedHeight = CGFloat(44 + (44*scoreChangeCount) - (scoreChangeCount > 0 ? 1 : 0))
        XCTAssertEqual(height, expectedHeight)
    }
    
    
    // MARK: - DidSelect
    
    func test_GameHistoryTableViewDelegate_WhenDidSelectRowAt_ShouldCallViewModelDidSelectRow() {
        // given
        let (sut, tableView) = getSutAndTableView()
        let rowIndex = Int.random(in: 1...1000)
        
        // when
        sut.tableView(tableView, didSelectRowAt: IndexPath(row: rowIndex, section: 0))
        
        // then
        let viewModel = sut.viewModel as? GameHistoryViewModelMock
        XCTAssertEqual(viewModel?.didSelectRowCalledCount, 1)
        XCTAssertEqual(viewModel?.didSelectRowRow, rowIndex)
    }

}
