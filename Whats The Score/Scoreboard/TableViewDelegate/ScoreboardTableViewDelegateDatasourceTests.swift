//
//  ScoreboardTableViewDelegateDatasourceTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 1/24/24.
//

import XCTest
@testable import Whats_The_Score

final class ScoreboardTableViewDelegateDatasourceTests: XCTestCase {
    
    
    // MARK: - Setup Functions

    var tableViewMock: UITableView?
    
    override func setUp() {
        tableViewMock = UITableView()
        tableViewMock?.register(ScoreboardTableViewCellMock.self, forCellReuseIdentifier: "ScoreboardTableViewCell")
    }
    
    override func tearDown() {
        tableViewMock = nil
    }
    
    func getSutAndTableView(withPlayerCount playerCount: Int) -> (ScoreboardTableViewDelegateDatasource, UITableView) {
        let players = Array(repeating: PlayerMock(), count: playerCount)
        let viewModelMock = ScoreboardViewModelMock()
        viewModelMock.sortedPlayers = players
        
        let sut = ScoreboardTableViewDelegateDatasource(viewModel: viewModelMock)
        let tableView = tableViewMock!
        tableView.delegate = sut
        tableView.dataSource = sut
        
        return (sut, tableView)
    }
    
    
    // MARK: - NumberOfRowsInSection
    
    func test_ScoreboardTableViewDelegateDatasource_WhenNumberOfRowsInSectionCalled_ShouldReturnViewModelSortedPlayersCount() {
        // given
        let playerCount = Int.random(in: 1...10)
        let (sut, tableView) = getSutAndTableView(withPlayerCount: playerCount)
        
        // when
        let playerCountSut = sut.tableView(tableView, numberOfRowsInSection: 0)
        
        // then
        XCTAssertEqual(playerCount, playerCountSut)
    }
    
    
    // MARK: - CellForRowAt
    
    func test_ScoreboardTableViewDelegateDatasource_WhenCellForRowAtCalled_ShouldReturnScoreboardTableViewCell() {
        // given
        let (sut, tableView) = getSutAndTableView(withPlayerCount: 1)
        
        // when
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        
        // then
        XCTAssertTrue(cell is ScoreboardTableViewCell)
    }
    
