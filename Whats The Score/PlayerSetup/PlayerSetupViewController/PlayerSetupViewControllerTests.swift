//
//  PlayerSetupViewControllerTests.swift
//  What's The Score Tests
//
//  Created by Curt McCune on 1/2/24.
//

import XCTest
@testable import Whats_The_Score

final class PlayerSetupViewControllerTests: XCTestCase {

    var viewController: PlayerSetupViewController!

    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "PlayerSetupViewController") as? PlayerSetupViewController else {
            fatalError("PlayerSetupViewController wasn't found")
        }
        self.viewController = viewController
    }
    
    override func tearDown() {
        viewController = nil
    }
    
    
    // MARK: - Initialization
    
    func getBasicViewModel() -> PlayerSetupViewModel {
        return PlayerSetupViewModel()
    }
    
    func test_PlayerSetupViewController_WhenLoaded_ShouldHaveNonNilOutlets() {
        // given
        let sut = viewController!
        
        // when
        viewController.loadView()
        
        // then
        XCTAssertNotNil(sut.titleLabel)
        XCTAssertNotNil(sut.randomizeButton)
        XCTAssertNotNil(sut.playerTableView)
        XCTAssertNotNil(sut.positionTableView)
        XCTAssertNotNil(sut.tapToAddPlayerButton)
    }
    
    func test_PlayerSetupViewController_WhenViewDidLoadCalled_ShouldSetPlayerTableViewDelegateAndDataSource() {
        // given
        let sut = viewController!
        sut.viewModel = getBasicViewModel()

        // when
        sut.loadView()
        sut.viewDidLoad()
        
        // then
        XCTAssertTrue(sut.playerTableView.delegate is PlayerSetupPlayerTableViewDelegate)
        XCTAssertTrue(sut.playerTableView.dataSource is PlayerSetupPlayerTableViewDelegate)
    }
    
    func test_PlayerSetupViewController_WhenViewDidLoadCalled_ShouldSetPositionTableViewDelegateAndDataSource() {
        // given
        let sut = viewController!
        sut.viewModel = getBasicViewModel()

        // when
        sut.loadView()
        sut.viewDidLoad()
        
        // then
        XCTAssertTrue(sut.positionTableView.delegate is PlayerSetupPositionTableViewDelegate)
        XCTAssertTrue(sut.positionTableView.dataSource is PlayerSetupPositionTableViewDelegate)
    }
    
    func test_PlayerSetupViewController_WhenViewDidLoadCalled_ShouldSetSelfAsViewModelsDelegate() {
        // given
        let sut = viewController!
        sut.viewModel = getBasicViewModel()
        
        // when
        sut.loadView()
        sut.viewDidLoad()
        
        // then
        XCTAssertTrue(sut.viewModel?.delegate is PlayerSetupViewController)
    }
    
    func test_PlayerSetupViewController_WhenViewDidLoadCalled_ShouldRegisterNibsForPositionTableView() {
        // given
        let sut = viewController!
        let tableViewDelegateMock = TableViewDelegateMock(cellIdentifier: "PlayerSetupPositionTableViewCell")
        sut.loadView()
        sut.positionTableView.dataSource = tableViewDelegateMock
        sut.positionTableView.delegate = tableViewDelegateMock
        
        // when
        sut.viewDidLoad()
        let cell = tableViewDelegateMock.tableView(sut.positionTableView, cellForRowAt: IndexPath(row: 0, section: 0))
        
        // then
        XCTAssertTrue(cell is PlayerSetupPositionTableViewCell)
        
    }
    
    func test_PlayerSetupViewController_WhenViewDidLoadCalled_ShouldRegisterNibsForPlayerTableView() {
        // given
        let sut = viewController!
        let tableViewDelegateMock = TableViewDelegateMock(cellIdentifier: "PlayerSetupPlayerTableViewCell")
        sut.loadView()
        sut.positionTableView.dataSource = tableViewDelegateMock
        sut.positionTableView.delegate = tableViewDelegateMock
        
        // when
        sut.viewDidLoad()
        let cell = tableViewDelegateMock.tableView(sut.playerTableView, cellForRowAt: IndexPath(row: 0, section: 0))
        
        // then
        XCTAssertTrue(cell is PlayerSetupPlayerTableViewCell)
    }
    
    func test_PlayerSetupViewController_WhenViewDidLoadCalled_ShouldSetStartTabBarButtonAsRightNavBarItem() {
        // given
        let sut = viewController!
        
        // when
        sut.loadView()
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(sut.navigationItem.rightBarButtonItem, sut.startBarButton)
    }
    
    func test_PlayerSetupViewController_WhenViewDidLoadCalled_ShouldSetPlayerTableViewAsItsOwnDragDropDelegate() {
        // given
        let sut = viewController!
        sut.viewModel = PlayerSetupViewModelMock()
        
        // when
        sut.loadView()
        sut.viewDidLoad()
        
        // then
        XCTAssertTrue(sut.playerTableView.dragDelegate === sut.playerTableView)
        XCTAssertTrue(sut.playerTableView.dropDelegate === sut.playerTableView)
    }
    
    
    // MARK: - Other Tests
    
    func test_PlayerSetupViewController_WhenTapToAddPlayerButtonTappedCalled_ShouldCallViewModelAddPlayer() {
        
        // given
        let sut = viewController!
        let viewModelMock = PlayerSetupViewModelMock()
        sut.viewModel = viewModelMock
        
        // when
        sut.tapToAddPlayerButtonTapped(0)
        
        // then
        XCTAssertEqual(viewModelMock.addPlayerCalledCount, 1)
    }
    
    func test_PlayerSetupViewController_WhenRandomizeButtonTapped_ShouldCallViewModelRandomizeFuntion() {
        // given
        let sut = viewController!
        let viewModelMock = PlayerSetupViewModelMock()
        sut.viewModel = viewModelMock
        
        // when
        sut.randomizeButtonTapped(0)
        
        // then
        XCTAssertEqual(viewModelMock.randomizePlayersCalledCount, 1)
    }
    
    // MARK: - StartButtonTappedCalled
    
    func test_PlayerSetupViewController_WhenStartBarButtonActionTriggered_ShouldCallStartBarButtonTapped() {
        class PlayerSetupViewControllerStartBarButtonTappedMock: PlayerSetupViewController {
            var startBarButtonTappedCalledCount = 0
            override func startBarButtonTapped() {
                startBarButtonTappedCalledCount += 1
            }
        }
        
        // given
        let sut = PlayerSetupViewControllerStartBarButtonTappedMock()
        
        // when
        guard let action = sut.startBarButton.action else {
            XCTFail("This button should have an action")
            return
        }
        UIApplication.shared.sendAction(action, to: sut.startBarButton.target, from: sut, for: nil)
        
        // then
        XCTAssertEqual(sut.startBarButtonTappedCalledCount, 1)
    }
    
    func test_PlayerSetupViewController_WhenStartBarButtonTappedCalled_ShouldCallViewModelPlayersSetup() {
        // given
        let viewModel = PlayerSetupViewModelMock()
        let sut = viewController!
        
        sut.viewModel = viewModel
        
        // when
        sut.startBarButtonTapped()
        
        // then
        XCTAssertEqual(viewModel.playersSetupCalledCount, 1)
    }
}
