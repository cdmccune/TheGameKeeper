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
    
    func test_ScoreboardViewController_WhenEndRoundPopoverHeightHelperCreated_ShouldHavePlayerHeightOf45AndSeparatorOf3() {
        // given
        let sut = viewController!
        
        // when
        let endRoundPopoverHeightHelper = sut.endRoundPopoverHeightHelper
        
        // then
        XCTAssertEqual(endRoundPopoverHeightHelper.playerViewHeight, 45)
        XCTAssertEqual(endRoundPopoverHeightHelper.playerSeperatorHeight, 3)
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
    
    
    // MARK: - EndRoundToEdit
    
    func test_GameHistoryViewController_WhenSetBindingsCalledAndViewModelEndRoundToEditSetNil_ShouldNotPresentAnything() {
        // given
        let sut = getPresentMockWithRightViewsPresent()
        
        let viewModel = GameHistoryViewModelMock()
        sut.viewModel = viewModel
        
        // when
        viewModel.endRoundToEdit.value = nil
        
        // then
        XCTAssertEqual(sut.presentCalledCount, 0)
    }
    
    func test_GameHistoryViewController_WhenSetBindingsCalledAndAndViewModelEndRoundToEditSetNotNil_ShouldPresentEndRoundPopover() {
        // given
        let sut = getPresentMockWithRightViewsPresent()
        
        let viewModelMock = GameHistoryViewModelMock()
        sut.viewModel = viewModelMock
        
        // when
        sut.setBindings()
        viewModelMock.endRoundToEdit.value = EndRound.getBlankEndRound()
        
        // then
        XCTAssertEqual(sut.presentCalledCount, 1)
        XCTAssertTrue(sut.presentViewController is EndRoundPopoverViewController)
    }
    
    func test_GameHistoryViewController_WhenSetBindingsCalledAndAndViewModelEndRoundToEditSetNotNil_ShouldCallSetupPopoverCenteredWithCorrectParameters() {
        
        // given
        let sut = getPresentMockWithRightViewsPresent()
        
        let defaultPopoverPresenterMock = DefaultPopoverPresenterMock()
        sut.defaultPopoverPresenter = defaultPopoverPresenterMock
        let viewModelMock = GameHistoryViewModelMock()
        sut.viewModel = viewModelMock
        
        
        // when
        sut.setBindings()
        viewModelMock.endRoundToEdit.value = EndRound.getBlankEndRound()
        
        // then
        XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredCalledCount, 1)
        XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredWidth, 300)
        XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredView, sut.view)
        XCTAssertTrue(defaultPopoverPresenterMock.setupPopoverCenteredPopoverVC is EndRoundPopoverViewController)
        XCTAssertTrue(defaultPopoverPresenterMock.setupPopoverCenteredTapToExit ?? false)
    }    
    
    func test_GameHistoryViewController_WhenSetBindingsCalledAndAndViewModelEndRoundToEditSetNotNil_ShouldCallEndRoundPopoverHeightHelperGetPopoverHeightForWithCorrectParameters() {
        // given
        let sut = getPresentMockWithRightViewsPresent()
        
        let endRoundPopoverHeightHelperMock = EndRoundPopoverHeightHelperMock()
        sut.endRoundPopoverHeightHelper = endRoundPopoverHeightHelperMock
        
        let rectHeight = CGFloat.random(in: 0...100)
        let viewMock = UIViewSafeAreaLayoutFrameMock(safeAreaFrame: CGRect(x: 0, y: 0, width: 0, height: rectHeight))
        sut.view = viewMock
        
        let viewModelMock = GameHistoryViewModelMock()
        let playerCount = Int.random(in: 1...10)
        let endRound = EndRound.getEndRoundWith(numberOfPlayers: playerCount)
        sut.viewModel = viewModelMock
        
        // when
        sut.setBindings()
        viewModelMock.endRoundToEdit.value = endRound
        
        // then
        XCTAssertEqual(endRoundPopoverHeightHelperMock.getPopoverHeightForSafeAreaHeight, rectHeight)
        XCTAssertEqual(endRoundPopoverHeightHelperMock.getPopoverHeightForPlayerCount, playerCount)
        XCTAssertEqual(endRoundPopoverHeightHelperMock.getPopoverHeightForCalledCount, 1)
    }
    
    func test_GameHistoryViewController_WhenSetBindingsCalledAndAndViewModelEndRoundToEditSetNotNil_ShouldCallSetupPopoverCenteredWithHeightFromEndRoundPopoverHeightHelper() {
        // given
        let sut = getPresentMockWithRightViewsPresent()
        
        let heightToReturn = CGFloat.random(in: 0...10000)
        let endRoundPopoverHeightHelperMock = EndRoundPopoverHeightHelperMock()
        endRoundPopoverHeightHelperMock.heightToReturn = heightToReturn
        
        sut.endRoundPopoverHeightHelper = endRoundPopoverHeightHelperMock
        
        let defaultPopoverPresenterMock = DefaultPopoverPresenterMock()
        sut.defaultPopoverPresenter = defaultPopoverPresenterMock
        let viewModelMock = GameHistoryViewModelMock()
        sut.viewModel = viewModelMock
        
        // when
        sut.setBindings()
        viewModelMock.endRoundToEdit.value = EndRound.getBlankEndRound()
        
        // then
        XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredHeight, heightToReturn)
    }
    
    func test_GameHistoryViewController_WhenSetBindingsCalledAndAndViewModelEndRoundToEditSet_ShouldPresentEndRoundPopoverWithEndRound() {
        // given
        let sut = getPresentMockWithRightViewsPresent()
        sut.defaultPopoverPresenter = DefaultPopoverPresenterMock()
        
        let viewModelMock = GameHistoryViewModelMock()
        
        let currentRound = Int.random(in: 1...1000)
        viewModelMock.game.currentRound = currentRound
        
        sut.viewModel = viewModelMock
        
        let endRound = EndRound.getBlankEndRound()
        
        // when
        sut.setBindings()
        viewModelMock.endRoundToEdit.value = endRound
        
        // then
        let endRoundPopoverVC = sut.presentViewController as? EndRoundPopoverViewController
        
        XCTAssertEqual(endRoundPopoverVC?.endRound, endRound)
    }
    
    func test_GameHistoryViewController_WhenSetBindingsCalledAndAndViewModelEndRoundToEditSet_ShouldPresentEndRoundPopoverWithHeightHelperPlayerViewHeightAndPlayerSeperatorHeight() {
        // given
        let sut = getPresentMockWithRightViewsPresent()
        sut.defaultPopoverPresenter = DefaultPopoverPresenterMock()
        
        let playerViewHeight = Int.random(in: 1...1000)
        let playerSeperatorHeight = Int.random(in: 1...1000)
        sut.endRoundPopoverHeightHelper = EndRoundPopoverHeightHelper(playerViewHeight: playerViewHeight, playerSeperatorHeight: playerSeperatorHeight)
        
        let viewModelMock = GameHistoryViewModelMock()
        sut.viewModel = viewModelMock
        
        // when
        sut.setBindings()
        viewModelMock.endRoundToEdit.value = EndRound.getBlankEndRound()
        
        // then
        let endRoundPopoverVC = sut.presentViewController as? EndRoundPopoverViewController
        XCTAssertEqual(endRoundPopoverVC?.playerViewHeight, playerViewHeight)
        XCTAssertEqual(endRoundPopoverVC?.playerSeparatorHeight, playerSeperatorHeight)
    }
    
    func test_GameHistoryViewController_WhenSetBindingsCalledAndAndViewModelEndRoundToEditSet_ShouldViewModelAsEndRoundVCDelegate() {
        // given
        let sut = getPresentMockWithRightViewsPresent()
        let viewModelMock = GameHistoryViewModelMock()
        
        sut.viewModel = viewModelMock
        
        // when
        sut.setBindings()
        viewModelMock.endRoundToEdit.value = EndRound.getBlankEndRound()
        
        // then
        let endRoundPopoverVC = sut.presentViewController as? EndRoundPopoverViewController
        XCTAssertTrue(endRoundPopoverVC?.delegate is GameHistoryViewModelMock)
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
