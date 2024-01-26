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
        var (sut, tableView) = getSutAndTableView(withPlayerCount: 3)
        
        let playerName = UUID().uuidString
        let player = Player(name: name, position: Int.random(in: 1...10))
        sut.viewModel.game.players[2] = player
        
        // when
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 2, section: 0)) as? ScoreboardTableViewCellMock
        
        // then
        XCTAssertEqual(cell?.setupCellWithCalledCount, 1)
        XCTAssertEqual(cell?.setupVellWithPlayer, player)
    }
    
    func test_ScoreboardTableViewDelegateDatasource_WhenCellForRowAtCalledOutOfIndexForPlayer_ShouldCallCellsSetupCellForError() {
        // given
        var (sut, tableView) = getSutAndTableView(withPlayerCount: 0)
        
        // when
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 2, section: 0)) as? ScoreboardTableViewCellMock
        
        // then
        XCTAssertEqual(cell?.setupCellForErrorCalledCount, 1)
    }
    
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
