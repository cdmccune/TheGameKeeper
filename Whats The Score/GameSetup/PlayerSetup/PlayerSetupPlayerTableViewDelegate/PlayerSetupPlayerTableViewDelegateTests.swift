//
//  PlayerSetupPlayerTableViewDelegateTests.swift
//  What's The Score Tests
//
//  Created by Curt McCune on 1/3/24.
//

import XCTest
@testable import Whats_The_Score

final class PlayerSetupPlayerTableViewDelegateTests: XCTestCase {
    
    // MARK: - Setup
    
    var tableViewMock: UITableView?
    
    override func setUp() {
        tableViewMock = UITableView()
        tableViewMock?.register(PlayerSetupPlayerTableViewCellMock.self, forCellReuseIdentifier: "PlayerSetupPlayerTableViewCell")
    }
    
    override func tearDown() {
        tableViewMock = nil
    }
    
    func getPlayerViewModel(withPlayerCount count: Int) -> PlayerSetupViewModelProtocol {
        let players = Array(repeating: PlayerSettings.getStub(), count: count)
        let mock = PlayerSetupViewModelMock()
        mock.players = players
        return mock
    }
    
    func getSutAndTableView(withPlayerCount playerCount: Int) -> (PlayerSetupPlayerTableViewDelegate, UITableView) {
        let sut = PlayerSetupPlayerTableViewDelegate(playerViewModel: getPlayerViewModel(withPlayerCount: playerCount))
        let tableView = tableViewMock!
        tableView.delegate = sut
        tableView.dataSource = sut
        
        return (sut, tableView)
    }
    
    
    // MARK: - NumberOfRowsInSection

    func test_PlayerSetupPlayerTableView_WhenNumberOfRowsCalled_ShouldReturnTheNumberOfRowsInThePlayerViewModel() {
        // given
        let playerCount = Int.random(in: 2...10)
        let (sut, tableView) = getSutAndTableView(withPlayerCount: playerCount)
        
        // when
        let playerCellCount = sut.tableView(tableView, numberOfRowsInSection: 0)
        
        // then
        XCTAssertEqual(playerCount, playerCellCount)
    }
    
    
    // MARK: - CellForRowAt
    
    func test_PlayerSetupPlayerTableView_WhenCellForRowAtCalled_ShouldReturnPlayerSetupPlayerTableViewCell() {
        // given
        let (sut, tableView) = getSutAndTableView(withPlayerCount: 0)
        
        // when
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        
        // then
        XCTAssertTrue(cell is PlayerSetupPlayerTableViewCell)
    }
    
    func test_PlayerSetupPlayerTableView_WhenCellForRowAtCalled_ShouldCallCellsSetupErrorCell() {
        // given
        let (sut, tableView) = getSutAndTableView(withPlayerCount: 0)
        
        // when
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? PlayerSetupPlayerTableViewCellMock
        
        // then
        XCTAssertEqual(cell?.setupErrorCellCalledCount, 1)
    }
    
    func test_PlayerSetupPlayerTableView_WhenCellForRowAtCalled_ShouldCallSetupViewPropertiesForWithCorrectPlayer() {
        // given
        let (sut, tableView) = getSutAndTableView(withPlayerCount: 5)
        let randomPlayerSettingIndex = Int.random(in: 0..<5)
        
        // when
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: randomPlayerSettingIndex, section: 0)) as? PlayerSetupPlayerTableViewCellMock
        
        // then
        XCTAssertEqual(cell?.setupViewPropertiesForCalledCount, 1)
        XCTAssertEqual(cell?.setupViewPropertiesForPlayer, sut.playerViewModel.players[randomPlayerSettingIndex])
    }
    
    func test_PlayerSetupPlayerTableView_WhenDidSelectRowAt_ShouldCallViewModelEditPlayerAt() {
        // given
        let (sut, tableView) = getSutAndTableView(withPlayerCount: 0)
        let viewModel = PlayerSetupViewModelMock()
        sut.playerViewModel = viewModel
        
        let index = Int.random(in: 1...100)
        
        // when
        sut.tableView(tableView, didSelectRowAt: IndexPath(row: index, section: 0))
        
        // then
        XCTAssertEqual(viewModel.editPlayerAtCalledCount, 1)
        XCTAssertEqual(viewModel.editPlayerAtIndex, index)
    }
    
