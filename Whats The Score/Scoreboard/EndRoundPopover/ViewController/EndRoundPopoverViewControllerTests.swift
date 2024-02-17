//
//  EndRoundPopoverViewControllerTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 2/16/24.
//

import XCTest
@testable import Whats_The_Score

final class EndRoundPopoverViewControllerTests: XCTestCase {

    // MARK: - Setup
    
    var viewController: EndRoundPopoverViewController!

    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "EndRoundPopoverViewController") as? EndRoundPopoverViewController else {
            fatalError("EndRoundPopoverViewController wasn't found")
        }
        self.viewController = viewController
    }
    
    override func tearDown() {
        viewController = nil
    }
    
    
    // MARK: - Initialized
    
    func test_EndRoundPopoverViewController_WhenViewLoaded_ShouldHaveNonNilOutlets() {
        // given
        let sut = viewController!
        
        // when
        sut.loadView()
        
        // then
        XCTAssertNotNil(sut.tableView)
        XCTAssertNotNil(sut.roundLabel)
    }
    
    
    // MARK: - ViewDidLoad
    
    func test_EndRoundPopoverViewController_WhenViewDidLoadCalled_ShouldSetTableViewDelegateAndDatasource() {
        // given
        let sut = viewController!
        sut.loadView()
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertTrue(sut.tableView.delegate is EndRoundPopoverViewController)
        XCTAssertTrue(sut.tableView.dataSource is EndRoundPopoverViewController)
    }
    
    func test_EndRoundPopoverViewController_WhenViewDidLoadCalled_ShouldRegisterNibForTableView() {
        // given
        let sut = viewController!
        sut.loadView()
        
        // when
        sut.viewDidLoad()
        
        // then
        let cell = sut.tableView.dequeueReusableCell(withIdentifier: "EndRoundPopoverTableViewCell")
        XCTAssertTrue(cell is EndRoundPopoverTableViewCell)
    }
    
    func test_EndRoundPopoverViewController_WhenViewDidLoadCalled_ShouldSetRoundTextToCurrentRound() {
        // given
        let sut = viewController!
        sut.loadView()
        
        let round = Int.random(in: 0...1000)
        sut.round = round
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(sut.roundLabel.text, "Round \(round)")
    }
    
    func test_EndRoundPopoverViewController_WhenViewDidLoadCalledNotRound_ShouldSetRoundTextToQuestionMarkRound() {
        // given
        let sut = viewController!
        sut.loadView()
        
        sut.round = nil
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(sut.roundLabel.text, "Round ???")
    }
    
    
    // MARK: - TableViewNumberOfRows
    
    func test_EndRoundPopoverViewController_WhenNumberOfRowsInSectionCalled_ShouldReturnPlayerCount() {
        // given
        let sut = viewController!
        sut.loadView()
        sut.viewDidLoad()
        
        let playerCount = Int.random(in: 1...10)
        let players = Array(repeating: Player(name: "", position: 0), count: playerCount)
        sut.players = players
        
        // when
        let count = sut.tableView(UITableView(), numberOfRowsInSection: 0)
        
        // then
        XCTAssertEqual(count, playerCount)
    }
    

    // MARK: - TableViewCellForRowAt
    
    func test_EndRoundPopoverViewController_WhenCellForRowAtCalled_ShouldReturnEndRoundPopoverTableViewCell() {
        // given
        let sut = viewController!
        sut.loadView()
        sut.viewDidLoad()
        
        // when
        let cell = sut.tableView(sut.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        
        // then
        XCTAssertTrue(cell is EndRoundPopoverTableViewCell)
    }

    func test_EndRoundPopoverViewController_WhenCellForRowAtCalledInRange_ShouldCallCellSetupViewPropertiesForPlayer() {
        // given
        let sut = viewController!
        
        let tableViewMock = UITableView()
        tableViewMock.register(EndRoundPopoverTableViewCellMock.self, forCellReuseIdentifier: "EndRoundPopoverTableViewCell")
        
        let player = Player(name: "", position: 0)
        sut.players = [player]
        
        // when
        let cell = sut.tableView(tableViewMock, cellForRowAt: IndexPath(row: 0, section: 0)) as? EndRoundPopoverTableViewCellMock
        
        // then
        XCTAssertEqual(cell?.setupViewPropertiesCalledCount, 1)
        XCTAssertEqual(cell?.setupViewPropertiesPlayer, player)
    }
    
    func test_EndRoundPopoverViewController_WhenCellForRowAtCalledOutOfRange_ShouldCallCellSetupErrorCell() {
        // given
        let sut = viewController!
        
        let tableViewMock = UITableView()
        tableViewMock.register(EndRoundPopoverTableViewCellMock.self, forCellReuseIdentifier: "EndRoundPopoverTableViewCell")
        
        sut.players = []
        
        // when
        let cell = sut.tableView(tableViewMock, cellForRowAt: IndexPath(row: 0, section: 0)) as? EndRoundPopoverTableViewCellMock
        
        // then
        XCTAssertEqual(cell?.setupErrorCellCalledCount, 1)
    }
    
    func test_EndRoundPopoverViewController_WhenCellForRowAtCalled_ShouldSetCellsTextFieldDidChangeHandlerToChangeCorrectPlayersScore() {
        // given
        let sut = viewController!
        
        let tableViewMock = UITableView()
        tableViewMock.register(EndRoundPopoverTableViewCellMock.self, forCellReuseIdentifier: "EndRoundPopoverTableViewCell")
        let startingScore = Int.random(in: 1...1000)
        let scoreChange = Int.random(in: 1...1000)
        
        let playerCount = Int.random(in: 2...5)
        sut.players = Array(repeating: Player(name: "", position: 0, score: startingScore), count: playerCount)
        
        let randomPlayer = Int.random(in: 0...playerCount-1)
        
        // when
        let cell = sut.tableView(tableViewMock, cellForRowAt: IndexPath(row: randomPlayer, section: 0)) as? EndRoundPopoverTableViewCellMock
        cell?.textFieldDidChangeHandler?(scoreChange)
        
        // then
        XCTAssertEqual(sut.players?[randomPlayer].score, startingScore + scoreChange)
    }
}
