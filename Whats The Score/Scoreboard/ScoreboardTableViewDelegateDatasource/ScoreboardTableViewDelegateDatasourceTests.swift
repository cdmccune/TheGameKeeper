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
        let players = Array(repeating: Player(name: "", position: 0), count: playerCount)
        let gameMock = GameMock(players: players)
        let viewModelMock = ScoreboardViewModelMock(game: gameMock)
        
        let sut = ScoreboardTableViewDelegateDatasource(viewModel: viewModelMock)
        let tableView = tableViewMock!
        tableView.delegate = sut
        tableView.dataSource = sut
        
        return (sut, tableView)
    }
    
    
    // MARK: - NumberOfRowsInSection
    
    func test_ScoreboardTableViewDelegateDatasource_WhenNumberOfRowsInSectionCalled_ShouldReturnViewModelGamePlayersCount() {
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
        let (sut, tableView) = getSutAndTableView(withPlayerCount: 0)
        
        // when
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        
        // then
        XCTAssertTrue(cell is ScoreboardTableViewCell)
    }
    
    func test_ScoreboardTableViewDelegateDatasource_WhenCellForRowAtCalled_ShouldCallCellsSetupCellWithPlayerAtIndex() {
        // given
        let (sut, tableView) = getSutAndTableView(withPlayerCount: 3)
        
        let playerName = UUID().uuidString
        let player = Player(name: playerName, position: Int.random(in: 1...10))
        sut.viewModel.game.players[2] = player
        
        // when
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 2, section: 0)) as? ScoreboardTableViewCellMock
        
        // then
        XCTAssertEqual(cell?.setupCellWithCalledCount, 1)
        XCTAssertEqual(cell?.setupVellWithPlayer, player)
    }
    
    func test_ScoreboardTableViewDelegateDatasource_WhenCellForRowAtCalledOutOfIndexForPlayer_ShouldCallCellsSetupCellForError() {
        // given
        let (sut, tableView) = getSutAndTableView(withPlayerCount: 0)
        
        // when
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 2, section: 0)) as? ScoreboardTableViewCellMock
        
        // then
        XCTAssertEqual(cell?.setupCellForErrorCalledCount, 1)
    }
    
    func test_ScoreboardTableViewDelegateDatasource_WhenCellForRowAtCalled_ShouldShouldSetCellsEditPlayerFunctionToCallViewModelStartEditingPlayer() {
        // given
        let count = Int.random(in: 2...10)
        let (sut, tableView) = getSutAndTableView(withPlayerCount: count)
        
        let indexRow = Int.random(in: 1...count)
        // when
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: indexRow, section: 0)) as? ScoreboardTableViewCellMock
        cell?.editPlayer?()
        
        // then
        let viewModelMock = sut.viewModel as? ScoreboardViewModelMock
        XCTAssertEqual(viewModelMock?.startEditingPlayerAtCalledCount, 1)
        XCTAssertEqual(viewModelMock?.startEditingPlayerAtIndex, indexRow)
    }
    
    // MARK: - DidSelectRowAt
    
    func test_ScoreboardTableViewDelegateDatasource_WhenDidSelectRowAtCalled_ShouldCallViewModelStartEditingPlayerScoreAtWithRow() {
        // given
        let (sut, tableView) = getSutAndTableView(withPlayerCount: 0)
        let viewModelMock = ScoreboardViewModelMock()
        sut.viewModel = viewModelMock
        
        let index = Int.random(in: 0...10)
        
        // when
        sut.tableView(tableView, didSelectRowAt: IndexPath(row: index, section: 0))
        
        // then
        XCTAssertEqual(viewModelMock.startEditingPlayerScoreAtCalledCount, 1)
        XCTAssertEqual(viewModelMock.startEditingPlayerScoreAtIndex, index)
    }
    
    
    // MARK: - Classes
    
    class ScoreboardTableViewCellMock: ScoreboardTableViewCell {
        var setupCellWithCalledCount = 0
        var setupVellWithPlayer: Player?
        override func setupCellWith(_ player: Player) {
            setupVellWithPlayer = player
            setupCellWithCalledCount += 1
        }
        
        var setupCellForErrorCalledCount = 0
        override func setupCellForError() {
            setupCellForErrorCalledCount += 1
        }
    }
}