//    // MARK: - MoveRowAt
//    
//    func test_PlayerSetupPlayerTableView_WhenMoveRowAtCalled_ShouldCallPlayerViewModelMovePlayerAt() {
//        // given
//        let (sut, tableView) = getSutAndTableView(withPlayerCount: 5)
//        
//        // when
//        let sourceRow = 0
//        let destinationRow = 1
//        sut.tableView(tableView, moveRowAt: IndexPath(row: sourceRow, section: 0), to: IndexPath(row: destinationRow, section: 0))
//        
//        // then
//        XCTAssertEqual((sut.playerViewModel as? PlayerSetupViewModelMock)?.movePlayerAtCalledCount, 1)
//        XCTAssertEqual((sut.playerViewModel as? PlayerSetupViewModelMock)?.movePlayerAtSourceRow, sourceRow)
//        XCTAssertEqual((sut.playerViewModel as? PlayerSetupViewModelMock)?.movePlayerAtDestinationRow, destinationRow)
//    }
    
    
//    // MARK: - Should Indent
//    
//    func test_PlayerSetupPlayerTableView_WhenShouldIndentWhileEditingRowAtCalled_ShouldReturnFalse() {
//        // given
//        let (sut, tableView) = getSutAndTableView(withPlayerCount: 0)
//        
//        // when
//        let shouldIndent = sut.tableView(tableView, shouldIndentWhileEditingRowAt: IndexPath(row: 0, section: 0))
//        
//        // then
//        XCTAssertFalse(shouldIndent)
//    }
    
    
//    // MARK: - EditingStyle
//    
//    func test_PlayerSetupPlayerTableView_WhenEditingStyleForRowAtCalled_ShouldReturnNone() {
//        // given
//        let (sut, tableView) = getSutAndTableView(withPlayerCount: 0)
//        
//        // when
//        let editingStyle = sut.tableView(tableView, editingStyleForRowAt: IndexPath(row: 0, section: 0))
//        
//        // then
//        XCTAssertEqual(editingStyle, .none)
//    }
    
    
    // MARK: - TrailingSwipe
    
    func test_PlayerSetupPlayerTableView_WhenTrailingSwipeActionsConfiguartionForRowAt_ShouldReturnOneActionWithDeleteTitle() {
        // given
        let (sut, tableView) = getSutAndTableView(withPlayerCount: 0)
        
        // when
        let swipeActionsConfig = sut.tableView(tableView, trailingSwipeActionsConfigurationForRowAt: IndexPath(row: 0, section: 0))
        
        // then
        XCTAssertNotNil(swipeActionsConfig?.actions.first)
        XCTAssertEqual(swipeActionsConfig?.actions.first?.title, "Delete")
        XCTAssertEqual(swipeActionsConfig?.actions.first?.style, .destructive)
    }
    
    func test_PlayerSetupPlayerTableView_WhenDeleteSwipeActionCalled_ShouldCallViewModelDeletePlayerAt() {
        // given
        let (sut, tableView) = getSutAndTableView(withPlayerCount: 0)
        let viewModelMock = PlayerSetupViewModelMock()
        sut.playerViewModel = viewModelMock
        
        // when
        let swipeActionsConfig = sut.tableView(tableView, trailingSwipeActionsConfigurationForRowAt: IndexPath(row: 0, section: 0))
        guard let action = swipeActionsConfig?.actions.first else {
            XCTFail("This should have a delete action")
            return
        }
        
        action.handler(action, UIView(), {_ in})
        
        // then
        XCTAssertEqual(viewModelMock.deletePlayerAtCalledCount, 1)
    }
    
    class PlayerSetupPlayerTableViewCellMock: PlayerSetupPlayerTableViewCell {
        var setupViewPropertiesForCalledCount = 0
        var setupViewPropertiesForPlayer: PlayerSettings?
        override func setupViewPropertiesFor(player: PlayerSettings) {
            setupViewPropertiesForCalledCount += 1
            setupViewPropertiesForPlayer = player
        }
        
        var setupErrorCellCalledCount = 0
        override func setupErrorCell() {
            setupErrorCellCalledCount += 1
        }
    }
}
