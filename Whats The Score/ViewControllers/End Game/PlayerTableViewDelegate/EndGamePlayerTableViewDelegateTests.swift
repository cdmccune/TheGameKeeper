//
//  EndGamePlayerTableViewDelegateTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 3/8/24.
//

import XCTest
@testable import Whats_The_Score

final class EndGamePlayerTableViewDelegateTests: XCTestCase {

    // MARK: - Setup Functions

    var tableViewMock: UITableView?
    
    override func setUp() {
        tableViewMock = UITableView()
        tableViewMock?.register(EndGamePlayerTableViewCellMock.self, forCellReuseIdentifier: "EndGamePlayerTableViewCell")
    }
    
    override func tearDown() {
        tableViewMock = nil
    }
    
    func getSutAndTableView(withPlayerCount playerCount: Int) -> (EndGamePlayerTableViewDelegate, UITableView) {
        
        var players = [PlayerProtocol]()
        for _ in 0..<playerCount {
            players.append(PlayerMock())
        }
        
        let viewModelMock = EndGameViewModelMock()
        viewModelMock.losingPlayers = players
        
        let sut = EndGamePlayerTableViewDelegate(viewModel: viewModelMock)
        let tableView = tableViewMock!
        tableView.delegate = sut
        tableView.dataSource = sut
        
        return (sut, tableView)
    }
    
    
    // MARK: - Number of Rows
    
    func test_EndGamePlayerTableViewDelegate_WhenNumberOfRowsInSectionCalled_ShouldReturnViewModelNonWinningPlayersCount() {
        // given
        let playerCount = Int.random(in: 2...10)
        let (sut, tableView) = getSutAndTableView(withPlayerCount: playerCount)
        
        // when
        let count = sut.tableView(tableView, numberOfRowsInSection: 0)
        
        // then
        XCTAssertEqual(count, playerCount)
    }
    
    func test_EndGamePlayerTableViewDelegate_WhenNumberOfRowsInSectionCalledNoPlayers_ShouldReturn1() {
        // given
        let playerCount = 0
        let (sut, tableView) = getSutAndTableView(withPlayerCount: playerCount)
        
        // when
        let count = sut.tableView(tableView, numberOfRowsInSection: 0)
        
        // then
        XCTAssertEqual(count, 1)
    }
    
    
    // MARK: - CellForRowAt
    
    func test_EndGamePlayerTableViewDelegate_WhenCellForRowAtCalled_ShouldReturnEndGamePlayerTableViewCell() {
        // given
        let (sut, tableView) = getSutAndTableView(withPlayerCount: 0)
        
        // when
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        
        // then
        XCTAssertTrue(cell is EndGamePlayerTableViewCell)
    }
    
    func test_EndGamePlayerTableViewDelegate_WhenCellForRowAtCalledRowZeroNoLosingPlayers_ShouldCallCellsSetupNoLosingPlayers() {
        // given
        let (sut, tableView) = getSutAndTableView(withPlayerCount: 0)
        
        // when
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? EndGamePlayerTableViewCellMock
        
        // then
        XCTAssertEqual(cell?.setupNoLosingPlayersCalledCount, 1)
    }
    
