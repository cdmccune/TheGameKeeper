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
    
    
    // MARK: - Helper Functions
    
    func getPresentMockWithRightViewsPresent() -> GameHistoryViewControllerPresentMock {
        let viewController = GameHistoryViewControllerPresentMock()
        
        let tableView = UITableView()
        viewController.tableView = tableView
        
        let view = UIView()
        viewController.view = view
        
        views = [tableView, view]
        
        return viewController
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
    
    func test_GameHistoryViewController_WhendefaultPopoverPresenterLoaded_ShouldBeDefaultPopoverPresenterClass() {
        // given
        // when
        let sut = viewController!
        
        
        // then
        XCTAssertTrue(sut.defaultPopoverPresenter is DefaultPopoverPresenter)
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
    
    func test_GameHistoryViewController_WhenViewDidLoadCalled_ShouldCallSetBindings() {
        
        class GameHistoryViewControllerSetBindingsMock: GameHistoryViewController {
            var setBindingsCalledCount = 0
            override func setBindings() {
                setBindingsCalledCount += 1
            }
        }
        
        
        // given
        let sut = GameHistoryViewControllerSetBindingsMock()
        sut.viewModel = GameHistoryViewModelMock()
        let tableView = UITableView()
        sut.tableView = tableView
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(sut.setBindingsCalledCount, 1)
    }
    
    
    // MARK: - ScoreChangeToEdit
    
    func test_GameHistoryViewController_WhenSetBindingsCalledAndViewModelScoreChangeToEditChangeSetNil_ShouldNotPresentAnything() {
        // given
        let sut = getPresentMockWithRightViewsPresent()
        
        let viewModelMock = GameHistoryViewModelMock()
        sut.viewModel = viewModelMock
        
        // when
        sut.setBindings()
        viewModelMock.scoreChangeToEdit.value = nil
        
        // then
        XCTAssertEqual(sut.presentCalledCount, 0)
    }
    
    func test_GameHistoryViewController_WhenSetBindingsCalledAndViewModelScoreChangeToEditChangeSetNotNil_ShouldPresentEditPlayerScorePopover() {
        // given
        let sut = getPresentMockWithRightViewsPresent()
        
        let viewModelMock = GameHistoryViewModelMock()
        sut.viewModel = viewModelMock
        
        let scoreChange = ScoreChange(player: Player.getBasicPlayer(), scoreChange: 0)
        
        // when
        sut.setBindings()
        viewModelMock.scoreChangeToEdit.value = scoreChange
        
        // then
        XCTAssertEqual(sut.presentCalledCount, 1)
        XCTAssertTrue(sut.presentViewController is ScoreboardPlayerEditScorePopoverViewController)
    }
    
    func test_GameHistoryViewController_WhenSetBindingsCalledAndViewModelScoreChangeToEditChangeSetNotNil_ShouldCallSetupPopoverCenteredWithCorrectParameters() {
        
        // given
        let sut = viewController!
        let viewModelMock = GameHistoryViewModelMock()
        sut.viewModel = viewModelMock
        
        let defaultPopoverPresenterMock = DefaultPopoverPresenterMock()
        sut.defaultPopoverPresenter = defaultPopoverPresenterMock
        
        let scoreChange = ScoreChange(player: Player.getBasicPlayer(), scoreChange: 0)
        
        // when
        sut.loadView()
        sut.setBindings()
        viewModelMock.scoreChangeToEdit.value = scoreChange
        
        // then
        XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredCalledCount, 1)
        XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredWidth, 300)
        XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredHeight, 200)
        XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredView, sut.view)
        XCTAssertTrue(defaultPopoverPresenterMock.setupPopoverCenteredPopoverVC is ScoreboardPlayerEditScorePopoverViewController)
        XCTAssertTrue(defaultPopoverPresenterMock.setupPopoverCenteredTapToExit ?? false)
    }
    
    func test_GameHistoryViewController_WhenSetBindingsCalledAndViewModelScoreChangeToEditChangeSetNotNil_ShouldSetViewModelAsDelegateAndScoreChange() {
        // given
        let sut = getPresentMockWithRightViewsPresent()
        
        let viewModelMock = GameHistoryViewModelMock()
        sut.viewModel = viewModelMock
        
        let scoreChange = ScoreChange(player: Player.getBasicPlayer(), scoreChange: 0)
        
        // when
        sut.setBindings()
        viewModelMock.scoreChangeToEdit.value = scoreChange
        
        // then
        let editPlayerVC = sut.presentViewController as? ScoreboardPlayerEditScorePopoverViewController
        XCTAssertTrue(editPlayerVC?.delegate === viewModelMock)
        XCTAssertEqual(editPlayerVC?.scoreChange, scoreChange)
    }
    
    
    // MARK: - TableViewIndexToRefresh
    
    func test_GameHistoryViewController_WhenSetBindingsCalledAndViewModelTableViewIndexToRefresh_ShouldCallTableViewReloadRowsForThatIndex() {
        // given
        let sut = viewController!
        sut.loadView()
        
        let viewModel = GameHistoryViewModelMock()
        sut.viewModel = viewModel
        
        let tableViewMock = UITableViewReloadRowsMock()
        sut.tableView = tableViewMock
        
        let indexToReload = Int.random(in: 1...1000)
        
        // when
        sut.setBindings()
        viewModel.tableViewIndexToRefresh.value = indexToReload
        
        // then
        XCTAssertEqual(tableViewMock.reloadRowsCalledCount, 1)
        XCTAssertEqual(tableViewMock.reloadRowsIndexPathArray, [IndexPath(row: indexToReload, section: 0)])
    }

    
    // MARK: - Classes
    
    class GameHistoryViewControllerPresentMock: GameHistoryViewController {
        var presentViewController: UIViewController?
        var presentCalledCount = 0
        override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
            presentViewController = viewControllerToPresent
            presentCalledCount += 1
        }
    }
}
