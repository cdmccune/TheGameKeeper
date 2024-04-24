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
        tableViewMock?.register(UINib(nibName: "MyGamesTableViewHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "MyGamesTableViewHeaderView")
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
    
    func test_MyGamesTableViewDelegateDatasource_WhenNumberOfRowsInSectionCalledSection0WithEmptyActiveGames_ShouldReturn1() {
        // given
        let (sut, tableView) = getSutAndTableView()

        let viewModel = MyGamesViewModelMock()
        viewModel.activeGames = []
        sut.viewModel = viewModel

        // when
        let count = sut.tableView(tableView, numberOfRowsInSection: 0)

        // then
        XCTAssertEqual(count, 1)
    }

    func test_MyGamesTableViewDelegateDatasource_WhenNumberOfRowsInSectionCalledSection1WithEmptyPausedGames_ShouldReturn1() {
        // given
        let (sut, tableView) = getSutAndTableView()

        let viewModel = MyGamesViewModelMock()
        viewModel.pausedGames = []
        sut.viewModel = viewModel

        // when
        let count = sut.tableView(tableView, numberOfRowsInSection: 1)

        // then
        XCTAssertEqual(count, 1)
    }

    func test_MyGamesTableViewDelegateDatasource_WhenNumberOfRowsInSectionCalledSection2WithEmptyCompletedGames_ShouldReturn1() {
        // given
        let (sut, tableView) = getSutAndTableView()

        let viewModel = MyGamesViewModelMock()
        viewModel.completedGames = []
        sut.viewModel = viewModel

        // when
        let count = sut.tableView(tableView, numberOfRowsInSection: 2)

        // then
        XCTAssertEqual(count, 1)
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
    
    func test_MyGamesTableViewDelegateDatasource_WhenDidSelectRowAtCalled_ShouldCallViewModelDidSelectRowAtWithCorrectSectionAndRow() {
        // given
        let (sut, tableView) = getSutAndTableView()
        let viewModel = MyGamesViewModelMock()
        sut.viewModel = viewModel
        
        let indexPath = IndexPath(row: Int.random(in: 0...10), section: Int.random(in: 0...10))
        
        // when
        sut.tableView(tableView, didSelectRowAt: indexPath)
        
        // then
        XCTAssertEqual(viewModel.didSelectRowAtIndexPath, indexPath)
        XCTAssertEqual(viewModel.didSelectRowAtCalledCount, 1)
    }
    
    
    // MARK: - TrailingSwipe
    
    func test_MyGamesTableViewDelegateDatasource_WhenTrailingSwipeActionsConfiguartionForRowAtSection0OutOfRange_ShouldReturnNil() {
        // given
        let (sut, tableView) = getSutAndTableView()
        
        // when
        let swipeActionsConfig = sut.tableView(tableView, trailingSwipeActionsConfigurationForRowAt: IndexPath(row: 0, section: 0))
        
        // then
        XCTAssertNil(swipeActionsConfig)
    }
    
    func test_MyGamesTableViewDelegateDatasource_WhenTrailingSwipeActionsConfiguartionForRowAtSection1OutOfRange_ShouldReturnNil() {
        // given
        let (sut, tableView) = getSutAndTableView()
        
        // when
        let swipeActionsConfig = sut.tableView(tableView, trailingSwipeActionsConfigurationForRowAt: IndexPath(row: 0, section: 1))
        
        // then
        XCTAssertNil(swipeActionsConfig)
    }
    
    func test_MyGamesTableViewDelegateDatasource_WhenTrailingSwipeActionsConfiguartionForRowAtSection2OutOfRange_ShouldReturnNil() {
        // given
        let (sut, tableView) = getSutAndTableView()
        
        // when
        let swipeActionsConfig = sut.tableView(tableView, trailingSwipeActionsConfigurationForRowAt: IndexPath(row: 0, section: 2))
        
        // then
        XCTAssertNil(swipeActionsConfig)
    }
    
    func test_MyGamesTableViewDelegateDatasource_WhenTrailingSwipeActionsConfiguartionForRowAtInRange_ShouldReturnOneActionWithDeleteTitle() {
        // given
        let (sut, tableView) = getSutAndTableView()
        let viewModel = MyGamesViewModelMock()
        viewModel.activeGames = [GameMock(gameStatus: .active)]
        sut.viewModel = viewModel
        
        // when
        let swipeActionsConfig = sut.tableView(tableView, trailingSwipeActionsConfigurationForRowAt: IndexPath(row: 0, section: 0))
        
        // then
        XCTAssertNotNil(swipeActionsConfig?.actions.first)
        XCTAssertEqual(swipeActionsConfig?.actions.first?.title, "Delete")
        XCTAssertEqual(swipeActionsConfig?.actions.first?.style, .destructive)
    }
    
    func test_MyGamesTableViewDelegateDatasource_WhenDeleteSwipeActionCalledInRange_ShouldCallViewModelDeletePlayerAt() {
        // given
        let (sut, tableView) = getSutAndTableView()
        let viewModelMock = MyGamesViewModelMock()
        viewModelMock.activeGames = Array(repeating: GameMock(gameStatus: .active), count: 11)
        sut.viewModel = viewModelMock
        
        let indexPath = IndexPath(row: Int.random(in: 1...10), section: 0)
        
        // when
        let swipeActionsConfig = sut.tableView(tableView, trailingSwipeActionsConfigurationForRowAt: indexPath)
        guard let action = swipeActionsConfig?.actions.first else {
            XCTFail("This should have a delete action")
            return
        }
        
        action.handler(action, UIView(), {_ in})
        
        // then
        XCTAssertEqual(viewModelMock.deleteGameAtCalledCount, 1)
        XCTAssertEqual(viewModelMock.deleteGameAtIndexPath, indexPath)
    }
    
    
    // MARK: - HeaderInSection
    
    func test_MyGamesTableViewDelegateDatasource_WhenHeaderInSectionCalledSection0_ShouldReturnActiveGameHeader() {
        // given
        let (sut, tableView) = getSutAndTableView()

        // when
        let header = sut.tableView(tableView, viewForHeaderInSection: 0) as? MyGamesTableViewHeaderView

        // then
        XCTAssertNotNil(header)
        XCTAssertEqual(header?.sectionTitleLabel.text, "Active Game")
    }

    func test_MyGamesTableViewDelegateDatasource_WhenHeaderInSectionCalledSection1_ShouldReturnPausedGamesHeader() {
        // given
        let (sut, tableView) = getSutAndTableView()

        // when
        let header = sut.tableView(tableView, viewForHeaderInSection: 1) as? MyGamesTableViewHeaderView

        // then
        XCTAssertNotNil(header)
        XCTAssertEqual(header?.sectionTitleLabel.text, "Paused Games")
    }

    func test_MyGamesTableViewDelegateDatasource_WhenHeaderInSectionCalledSection2_ShouldReturnCompletedGamesHeader() {
        // given
        let (sut, tableView) = getSutAndTableView()

        // when
        let header = sut.tableView(tableView, viewForHeaderInSection: 2) as? MyGamesTableViewHeaderView

        // then
        XCTAssertNotNil(header)
        XCTAssertEqual(header?.sectionTitleLabel.text, "Completed Games")
    }
    
    
    // MARK: - HeightForHeaderInSection
    
    func test_MyGamesTableViewDelegateDatasource_WhenHeightForHeaderInSectionCalled_ShouldReturn40() {
        // given
        let (sut, tableView) = getSutAndTableView()

        // when
        let height = sut.tableView(tableView, heightForHeaderInSection: 0)

        // then
        XCTAssertEqual(height, 40)
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
