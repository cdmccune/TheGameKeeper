//
//  ScoreboardViewControllerTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 1/19/24.
//

import XCTest
@testable import Whats_The_Score

final class ScoreboardViewControllerTests: XCTestCase {
    
    // MARK: - Setup
    
    var viewController: ScoreboardViewController!

    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "ScoreboardViewController") as? ScoreboardViewController else {
            fatalError("ScoreboardViewController wasn't found")
        }
        self.viewController = viewController
    }
    
    override func tearDown() {
        viewController = nil
    }
    
    
    // MARK: - ViewDidLoad
    
    func test_ScoreboardViewController_WhenViewDidLoadCalled_ShouldSetSelfAsViewModelsDelegate() {
        // given
        let sut = viewController!
        let viewModelMock = ScoreboardViewModelMock(game: GameMock())
        sut.viewModel = viewModelMock
        
        // when
        sut.loadView()
        sut.viewDidLoad()
        
        // then
        XCTAssertTrue(viewModelMock.delegate is ScoreboardViewController)
    }
    
    func test_ScoreboardViewController_WhenViewDidLoad_ShouldSetTableViewDelegateAndDatasource() {
        // given
        let sut = viewController!
        let viewModelMock = ScoreboardViewModelMock(game: GameMock())
        sut.viewModel = viewModelMock
        
        // when
        sut.loadView()
        sut.viewDidLoad()
        
        // then
        XCTAssertTrue(sut.tableView.delegate is ScoreboardTableViewDelegateDatasource)
        XCTAssertTrue(sut.tableView.dataSource is ScoreboardTableViewDelegateDatasource)
    }
    
    func test_ScoreboardViewController_WhenViewDidLoadCalled_ShouldRegisterScoreboardTableViewCellInTableView() {
        // given
        let sut = viewController!
        let viewModelMock = ScoreboardViewModelMock(game: GameMock())
        sut.viewModel = viewModelMock
        
        
        // when
        sut.loadView()
        sut.viewDidLoad()
        
        // then
        let cell = sut.tableView.dequeueReusableCell(withIdentifier: "ScoreboardTableViewCell")
        
        XCTAssertTrue(cell is ScoreboardTableViewCell)
    }
    
    
    // MARK: - Binding
    
    class ScoreboardViewControllerPresentMock: ScoreboardViewController {
        var presentCalledCount = 0
        var viewControllerPresented: UIViewController?
        override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
            presentCalledCount += 1
            self.viewControllerPresented = viewControllerToPresent
        }
    }
    
    func test_ScoreboardViewController_WhenBindingsSetAndPlayerToEditScoreSetNil_ShouldNotPresentPlayerScoreEditorPopover() {
        // given
        let sut = ScoreboardViewControllerPresentMock()
        let viewModelMock = ScoreboardViewModelMock()
        sut.viewModel = viewModelMock
        
        let tableView = UITableView()
        sut.tableView = tableView
        
        // when
        sut.viewDidLoad()
        viewModelMock.playerToEditScore.value = nil
        
        // then
        XCTAssertEqual(sut.presentCalledCount, 0)
        XCTAssertNil(sut.viewControllerPresented)
    }
    
    func test_ScoreboardViewController_WhenBindingsSetAndPlayerToEditScoreSetNotNil_ShouldPresentPlayerScoreEditorPopover() {
        
        // given
        let sut = ScoreboardViewControllerPresentMock()
        let viewModelMock = ScoreboardViewModelMock()
        sut.viewModel = viewModelMock
        
        let tableView = UITableView()
        sut.tableView = tableView
        
        // when
        sut.viewDidLoad()
        viewModelMock.playerToEditScore.value = Player(name: "", position: 0)
        
        // then
        XCTAssertEqual(sut.presentCalledCount, 1)
        XCTAssertTrue(sut.viewControllerPresented is ScoreboardPlayerEditScorePopoverViewController)
    }
    
    func test_ScoreboardViewController_WhenBindingsSetAndPlayerToEditScoreSetNotNil_ShouldCallSetupPopoverCenteredWithCorrectParameters() {
        
        // given
        let sut = ScoreboardViewController()
        let viewModelMock = ScoreboardViewModelMock()
        sut.viewModel = viewModelMock
        
        let tableView = UITableView()
        sut.tableView = tableView
        
        let defaultPopoverPresenterMock = DefaultPopoverPresenterMock()
        sut.defaultPopoverPresenter = defaultPopoverPresenterMock
        
        // when
        sut.viewDidLoad()
        viewModelMock.playerToEditScore.value = Player(name: "", position: 0)
        
        // then
        XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredCalledCount, 1)
        XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredWidth, 300)
        XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredHeight, 200)
        XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredView, sut.view)
        XCTAssertTrue(defaultPopoverPresenterMock.setupPopoverCenteredPopoverVC is ScoreboardPlayerEditScorePopoverViewController)
    }
    
    
    func test_ScoreboardViewController_WhenBindingsSetAndPlayerToEditScoreSetNotNil_ShouldSetPlayerScoreEditorPopoverPlayerAndDelegateToViewModel() {
        // given
        let sut = ScoreboardViewControllerPresentMock()
        let viewModelMock = ScoreboardViewModelMock()
        sut.viewModel = viewModelMock
        
        let tableView = UITableView()
        sut.tableView = tableView
        
        let playerName = UUID().uuidString
        let player = Player(name: playerName, position: 0)
        
        // when
        sut.viewDidLoad()
        viewModelMock.playerToEditScore.value = player
        
        // then
        let playerScoreEditorVC = sut.viewControllerPresented as? ScoreboardPlayerEditScorePopoverViewController
        XCTAssertEqual(playerScoreEditorVC?.player, player)
        XCTAssertTrue(playerScoreEditorVC?.delegate is ScoreboardViewModelMock)
    }
    
    
    // MARK: - IBActions
    
    func test_ScoreboardViewController_WhenEndRoundButtonTappedCalled_ShouldCallViewModelEndCurrentRound() {
        // given
        let sut = viewController!
        let viewModelMock = ScoreboardViewModelMock(game: GameMock())
        sut.viewModel = viewModelMock
        
        // when
        sut.endRoundButtonTapped(0)
        
        // then
        XCTAssertEqual(viewModelMock.endCurrentRoundCalledCount, 1)
    }
    
    func test_ScoreboardViewController_WhenEndGameButtonTapped_ShouldCallViewModelEndGame() {
        // given
        let sut = viewController!
        let viewModelMock = ScoreboardViewModelMock(game: GameMock())
        sut.viewModel = viewModelMock
        
        // when
        sut.endGameButtonTapped(0)
        
        // then
        XCTAssertEqual(viewModelMock.endGameCalledCount, 1)
    }
    
    
    // MARK: - Bind View To View Model
    
    func test_ScoreboardViewController_WhenBindViewModelToViewCalled_ShouldCallDispatchAsync() {
        // given
        // given
        let sut = viewController!
        
        let gameMock = GameMock()
        let viewModelMock = ScoreboardViewModelMock(game: gameMock)
        sut.viewModel = viewModelMock
        let dispatchQueueMock = DispatchQueueMainMock()
        
        // when
        sut.loadView()
        sut.bindViewToViewModel(dispatchQueue: dispatchQueueMock)
        
        // then
        XCTAssertEqual(dispatchQueueMock.asyncCalledCount, 1)
    }

    func test_ScoreboardViewController_WhenViewModelGameHasRoundGameTypeAndBindViewModelToViewCalled_ShouldShowRoundLabel() {
        // given
        let sut = viewController!
        
        let gameMock = GameMock()
        gameMock.gameType = .round
        let viewModelMock = ScoreboardViewModelMock(game: gameMock)
        sut.viewModel = viewModelMock
        
        // when
        sut.loadView()
        sut.bindViewToViewModel(dispatchQueue: DispatchQueueMainMock())
        
        // then
        XCTAssertFalse(sut.roundLabel.isHidden)
    }
    
    func test_ScoreboardViewController_WhenViewModelGameHasNotRoundGameTypeAndBindViewModelToViewCalled_ShouldHideRoundLabel() {
        // given
        let sut = viewController!
        
        let gameMock = GameMock()
        gameMock.gameType = .basic
        let viewModelMock = ScoreboardViewModelMock(game: gameMock)
        sut.viewModel = viewModelMock
        
        // when
        sut.loadView()
        sut.bindViewToViewModel(dispatchQueue: DispatchQueueMainMock())
        
        // then
        XCTAssertTrue(sut.roundLabel.isHidden)
    }
    
    func test_ScoreboardViewController_WhenViewModelGameRoundTypeBindViewModelToViewCalled_ShouldSetRoundLabelTextToCurrentRound() {
        // given
        let sut = viewController!
        
        let currentRound = Int.random(in: 1...10)
        let gameMock = GameMock()
        gameMock.gameType = .round
        gameMock.currentRound = currentRound
        let viewModelMock = ScoreboardViewModelMock(game: gameMock)
        sut.viewModel = viewModelMock
        
        // when
        sut.loadView()
        sut.bindViewToViewModel(dispatchQueue: DispatchQueueMainMock())
        
        // then
        XCTAssertEqual(sut.roundLabel.text, "Round \(currentRound)")
    }
    
    func test_ScoreboardViewController_WhenViewModelGameTypeBasicBindViewModelToViewCalled_ShouldHideFilterButtonsStackView() {
        // given
        let sut = viewController!
        
        let currentRound = Int.random(in: 1...10)
        let gameMock = GameMock()
        gameMock.gameType = .basic
        let viewModelMock = ScoreboardViewModelMock(game: gameMock)
        sut.viewModel = viewModelMock
        
        // when
        sut.loadView()
        sut.bindViewToViewModel(dispatchQueue: DispatchQueueMainMock())
        
        // then
        XCTAssertTrue(sut.filterButtonStackView.isHidden)
    }
    
    func test_ScoreboardViewController_WhenViewModelBindViewModelToViewCalled_ShouldCallReloadDataOnTheTableView() {
        
        class UITableViewReloadDataMock: UITableView {
            var reloadDataCalledCount = 0
            override func reloadData() {
                reloadDataCalledCount += 1
            }
        }
        
        // given
        let sut = viewController!
        sut.loadView()
        
        let tableView = UITableViewReloadDataMock()
        sut.tableView = tableView
        sut.viewModel = ScoreboardViewModelMock()
        
        // when
        sut.bindViewToViewModel(dispatchQueue: DispatchQueueMainMock())
        
        // then
        XCTAssertEqual(tableView.reloadDataCalledCount, 1)
    }
    
}
