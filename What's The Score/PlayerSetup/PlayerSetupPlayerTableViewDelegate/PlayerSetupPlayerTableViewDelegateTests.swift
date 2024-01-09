//
//  PlayerSetupPlayerTableViewDelegateTests.swift
//  What's The Score Tests
//
//  Created by Curt McCune on 1/3/24.
//

import XCTest
@testable import What_s_The_Score

final class PlayerSetupPlayerTableViewDelegateTests: XCTestCase {
    
    //MARK: - Setup
    
    var tableViewMock: UITableView?
    
    override func setUp() {
        tableViewMock = UITableView()
        tableViewMock?.register(UINib(nibName: "PlayerSetupPlayerTableViewCell", bundle: nil), forCellReuseIdentifier: "PlayerSetupPlayerTableViewCell")
    }
    
    override func tearDown() {
        tableViewMock = nil
    }
    
    func getPlayerSetupCoordinator(withPlayerCount count: Int) -> PlayerSetupPlayerCoordinator {
        let players = Array(repeating: Player(name: "",
                                             position: 0), count: count)
        return PlayerSetupPlayerCoordinatorStub(players: players)
    }
    
    func getSutAndTableView(withPlayerCount playerCount: Int) -> (PlayerSetupPlayerTableViewDelegate, UITableView) {
        let sut = PlayerSetupPlayerTableViewDelegate(playerSetupCoordinator: getPlayerSetupCoordinator(withPlayerCount: playerCount))
        let tableView = tableViewMock!
        tableView.delegate = sut
        tableView.dataSource = sut
        
        return (sut, tableView)
    }
    
    //MARK: - Setup

    func test_PlayerSetupPlayerTableView_WhenNumberOfRowsCalled_ShouldReturnTheNumberOfRowsInThePlayerSetupCoordinator() {
        //given
        let playerCount = Int.random(in: 2...10)
        let (sut, tableView) = getSutAndTableView(withPlayerCount: playerCount)
        
        //when
        let playerCellCount = sut.tableView(tableView, numberOfRowsInSection: 0)
        
        //then
        XCTAssertEqual(playerCount, playerCellCount)
    }
    
    func test_PlayerSetupPlayerTableView_WhenCellForRowAtCalled_ShouldReturnPlayerSetupPlayerTableViewCellWithCorrectPlayerName() {
        //given
        let (sut, tableView) = getSutAndTableView(withPlayerCount: 0)
        
        let playerCount = Int.random(in: 2...5)
        var players = [Player]()
        for i in 0..<playerCount {
            players.append(Player(name: UUID().uuidString,
                                  position: 0))
        }
        
        sut.playerSetupCoordinator.players = players
        
        let randomPlayer = Int.random(in: 0...playerCount-1)
        
        //when
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: randomPlayer, section: 0))
        
        //then
        XCTAssertTrue(cell is PlayerSetupPlayerTableViewCell)
        XCTAssertEqual((cell as? PlayerSetupPlayerTableViewCell)?.playerLabel.text, players[randomPlayer].name)
    }

}
