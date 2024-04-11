//
//  MyGamesTableViewDelegateDatasourceTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 4/11/24.
//

import XCTest
@testable import Whats_The_Score

final class MyGamesTableViewDelegateDatasourceTests: XCTestCase {
    
    // MARK: - Setup Functions
    
    var tableViewMock: UITableView?
    
    override func setUp() {
        tableViewMock = UITableView()
        tableViewMock?.register(MyGamesTableViewCellMock.self, forCellReuseIdentifier: "MyGamesTableViewCell")
    }
    
    override func tearDown() {
        tableViewMock = nil
    }
    
    func getSutAndTableView() -> (MyGamesTableViewDelegateDatasource, UITableView) {
        let viewModelMock = MyGamesViewModelMock()
        
        let sut = MyGamesTableViewDelegateDatasource(viewModel: viewModelMock)
        let tableView = tableViewMock!
        tableView.delegate = sut
        tableView.dataSource = sut
        
        return (sut, tableView)
    }
    
    
    // MARK: - NumberOfRowsInSection
    
    func test_MyGamesTableViewDelegateDatasource_WhenNumberOfRowsInSectionCalledSection0_ShouldReturnActiveGamesCount() {
        // given
        let (sut, tableView) = getSutAndTableView()
        
        let viewModel = MyGamesViewModelMock()
        let gameCount = Int.random(in: 1...4)
        viewModel.activeGames = Array(repeating: GameMock(), count: gameCount)
        sut.viewModel = viewModel
        
        // when
        let count = sut.tableView(tableView, numberOfRowsInSection: 0)
        
        // then
        XCTAssertEqual(count, gameCount)
    }
    
    func test_MyGamesTableViewDelegateDatasource_WhenNumberOfRowsInSectionCalledSection1_ShouldReturnPausedGamesCount() {
        // given
        let (sut, tableView) = getSutAndTableView()
        
        let viewModel = MyGamesViewModelMock()
        let gameCount = Int.random(in: 1...4)
        viewModel.pausedGames = Array(repeating: GameMock(), count: gameCount)
        sut.viewModel = viewModel
        
        // when
        let count = sut.tableView(tableView, numberOfRowsInSection: 1)
        
        // then
        XCTAssertEqual(count, gameCount)
    }
    
    func test_MyGamesTableViewDelegateDatasource_WhenNumberOfRowsInSectionCalledSection2_ShouldReturnCompletedGamesCount() {
        // given
        let (sut, tableView) = getSutAndTableView()
        
        let viewModel = MyGamesViewModelMock()
        let gameCount = Int.random(in: 1...4)
        viewModel.completedGames = Array(repeating: GameMock(), count: gameCount)
        sut.viewModel = viewModel
        
        // when
        let count = sut.tableView(tableView, numberOfRowsInSection: 2)
        
        // then
        XCTAssertEqual(count, gameCount)
    }
    
    
    // MARK: - NumberOfSections
    
    func test_MyGamesTableViewDelegateDatasource_WhenNumberOfSectionsCalled_ShouldReturn3() {
        // given
        let (sut, tableView) = getSutAndTableView()
        
        // when
        let count = sut.numberOfSections(in: tableView)
        
        // then
        XCTAssertEqual(count, 3)
    }
    
    
    // MARK: - CellForRowAt
    
    func test_MyGamesTableViewDelegateDatasource_WhenCellForRowAtCalled_ShouldReturnMyGamesTableViewCell() {
        // given
        let (sut, tableView) = getSutAndTableView()
        
        // when
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        
        // then
        XCTAssertTrue(cell is MyGamesTableViewCell)
    }
    
