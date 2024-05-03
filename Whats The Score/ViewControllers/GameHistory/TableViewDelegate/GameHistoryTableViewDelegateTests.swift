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
        tableViewMock?.register(GameHistoryTableViewHeaderViewMock.self, forHeaderFooterViewReuseIdentifier: "GameHistoryTableViewHeaderView")
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
    
    func getGameWithType(_ gameType: GameType, andNumberOfObjects count: Int) -> GameMock {
        let game = GameMock()
        game.gameType = gameType
        switch gameType {
        case .basic:
            game.scoreChanges = Array(repeating: ScoreChangeMock(player: PlayerMock()), count: count)
        case .round:
            game.endRounds = Array(repeating: EndRoundMock(), count: count)
        }
        return game
    }
    
    
    // MARK: - NumberOfRowsInSection
    
    func test_GameHistoryTableViewDelegate_WhenNumberRowsInSectionCalledGameTypeRound_ShouldReturnViewModelGameEndRoundCount() {
        // given
        let (sut, tableView) = getSutAndTableView()
        let endRoundCount = Int.random(in: 2...10)
        sut.viewModel.game = getGameWithType(.round, andNumberOfObjects: endRoundCount)
        
        // when
        let count = sut.tableView(tableView, numberOfRowsInSection: 0)
        
        // then
        XCTAssertEqual(count, endRoundCount)
    }
    
    func test_GameHistoryTableViewDelegate_WhenNumberRowsInSectionCalledGameTypeBasic_ShouldReturnViewModelGameScoreChangesCount() {
        // given
        let (sut, tableView) = getSutAndTableView()
        let scoreChangesCount = Int.random(in: 2...10)
        sut.viewModel.game = getGameWithType(.basic, andNumberOfObjects: scoreChangesCount)
        
        // when
        let count = sut.tableView(tableView, numberOfRowsInSection: 0)
        
        // then
        XCTAssertEqual(count, scoreChangesCount)
    }
    
    
    // MARK: - CellForRowAt
    
    func test_GameHistoryTableViewDelegate_WhenCellForRowAtCalledOutOfIndexGameBasic_ShouldReturnErroCell() {
        // given
        let (sut, tableView) = getSutAndTableView()
        sut.viewModel.game = getGameWithType(.basic, andNumberOfObjects: 0)
        
        // when
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        
        // then
        XCTAssertTrue(cell is GameHistoryErrorTableViewCell)
    }
    
    func test_GameHistoryTableViewDelegate_WhenCellForRowAtCalledOutOfIndexGameRound_ShouldReturnErroCell() {
        // given
        let (sut, tableView) = getSutAndTableView()
        sut.viewModel.game = getGameWithType(.round, andNumberOfObjects: 0)
        
        // when
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        
        // then
        XCTAssertTrue(cell is GameHistoryErrorTableViewCell)
    }
    
    func test_GameHistoryTableViewDelegate_WhenCellForRowAtCalledGameTypeBasic_ShouldReturnScoreChangeCell() {
        // given
        let (sut, tableView) = getSutAndTableView()
        sut.viewModel.game = getGameWithType(.basic, andNumberOfObjects: 1)
        
        // when
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        
        // then
        XCTAssertTrue(cell is GameHistoryScoreChangeTableViewCell)
    }
    
    func test_GameHistoryTableViewDelegate_WhenCellForRowAtCalledIndexIsScoreChange_ShouldCallSetupPropertiesForWithCorrectScoreChangeAndPlayer() {
        // given
        let (sut, tableView) = getSutAndTableView()
        sut.viewModel.game = getGameWithType(.basic, andNumberOfObjects: 1)
        let player = sut.viewModel.game.scoreChanges.first!.player
        
        // when
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? GameHistoryScoreChangeTableViewCellMock
        
        // then
        XCTAssertEqual(cell?.setupPropertiesForCalledCount, 1)
        XCTAssertEqual(cell?.setupPropertiesForScoreChange?.player.id, player.id)
    }
    
    func test_GameHistoryTableViewDelegate_WhenCellForRowAtCalledIndexIsEndRound_ShouldReturnEndRoundCell() {
        // given
        let (sut, tableView) = getSutAndTableView()
        sut.viewModel.game = getGameWithType(.round, andNumberOfObjects: 1)
        
        // when
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        
        // then
        XCTAssertTrue(cell is GameHistoryEndRoundTableViewCell)
    }
    
    func test_GameHistoryTableViewDelegate_WhenCellForRowAtCalledIndexIsEndRound_ShouldCallSetupCellForWithCorrectScoreChangesAndRoundNumber() {
        // given
        let (sut, tableView) = getSutAndTableView()
        
        let scoreChange = ScoreChangeMock(player: PlayerMock())
        let roundNumber = Int.random(in: 1...10)
        let endRound = EndRoundMock(roundNumber: roundNumber, scoreChangeArray: [scoreChange])
        let game = GameMock()
        game.gameType = .round
        game.endRounds = [endRound]
        sut.viewModel.game = game
        
        // when
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? GameHistoryEndRoundTableViewCellMock
        
        // then
        XCTAssertEqual(cell?.setupCellForCalledCount, 1)
        XCTAssertEqual(cell?.setupCellForRound, roundNumber)
        XCTAssertEqual(cell?.setupCellForScoreChanges?.first?.id, scoreChange.id)
    }
    
    
    // MARK: - HeightForRowAt
    
    func test_GameHistoryTableViewDelegate_WhenHeightForRowAtCalledGameTypeBasic_ShouldReturn44() {
        // given
        let (sut, tableView) = getSutAndTableView()
        sut.viewModel.game = getGameWithType(.basic, andNumberOfObjects: 0)
        
        // when
        let height = sut.tableView(tableView, heightForRowAt: IndexPath(row: 0, section: 0))
        
        // then
        XCTAssertEqual(height, 44)
    }
    
    func test_GameHistoryTableViewDelegate_WhenHeightForRowAtCalledGameTypeRound_ShouldReturnNumberCalculatedCorrectly() {
        // given
        let (sut, tableView) = getSutAndTableView()
        let scoreChangeCount = Int.random(in: 0...10)
        let scoreChanges = Array(repeating: ScoreChangeMock(), count: scoreChangeCount)
        let endRound = EndRoundMock(scoreChangeArray: scoreChanges)
        sut.viewModel.game = GameMock(gameType: .round, endRounds: [endRound])
        
        // when
        let height = sut.tableView(tableView, heightForRowAt: IndexPath(row: 0, section: 0))
        
        // then
        let expectedHeight = CGFloat((44*scoreChangeCount) - (scoreChangeCount > 0 ? 1 : 0))
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
    
    
    // MARK: - TrailingSwipeActions
    
    func test_GameHistoryTableViewDelegate_WhenTrailingSwipeActionsConfigurationForRowAtCalled_ShouldReturnOneActionWithDeleteTitle() {
        // given
        let (sut, tableView) = getSutAndTableView()
        
        // when
        let swipeActionsConfig = sut.tableView(tableView, trailingSwipeActionsConfigurationForRowAt: IndexPath(row: 0, section: 0))
        
        // then
        XCTAssertNotNil(swipeActionsConfig?.actions.first)
        XCTAssertEqual(swipeActionsConfig?.actions.first?.title, "Delete")
        XCTAssertEqual(swipeActionsConfig?.actions.first?.style, .destructive)
    }
    
    func test_GameHistoryTableViewDelegate_WhenDeleteSwipeActionCalled_ShouldCallViewModelDeleteHistorySegmentAt() {
        // given
        let (sut, tableView) = getSutAndTableView()
        let viewModelMock = GameHistoryViewModelMock()
        sut.viewModel = viewModelMock
        let index = Int.random(in: 0...10)
        
        // when
        let swipeActionsConfig = sut.tableView(tableView, trailingSwipeActionsConfigurationForRowAt: IndexPath(row: index, section: 0))
        guard let action = swipeActionsConfig?.actions.first else {
            XCTFail("This should have a delete action")
            return
        }
        
        action.handler(action, UIView(), {_ in})
        
        // then
        XCTAssertEqual(viewModelMock.startDeletingRowAtCalledCount, 1)
        XCTAssertEqual(viewModelMock.startDeletingRowAtIndex, index)
    }
    
    
    // MARK: - ViewForHeaderInSection
    
    func test_GameHistoryTableViewDelegate_WhenViewForHeaderInSectionCalled_ShouldReturnGameHistoryTableViewHeaderView() {
        // given
        let (sut, tableView) = getSutAndTableView()
        
        // when
        let header = sut.tableView(tableView, viewForHeaderInSection: 0)
        
        // then
        XCTAssertTrue(header is GameHistoryTableViewHeaderView)
    }
    
    func test_GameHistoryTableViewDelegate_WhenViewForHeaderInSectionCalledGameTypeBasic_ShouldCallSetupViewIsRoundBasedGameFalse() {
        // given
        let (sut, tableView) = getSutAndTableView()
        
        sut.viewModel.game.gameType = .basic
        
        // when
        let header = sut.tableView(tableView, viewForHeaderInSection: 0) as? GameHistoryTableViewHeaderViewMock
        
        // then
        
        XCTAssertFalse(header?.isRoundBasedGame ?? true)
    }
    
    func test_GameHistoryTableViewDelegate_WhenViewForHeaderInSectionCalledGameTypeRound_ShouldCallSetupViewIsRoundBasedGameTrue() {
        // given
        let (sut, tableView) = getSutAndTableView()
        
        sut.viewModel.game.gameType = .round
        
        // when
        let header = sut.tableView(tableView, viewForHeaderInSection: 0) as? GameHistoryTableViewHeaderViewMock
        
        // then
        
        XCTAssertTrue(header?.isRoundBasedGame ?? false)
    }
    

    // MARK: - HeightForHeaderInSection
    
    func test_GameHistoryTableViewDelegate_WhenHeightForHeaderInSectionCalled_ShouldReturn44() {
        // given
        let (sut, tableView) = getSutAndTableView()
        
        // when
        let height = sut.tableView(tableView, heightForHeaderInSection: 0)
        
        // then
        XCTAssertEqual(height, 44)
    }
}
