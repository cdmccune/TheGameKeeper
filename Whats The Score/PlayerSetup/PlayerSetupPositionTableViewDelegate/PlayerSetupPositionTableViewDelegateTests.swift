//
//  PlayerSetupPositionTableViewDelegateTests.swift
//  What's The Score Tests
//
//  Created by Curt McCune on 1/3/24.
//

import XCTest
@testable import Whats_The_Score

final class PlayerSetupPositionTableViewDelegateTests: XCTestCase {
    
    // MARK: - Setup Functions
    
    var tableViewMock: UITableView?
    
    override func setUp() {
        tableViewMock = UITableView()
        tableViewMock?.register(UINib(nibName: "PlayerSetupPositionTableViewCell", bundle: nil), forCellReuseIdentifier: "PlayerSetupPositionTableViewCell")
    }
    
    override func tearDown() {
        tableViewMock = nil
    }
    
    func getPlayerViewModel(withPlayerCount count: Int) -> PlayerSetupViewModelProtocol {
        let players = Array(repeating: Player(name: "",
                                              position: 0), count: count)
        let mock = PlayerSetupViewModelMock()
        let gameMock = GameMock(players: players)
        mock.game = gameMock
        return mock
    }
    
    func getSutAndTableView(withPlayerCount playerCount: Int) -> (PlayerSetupPositionTableViewDelegate, UITableView) {
        let sut = PlayerSetupPositionTableViewDelegate(playerViewModel: getPlayerViewModel(withPlayerCount: playerCount))
        let tableView = tableViewMock!
        tableView.delegate = sut
        tableView.dataSource = sut
        
        return (sut, tableView)
    }
    
    // MARK: - Testing

    func test_PlayerSetupPositionTableViewDelegate_WhenNumberOfRowsInSectionCalled_ShouldReturnTheNumberOfPlayersViewModel() {
        // given
        let playerCount = Int.random(in: 1...10)
        let (sut, tableView) = getSutAndTableView(withPlayerCount: playerCount)
        
        // when
        let rowCount = sut.tableView(tableView, numberOfRowsInSection: 0)
        
        // then
        XCTAssertEqual(rowCount, playerCount)
    }
    
    func test_PlayerSetupPositionTableViewDelegate_WhenCellForRowAtCalled_ShouldReturnPlayerSetupPositionTableViewCellWithTextOfItsPlayerPosition() {
        // given
        let playerCount = Int.random(in: 1...10)
        let (sut, tableView) = getSutAndTableView(withPlayerCount: playerCount)
        let chosenPlayerCell = Int.random(in: 0...playerCount-1)
        
        // when
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: chosenPlayerCell, section: 0)) as? PlayerSetupPositionTableViewCell
        
        // then
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.numberLabel.text, String(chosenPlayerCell + 1))
    }
}