    func test_ScoreboardTableViewDelegateDatasource_WhenCellForRowAtCalled_ShouldCallCellsSetupCellWithPlayerAtIndex() {
        // given
        let (sut, tableView) = getSutAndTableView(withPlayerCount: 3)
        
        let player = sut.viewModel.sortedPlayers[2]
        
        // when
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 2, section: 0)) as? ScoreboardTableViewCellMock
        
        // then
        XCTAssertEqual(cell?.setupCellWithCalledCount, 1)
        XCTAssertEqual(cell?.setupCellWithPlayer?.id, player.id)
    }
    
    
    // MARK: - HeightForRowAt
    
    func test_ScoreboardTableviewDelegateDatasource_WhenHeightForRowAtCalled_ShouldReturn60() {
        // given
        let (sut, _) = getSutAndTableView(withPlayerCount: 0)

        // when
        let height = sut.tableView(UITableView(), heightForRowAt: IndexPath(row: 0, section: 0))

        // then
        XCTAssertEqual(height, 60)
    }
    
    // MARK: - DidSelectRowAt
    
    func test_ScoreboardTableViewDelegateDatasource_WhenDidSelectRowAtCalledGameBasic_ShouldCallViewModelStartEditingPlayerScoreAtWithRow() {
        // given
        let (sut, tableView) = getSutAndTableView(withPlayerCount: 0)
        let game = GameMock()
        game.gameType = .basic
        let viewModelMock = ScoreboardViewModelMock(game: game)
        sut.viewModel = viewModelMock
        
        let index = Int.random(in: 0...10)
        
        // when
        sut.tableView(tableView, didSelectRowAt: IndexPath(row: index, section: 0))
        
        // then
        XCTAssertEqual(viewModelMock.startEditingPlayerScoreAtCalledCount, 1)
        XCTAssertEqual(viewModelMock.startEditingPlayerScoreAtIndex, index)
    }
    
    func test_ScoreboardTableViewDelegateDatasource_WhenDidSelectRowAtCalledGameTypeRound_ShouldNotCallViewModelStartEditingPlayerScoreAt() {
        // given
        let (sut, tableView) = getSutAndTableView(withPlayerCount: 0)
        let game = GameMock()
        game.gameType = .round
        let viewModelMock = ScoreboardViewModelMock(game: game)
        sut.viewModel = viewModelMock
        
        // when
        sut.tableView(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        
        // then
        XCTAssertEqual(viewModelMock.startEditingPlayerScoreAtCalledCount, 0)
    }
    
    
    // MARK: - TrailingSwipeActions
    
    func test_ScoreboardTableViewDelegateDatasource_WhenTrailingSwipeActionsConfigurationForAtCalled_ShouldReturnTwoActions() {
        // given
        let (sut, tableView) = getSutAndTableView(withPlayerCount: 0)
        
        // when
        let swipeActionsConfig = sut.tableView(tableView, trailingSwipeActionsConfigurationForRowAt: IndexPath(row: 0, section: 0))
        
        // then
        XCTAssertEqual(swipeActionsConfig?.actions.count, 2)
    }
    
    func test_ScoreboardTableViewDelegateDatasource_WhenTrailingSwipeActionsConfiguartionForRowAt_ShouldReturnFirstActionAsDeleteAction() {
        // given
        let (sut, tableView) = getSutAndTableView(withPlayerCount: 0)
        
        // when
        let swipeActionsConfig = sut.tableView(tableView, trailingSwipeActionsConfigurationForRowAt: IndexPath(row: 0, section: 0))
        
        // then
        let deleteAction = swipeActionsConfig?.actions.first

        XCTAssertEqual(deleteAction?.title, "Delete")
        XCTAssertEqual(deleteAction?.style, .destructive)
    }
    
    func test_ScoreboardTableViewDelegateDatasource_WhenWhenTrailingSwipeActionsConfiguartionForRowAt_ShouldReturnFirstActionAsEditAction() {
        // given
        let (sut, tableView) = getSutAndTableView(withPlayerCount: 0)
        
        // when
        let swipeActionsConfig = sut.tableView(tableView, trailingSwipeActionsConfigurationForRowAt: IndexPath(row: 0, section: 0))
        
        // then
        let editAction = swipeActionsConfig?.actions[1]

        XCTAssertEqual(editAction?.title, "Edit")
        XCTAssertEqual(editAction?.style, .normal)
    }
    
    func test_ScoreboardTableViewDelegateDatasource_WhenDeleteSwipeActionCalled_ShouldCallViewModelDeletePlayerAt() {
        // given
        let (sut, tableView) = getSutAndTableView(withPlayerCount: 0)
        let viewModelMock = ScoreboardViewModelMock()
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
        XCTAssertEqual(viewModelMock.startDeletingPlayerAtCalledCount, 1)
        XCTAssertEqual(viewModelMock.startDeletingPlayerAtIndex, index)
    }
    
    func test_ScoreboardTableViewDelegateDatasource_WhenEditSwipeActionCalled_ShouldCallViewModelStartEditingPlayerAt() {
        // given
        let (sut, tableView) = getSutAndTableView(withPlayerCount: 0)
        let viewModelMock = ScoreboardViewModelMock()
        sut.viewModel = viewModelMock
        let index = Int.random(in: 0...10)
        
        // when
        let swipeActionsConfig = sut.tableView(tableView, trailingSwipeActionsConfigurationForRowAt: IndexPath(row: index, section: 0))
        guard let action = swipeActionsConfig?.actions[1] else {
            XCTFail("This should have a edit action")
            return
        }
        
        action.handler(action, UIView(), {_ in})
        
        // then
        XCTAssertEqual(viewModelMock.startEditingPlayerAtCalledCount, 1)
        XCTAssertEqual(viewModelMock.startEditingPlayerAtIndex, index)
    }
    
    
    // MARK: - Classes
    
    class ScoreboardTableViewCellMock: ScoreboardTableViewCell {
        var setupCellWithCalledCount = 0
        var setupCellWithPlayer: PlayerProtocol?
        override func setupCellWith(_ player: PlayerProtocol) {
            setupCellWithPlayer = player
            setupCellWithCalledCount += 1
        }
        
        var setupCellForErrorCalledCount = 0
        override func setupCellForError() {
            setupCellForErrorCalledCount += 1
        }
    }
}