    func test_EndGamePlayerTableViewDelegate_WhenCellForRowAtCalledOutOfRangeForLosingPlayersRowNotZero_ShouldCallCellsSetupErrorCell() {
        // given
        let (sut, tableView) = getSutAndTableView(withPlayerCount: 0)
        
        // when
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 1, section: 0)) as? EndGamePlayerTableViewCellMock
        
        // then
        XCTAssertEqual(cell?.setupErrorCellCalledCount, 1)
    }
    
    func test_EndGamePlayerTableViewDelegate_WhenCellForRowAtCalledInRange_ShouldCallCellsSetupViewFor() {
        // given
        let (sut, tableView) = getSutAndTableView(withPlayerCount: 2)
        let playerIndex = 1
        
        // when
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: playerIndex, section: 0)) as? EndGamePlayerTableViewCellMock
        
        // then
        XCTAssertEqual(cell?.setupViewForCalledCount, 1)
        XCTAssertEqual(cell?.setupViewForPlayer?.id, sut.viewModel.losingPlayers[playerIndex].id)
    }
    
    func test_EndGamePlayerTableViewDelegate_WhenCellForRowAtCalled_ShouldCallCellsSetupCellWithPlayersScorePlacement() {
        // given
        let (sut, tableView) = getSutAndTableView(withPlayerCount: 0)
        
        let game = GameMock()
        
        let winningPlayerCount = Int.random(in: 1...10)
        let losingPlayerCount = 5
        
        var winningPlayers = [PlayerMock]()
        var losingPlayers = [PlayerMock]()
        
        for i in 0..<winningPlayerCount {
            winningPlayers.append(PlayerMock())
        }
        
        for i in 0..<losingPlayerCount {
            losingPlayers.append(PlayerMock(score: losingPlayerCount - i))
        }
        game.winningPlayers = winningPlayers
        sut.viewModel.game = game
        
        (sut.viewModel as? EndGameViewModelMock)?.losingPlayers = losingPlayers
        
        let playerIndex = Int.random(in: 0..<losingPlayerCount)
        
        // when
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: playerIndex, section: 0)) as? EndGamePlayerTableViewCellMock
        
        // then
        let losingPlayersSortedByScore = losingPlayers.sorted { $0.score > $1.score }
        let playerLosersPlace =  (losingPlayersSortedByScore.firstIndex { $0.score == losingPlayers[playerIndex].score } ?? 0) + 1
        let place = winningPlayerCount + playerLosersPlace
        XCTAssertEqual(cell?.setupViewForPlace, place)
    }
    
    func test_EndGamePlayerTableViewDelegate_WhenCellForRowAtCalledPlayersTied_ShouldSend1ForAllPlaces() {
        // given
        let (sut, tableView) = getSutAndTableView(withPlayerCount: 2)
        
        // when
        let cell1 = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? EndGamePlayerTableViewCellMock
        let cell2 = sut.tableView(tableView, cellForRowAt: IndexPath(row: 1, section: 0)) as? EndGamePlayerTableViewCellMock
        
        // then
        XCTAssertEqual(cell1?.setupViewForPlace, 1)
        XCTAssertEqual(cell2?.setupViewForPlace, 1)
    }
    
    func test_EndGamePlayerTableViewDelegate_WhenCellForRowAtCalledPlayersTied_ShouldSendTrueForIsTied() {
        // given
        let (sut, tableView) = getSutAndTableView(withPlayerCount: 2)
        
        // when
        let cell1 = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? EndGamePlayerTableViewCellMock
        
        // then
        XCTAssertTrue(cell1?.setupViewForIsTied ?? false)
    }
    
    func test_EndGamePlayerTableViewDelegate_WhenCellForRowAtCalledPlayersNot_ShouldSendFalseForIsTied() {
        // given
        let (sut, tableView) = getSutAndTableView(withPlayerCount: 1)
        
        // when
        let cell1 = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? EndGamePlayerTableViewCellMock
        
        // then
        XCTAssertFalse(cell1?.setupViewForIsTied ?? true)
    }

}

class EndGamePlayerTableViewCellMock: EndGamePlayerTableViewCell {
    var setupNoLosingPlayersCalledCount = 0
    override func setupNoLosingPlayers() {
        setupNoLosingPlayersCalledCount += 1
    }
    
    var setupErrorCellCalledCount = 0
    override func setupErrorCell() {
        setupErrorCellCalledCount += 1
    }
    
    var setupViewForCalledCount = 0
    var setupViewForPlayer: PlayerProtocol?
    var setupViewForPlace: Int?
    var setupViewForIsTied: Bool?
    override func setupViewFor(_ player: PlayerProtocol, inPlace place: Int, isTied: Bool) {
        setupViewForCalledCount += 1
        setupViewForPlayer = player
        setupViewForPlace = place
        setupViewForIsTied = isTied
    }
}