    func test_MyGamesTableViewDelegateDatasource_WhenCellForRowCalledInSection0_ShouldCallSetupCellForWithCorrectActiveGame() {
        // given
        let (sut, tableView) = getSutAndTableView()
        
        let viewModel = MyGamesViewModelMock()
        let games = [
            GameMock(),
            GameMock(),
            GameMock(),
            GameMock()
        ]
        let index = Int.random(in: 0...3)
        
        viewModel.activeGames = games
        sut.viewModel = viewModel
        
        // when
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: index, section: 0)) as? MyGamesTableViewCellMock
        
        // then
        XCTAssertEqual(cell?.setupCellForCalledCount, 1)
        XCTAssertEqual(cell?.setupCellForGame?.id, games[index].id )
        
    }
    
    func test_MyGamesTableViewDelegateDatasource_WhenCellForRowCalledInSection1_ShouldCallSetupCellForWithCorrectPausedGame() {
        // given
        let (sut, tableView) = getSutAndTableView()
        
        let viewModel = MyGamesViewModelMock()
        let games = [
            GameMock(),
            GameMock(),
            GameMock(),
            GameMock()
        ]
        let index = Int.random(in: 0...3)
        
        viewModel.pausedGames = games
        sut.viewModel = viewModel
        
        // when
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: index, section: 1)) as? MyGamesTableViewCellMock
        
        // then
        XCTAssertEqual(cell?.setupCellForCalledCount, 1)
        XCTAssertEqual(cell?.setupCellForGame?.id, games[index].id )
    }
    
    func test_MyGamesTableViewDelegateDatasource_WhenCellForRowCalledInSection2_ShouldCallSetupCellForWithCorrectCompletedGame() {
        // given
        let (sut, tableView) = getSutAndTableView()
        
        let viewModel = MyGamesViewModelMock()
        let games = [
            GameMock(),
            GameMock(),
            GameMock(),
            GameMock()
        ]
        let index = Int.random(in: 0...3)
        
        viewModel.completedGames = games
        sut.viewModel = viewModel
        
        // when
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: index, section: 2)) as? MyGamesTableViewCellMock
        
        // then
        XCTAssertEqual(cell?.setupCellForCalledCount, 1)
        XCTAssertEqual(cell?.setupCellForGame?.id, games[index].id )
    }
    
    func test_MyGamesTableViewDelegateDatasource_WhenCellForRowAtCalleNoGameRRowZeroActive_ShouldCallSetupNoGamesCellWithActiveStatus() {
        // given
        let (sut, tableView) = getSutAndTableView()
        
        // when
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? MyGamesTableViewCellMock
        
        // then
        XCTAssertEqual(cell?.setupNoGamesCellCalledCount, 1)
        XCTAssertEqual(cell?.setupNoGamesStatus, .active)
    }
    
    func test_MyGamesTableViewDelegateDatasource_WhenCellForRowAtCalledNoGameRowZeroPaused_ShouldCallSetupNoGamesCellWithPausedStatus() {
        // given
        let (sut, tableView) = getSutAndTableView()
        
        // when
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 1)) as? MyGamesTableViewCellMock
        
        // then
        XCTAssertEqual(cell?.setupNoGamesCellCalledCount, 1)
        XCTAssertEqual(cell?.setupNoGamesStatus, .paused)
    }

    func test_MyGamesTableViewDelegateDatasource_WhenCellForRowAtCalledNoGameRowZeroCompleted_ShouldCallSetupNoGamesCellWithCompletedStatus() {
        // given
        let (sut, tableView) = getSutAndTableView()
        
        // when
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 2)) as? MyGamesTableViewCellMock
        
        // then
        XCTAssertEqual(cell?.setupNoGamesCellCalledCount, 1)
        XCTAssertEqual(cell?.setupNoGamesStatus, .completed)
    }
    
    func test_MyGamesTableViewDelegateDatasource_WhenCellForRowAtNoGamesRowNotZero_ShouldCallCellSetupErrorCell() {
        // given
        let (sut, tableView) = getSutAndTableView()
        
        // when
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 1, section: 0)) as? MyGamesTableViewCellMock
        
        // then
        XCTAssertEqual(cell?.setupErrorCellCalledCount, 1)
    }
    
    
    // MARK: - Classes
    
    class MyGamesTableViewCellMock: MyGamesTableViewCell {
        var setupCellForCalledCount = 0
        var setupCellForGame: GameProtocol?
        
        override func setupCellFor(_ game: GameProtocol) {
            setupCellForGame = game
            setupCellForCalledCount += 1
        }
        
        var setupNoGamesCellCalledCount = 0
        var setupNoGamesStatus: GameStatus?
        override func setupNoGamesCell(for status: GameStatus) {
            setupNoGamesCellCalledCount += 1
            self.setupNoGamesStatus = status
        }
        
        var setupErrorCellCalledCount = 0
        override func setupErrorCell() {
            setupErrorCellCalledCount += 1
        }
    }
    
}
