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
        tableViewMock?.register(UINib(nibName: "PlayerSetupPlayerTableViewCell", bundle: nil), forCellReuseIdentifier: "PlayerSetupPlayerTableViewCell")
    }
    
    override func tearDown() {
        tableViewMock = nil
    }
    
    func getPlayerViewModel(withPlayerCount count: Int) -> PlayerSetupViewModelProtocol {
        let players = Array(repeating: Player(name: "",
                                              position: 0), count: count)
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
    
    // MARK: - Tests

    func test_PlayerSetupPlayerTableView_WhenNumberOfRowsCalled_ShouldReturnTheNumberOfRowsInThePlayerViewModel() {
        // given
        let playerCount = Int.random(in: 2...10)
        let (sut, tableView) = getSutAndTableView(withPlayerCount: playerCount)
        
        // when
        let playerCellCount = sut.tableView(tableView, numberOfRowsInSection: 0)
        
        // then
        XCTAssertEqual(playerCount, playerCellCount)
    }
    
    func test_PlayerSetupPlayerTableView_WhenCellForRowAtCalled_ShouldReturnPlayerSetupPlayerTableViewCellWithCorrectPlayerName() {
        // given
        let (sut, tableView) = getSutAndTableView(withPlayerCount: 0)
        
        let playerCount = Int.random(in: 2...5)
        var players = [Player]()
        for _ in 0..<playerCount {
            players.append(Player(name: UUID().uuidString,
                                  position: 0))
        }
        
        sut.playerViewModel.players = players
        
        let randomPlayer = Int.random(in: 0...playerCount-1)
        
        // when
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: randomPlayer, section: 0))
        
        // then
        XCTAssertTrue(cell is PlayerSetupPlayerTableViewCell)
        XCTAssertEqual((cell as? PlayerSetupPlayerTableViewCell)?.playerTextField.text, players[randomPlayer].name)
    }
    
    func test_PlayerSetupPlayerTableView_WhenCellForRowAtCalled_ShouldSetCellsTextFieldDelegatesDefaultNameProperty() {
        
        
        // given
        let (sut, tableView) = getSutAndTableView(withPlayerCount: 0)
        
        let hasDefaultName = Bool.random()
        
        let player1 = Player(name: hasDefaultName ? "" : "fd", position: 0)
        sut.playerViewModel.players = [player1]
        
        // when
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? PlayerSetupPlayerTableViewCell
        
        // then
        XCTAssertEqual(cell?.textFieldDelegate.hasDefaultName, player1.hasDefaultName)
    }
    
    func test_PlayerSetupPlayerTableView_WhenCellForRowAtCalled_ShouldShouldSetCellsPlayerNameChangedFunction() {
        // given
        let (sut, tableView) = getSutAndTableView(withPlayerCount: 1)
        
        // when
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? PlayerSetupPlayerTableViewCell
        
        // then
        XCTAssertNotNil(cell?.playerNameChanged)
    }
    
    func test_PlayerSetupPlayerTableView_WhenPlayerNameChangedCalledOn_ShouldCallChangePlayerNameOnPlayerViewModelWithCorrectCellRow() {
        // given
        let playerCount = Int.random(in: 1...9)
        let (sut, tableView) = getSutAndTableView(withPlayerCount: playerCount)
        
        let testString = UUID().uuidString
        let randomPlayer = Int.random(in: 0...(playerCount - 1))
        
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: randomPlayer, section: 0)) as? PlayerSetupPlayerTableViewCell
        
        // when
        cell?.playerNameChanged?(testString)
        
        // then
        XCTAssertEqual((sut.playerViewModel as? PlayerSetupViewModelMock)?.playerNameChangedName, testString)
        XCTAssertEqual((sut.playerViewModel as? PlayerSetupViewModelMock)?.playerNameChangedIndex, randomPlayer)
    }
    
    func test_PlayerSetupPlayerTableView_WhenMoveRowAtCalled_ShouldCallPlayerViewModelMovePlayerAt() {
        // given
        let (sut, tableView) = getSutAndTableView(withPlayerCount: 5)
        
        // when
        let sourceRow = 0
        let destinationRow = 1
        sut.tableView(tableView, moveRowAt: IndexPath(row: sourceRow, section: 0), to: IndexPath(row: destinationRow, section: 0))
        
        // then
        XCTAssertEqual((sut.playerViewModel as? PlayerSetupViewModelMock)?.movePlayerAtCalledCount, 1)
        XCTAssertEqual((sut.playerViewModel as? PlayerSetupViewModelMock)?.movePlayerAtSourceRow, sourceRow)
        XCTAssertEqual((sut.playerViewModel as? PlayerSetupViewModelMock)?.movePlayerAtDestinationRow, destinationRow)
    }
    
    func test_PlayerSetupPlayerTableView_WhenShouldIndentWhilteEditingRowAtCalled_ShouldReturnFalse() {
        // given
        let (sut, tableView) = getSutAndTableView(withPlayerCount: 0)
        
        // when
        let shouldIndent = sut.tableView(tableView, shouldIndentWhileEditingRowAt: IndexPath(row: 0, section: 0))
        
        // then
        XCTAssertFalse(shouldIndent)
    }
    
    func test_PlayerSetupPlayerTableView_WhenEditingStyleForRowAtCalled_ShouldReturnNone() {
        // given
        let (sut, tableView) = getSutAndTableView(withPlayerCount: 0)
        
        // when
        let editingStyle = sut.tableView(tableView, editingStyleForRowAt: IndexPath(row: 0, section: 0))
        
        // then
        XCTAssertEqual(editingStyle, .none)
    }
    
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
}
