//
//  GameHistoryViewControllerTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 3/11/24.
//

import XCTest
@testable import Whats_The_Score

final class GameHistoryViewControllerTests: XCTestCase {
    
    // MARK: - Setup
    
    var viewController: GameHistoryViewController!
    var views: [UIView]?

    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "GameHistoryViewController") as? GameHistoryViewController else {
            fatalError("GameHistoryViewController wasn't found")
        }
        self.viewController = viewController
    }
    
    override func tearDown() {
        viewController = nil
    }
    
    
    // MARK: - Initialization
    
    func test_GameHistoryViewController_WhenViewLoaded_ShouldHaveNonNilOutlets() {
        // given
        let sut = viewController!
        
        // when
        sut.loadView()
        
        // then
        XCTAssertNotNil(sut.tableView)
    }
    
    
    // MARK: - ViewDidLoad
    
    func test_GameHistoryViewController_WhenViewDidLoadCalled_ShouldSetTableViewDelegateDatasourceToGameHistoryTableViewDelegate() {
        // given
        let sut = viewController!
        sut.viewModel = GameHistoryViewModelMock()
        
        // when
        sut.loadView()
        sut.viewDidLoad()
        
        // then
        XCTAssertTrue(sut.tableView.delegate is GameHistoryTableViewDelegate)
        XCTAssertTrue(sut.tableView.dataSource is GameHistoryTableViewDelegate)
    }
    
    func test_GameHistoryViewController_WhenViewDidLoadCalled_ShouldSetTableViewDelegatesViewModelAsGameHistoryViewModel() {
        // given
        let sut = viewController!
        let viewModel = GameHistoryViewModelMock()
        sut.viewModel = viewModel
        
        // when
        sut.loadView()
        sut.viewDidLoad()
        
        // then
        let tableViewDelegate = sut.tableView.delegate as? GameHistoryTableViewDelegate
        XCTAssertTrue((tableViewDelegate?.viewModel as? GameHistoryViewModelMock) === viewModel)
    }
    
    func test_GameHistoryViewController_WhenViewDidLoadCalled_ShouldRegisterScoreChangeAndEndRoundNibsOnTableView() {
        // given
        let sut = viewController!
        sut.loadView()
        sut.viewModel = GameHistoryViewModelMock()
        
        let tableViewMock = UITableViewRegisterMock()
        sut.tableView = tableViewMock
        
        let scoreChangeIdentifierNibName = "GameHistoryScoreChangeTableViewCell"
        let endRoundIdentifierNibName = "GameHistoryEndRoundTableViewCell"
        let errorIdentifierNibName = "GameHistoryErrorTableViewCell"
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertTrue(tableViewMock.registerCellReuseIdentifiers.contains(scoreChangeIdentifierNibName))
        XCTAssertTrue(tableViewMock.registerCellReuseIdentifiers.contains(endRoundIdentifierNibName))
        XCTAssertTrue(tableViewMock.registerCellReuseIdentifiers.contains(errorIdentifierNibName))
    }
}
