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
    
    
    // MARK: - Properties
    
    func test_ScoreboardViewController_WhenResetBarButtonSet_ShouldHaveResetBarButtonCorrectTitleAndTarget() {
        // given
        let sut = viewController!
        
        // when
        let barButton = sut.resetBarButton
        
        // then
        XCTAssertEqual(barButton.title, "Reset")
        XCTAssertEqual(barButton.target as? ScoreboardViewController, sut)
    }
    
    func test_ScoreboardViewController_WhenResetBarButtonActionCalled_ShouldCallResetButtonTapped() {
        
        class ScoreboardViewControllerResetButtonTappedMock: ScoreboardViewController {
            var resetBarButtonCalledCount = 0
            override func resetButtonTapped() {
                resetBarButtonCalledCount += 1
            }
        }
        
        // given
        let sut = ScoreboardViewControllerResetButtonTappedMock()
        
        let tableView = UITableView()
        sut.tableView = tableView
        
        // when
        _ = sut.resetBarButton.target?.perform(sut.resetBarButton.action, with: sut.resetBarButton)
        
        // then
        XCTAssertEqual(sut.resetBarButtonCalledCount, 1)
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
        let viewModelMock = ScoreboardViewModelMock()
        sut.viewModel = viewModelMock
        
        
        // when
        sut.loadView()
        sut.viewDidLoad()
        
        // then
        let cell = sut.tableView.dequeueReusableCell(withIdentifier: "ScoreboardTableViewCell")
        
        XCTAssertTrue(cell is ScoreboardTableViewCell)
    }
    
    func test_ScoreboardViewController_WhenViewDidLoadCalled_ShouldSetNavigationItemRightBarButtonToResetBarButton() {
        // given
        let sut = viewController!
        let viewModelMock = ScoreboardViewModelMock()
        sut.viewModel = viewModelMock
        
        // when
        sut.loadView()
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(sut.navigationItem.rightBarButtonItem, sut.resetBarButton)
    }
    
    func test_ScoreboardViewController_WhenViewDidLoadCalled_ShouldSetScoreSortButtonAlphaTo1AndTurnOrderSortButtonAlphaToPoint5() {
        // given
        let sut = viewController!
        let viewModelMock = ScoreboardViewModelMock()
        sut.viewModel = viewModelMock
        
        // when
        sut.loadView()
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(sut.scoreSortButton.alpha, 1.0)
        XCTAssertEqual(sut.turnOrderSortButton.alpha, 0.5)
    }
    
    
    // MARK: - Binding PlayerToEditScore
    
    func test_ScoreboardViewController_WhenBindingsSetAndPlayerToEditScoreSetNil_ShouldNotPresentPlayerScoreEditorPopover() {
        // given
        let sut = ScoreboardViewControllerPresentMock()
        let viewModelMock = ScoreboardViewModelMock()
        sut.viewModel = viewModelMock
        
        let tableView = UITableView()
        sut.tableView = tableView
        let scoreButton = UIButton()
        sut.scoreSortButton = scoreButton
        let turnButton = UIButton()
        sut.turnOrderSortButton = turnButton
        
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
        let scoreButton = UIButton()
        sut.scoreSortButton = scoreButton
        let turnButton = UIButton()
        sut.turnOrderSortButton = turnButton
        
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
        let scoreButton = UIButton()
        sut.scoreSortButton = scoreButton
        let turnButton = UIButton()
        sut.turnOrderSortButton = turnButton
        
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
        let scoreButton = UIButton()
        sut.scoreSortButton = scoreButton
        let turnButton = UIButton()
        sut.turnOrderSortButton = turnButton
        
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
    
    
    // MARK: - Binding PlayerToEdit
    
    func getScoreboardViewControllerPresentMockWithNeccessaryViewsLoaded() -> ([UIView], ScoreboardViewControllerPresentMock) {
        let sut = ScoreboardViewControllerPresentMock()
        
        let tableView = UITableView()
        sut.tableView = tableView
        let scoreButton = UIButton()
        sut.scoreSortButton = scoreButton
        let turnButton = UIButton()
        sut.turnOrderSortButton = turnButton
        return ([tableView, scoreButton, turnButton], sut)
    }
    
    func test_ScoreboardViewController_WhenBindingsSetAndPlayerToEditSetNil_ShouldNotPresentEditPlayerPopover() {
        // given
        let (views, sut) = getScoreboardViewControllerPresentMockWithNeccessaryViewsLoaded()
        let viewModelMock = ScoreboardViewModelMock()
        sut.viewModel = viewModelMock
  
        // when
        sut.viewDidLoad()
        viewModelMock.playerToEdit.value = nil
        
        // then
        XCTAssertEqual(sut.presentCalledCount, 0)
        XCTAssertNil(sut.viewControllerPresented)
    }
    
    func test_ScoreboardViewController_WhenBindingsSetAndPlayerToEditSetNotNil_ShouldPresentEditPlayerPopover() {
        
        // given
        let (views, sut) = getScoreboardViewControllerPresentMockWithNeccessaryViewsLoaded()
        let viewModelMock = ScoreboardViewModelMock()
        sut.viewModel = viewModelMock
        
        // when
        sut.viewDidLoad()
        viewModelMock.playerToEdit.value = Player(name: "", position: 0)
        
        // then
        XCTAssertEqual(sut.presentCalledCount, 1)
        XCTAssertTrue(sut.viewControllerPresented is EditPlayerPopoverViewController)
    }
    
    func test_ScoreboardViewController_WhenBindingsSetAndPlayerToEditSetNotNil_ShouldCallSetupPopoverCenteredWithCorrectParameters() {
        
        // given
        let (views, sut) = getScoreboardViewControllerPresentMockWithNeccessaryViewsLoaded()
        let viewModelMock = ScoreboardViewModelMock()
        sut.viewModel = viewModelMock
        
        let defaultPopoverPresenterMock = DefaultPopoverPresenterMock()
        sut.defaultPopoverPresenter = defaultPopoverPresenterMock
        
        // when
        sut.viewDidLoad()
        viewModelMock.playerToEdit.value = Player(name: "", position: 0)
        
        // then
        XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredCalledCount, 1)
        XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredWidth, 300)
        XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredHeight, 180)
        XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredView, sut.view)
        XCTAssertTrue(defaultPopoverPresenterMock.setupPopoverCenteredPopoverVC is EditPlayerPopoverViewController)
    }
    
    
    func test_ScoreboardViewController_WhenBindingsSetAndPlayerToEditSetNotNil_ShouldSetEditPlayerPopoverPlayerAndDelegateToViewModel() {
        // given
        let (views, sut) = getScoreboardViewControllerPresentMockWithNeccessaryViewsLoaded()
        let viewModelMock = ScoreboardViewModelMock()
        sut.viewModel = viewModelMock
        
        let player = Player(name: "", position: 0)
        
        // when
        sut.viewDidLoad()
        viewModelMock.playerToEdit.value = player
        
        // then
        let playerEditorVC = sut.viewControllerPresented as? EditPlayerPopoverViewController
        XCTAssertEqual(playerEditorVC?.player, player)
        XCTAssertTrue(playerEditorVC?.delegate is ScoreboardViewModelMock)
    }
    
    
    // MARK: - Binding PlayerToDelete
    
    func test_ScoreboardViewController_WhenBindingsSetAndPlayerToDeleteSetNil_ShouldNotPresentAnything() {
        // given
        let (views, sut) = getScoreboardViewControllerPresentMockWithNeccessaryViewsLoaded()
        let viewModelMock = ScoreboardViewModelMock()
        sut.viewModel = viewModelMock
        
        // when
        sut.viewDidLoad()
        viewModelMock.playerToDelete.value = nil
        
        // then
        XCTAssertEqual(sut.presentCalledCount, 0)
    }
    
    func test_ScoreboardViewController_WhenBindingsSetAndPlayerToDeleteSetNotNil_ShouldPresentAlertWithCorrectTitle() {
        // given
        let (views, sut) = getScoreboardViewControllerPresentMockWithNeccessaryViewsLoaded()
        let viewModelMock = ScoreboardViewModelMock()
        sut.viewModel = viewModelMock
        
        // when
        sut.viewDidLoad()
        viewModelMock.playerToDelete.value = Player(name: "", position: 0)
        
        // then
        XCTAssertEqual(sut.presentCalledCount, 1)
        XCTAssertEqual((sut.viewControllerPresented as? UIAlertController)?.title, "Delete Player")
    }
    
    func test_ScoreboardViewController_WhenBindingsSetAndPlayerToDeleteSetNotNil_ShouldPresentAlertWithCorrectMessage() {
        // given
        let (views, sut) = getScoreboardViewControllerPresentMockWithNeccessaryViewsLoaded()
        let viewModelMock = ScoreboardViewModelMock()
        sut.viewModel = viewModelMock
        
        let playerName = UUID().uuidString
        let player = Player(name: playerName, position: 0)
        
        // when
        sut.viewDidLoad()
        viewModelMock.playerToDelete.value = player
        
        // then
        XCTAssertEqual(sut.presentCalledCount, 1)
        XCTAssertEqual((sut.viewControllerPresented as? UIAlertController)?.message, "Are you sure you want to remove \(playerName) from this game?")
    }
    
    func test_ScoreboardViewController_WhenBindingsSetAndPlayerToDeleteSetNotNil_ShouldPresentAlertWithFirstActionCancel() {
        // given
        let (views, sut) = getScoreboardViewControllerPresentMockWithNeccessaryViewsLoaded()
        let viewModelMock = ScoreboardViewModelMock()
        sut.viewModel = viewModelMock
        
        // when
        sut.viewDidLoad()
        viewModelMock.playerToDelete.value = Player(name: "", position: 0)
        
        // then
        let cancelAction = (sut.viewControllerPresented as? UIAlertController)?.actions.first
        XCTAssertNotNil(cancelAction)
        XCTAssertEqual(cancelAction?.title, "Cancel")
        XCTAssertEqual(cancelAction?.style, .cancel)
    }
    
    func test_ScoreboardViewController_WhenBindingsSetAndPlayerToDeleteSetNotNil_ShouldPresentAlertWithTwoActions() {
        // given
        let (views, sut) = getScoreboardViewControllerPresentMockWithNeccessaryViewsLoaded()
        let viewModelMock = ScoreboardViewModelMock()
        sut.viewModel = viewModelMock
        
        // when
        sut.viewDidLoad()
        viewModelMock.playerToDelete.value = Player(name: "", position: 0)
        
        // then
        let actions = (sut.viewControllerPresented as? UIAlertController)?.actions
        XCTAssertEqual(actions?.count, 2)
    }
    
    func test_ScoreboardViewController_WhenBindingsSetAndPlayerToDeleteSetNil_ShouldPresentAlertWithLastActionDelete() {
        // given
        let (views, sut) = getScoreboardViewControllerPresentMockWithNeccessaryViewsLoaded()
        let viewModelMock = ScoreboardViewModelMock()
        sut.viewModel = viewModelMock
        
        // when
        sut.viewDidLoad()
        viewModelMock.playerToDelete.value = Player(name: "", position: 0)
        
        // then
        let resetAction = (sut.viewControllerPresented as? UIAlertController)?.actions.last
        XCTAssertNotNil(resetAction)
        XCTAssertEqual(resetAction?.title, "Delete")
        XCTAssertEqual(resetAction?.style, .destructive)
    }
    
    func test_ScoreboardViewController_WhenBindingsSetAndPlayerToDeleteSetNil_ShouldSetDeleteActionHandlerToBeViewModelDeletePlayer() {
        // given
        let (views, sut) = getScoreboardViewControllerPresentMockWithNeccessaryViewsLoaded()
        let viewModelMock = ScoreboardViewModelMock()
        sut.viewModel = viewModelMock
        
        let player = Player(name: "", position: 0)
        
        // when
        sut.viewDidLoad()
        viewModelMock.playerToDelete.value = player
        let deleteAction = (sut.viewControllerPresented as? UIAlertController)?.actions.last as? TestableUIAlertAction
      
        deleteAction?.handler!(UIAlertAction(title: "", style: .destructive))
        
        // then
        XCTAssertEqual(viewModelMock.deletePlayerCalledCount, 1)
        XCTAssertEqual(viewModelMock.deletePlayerPlayer, player)
    }

    
    // MARK: - Binding SortPreference
    
    func test_ScoreboardViewController_WhenBindingsSetAndSortPreferenceSet_ShouldCallTableViewReloadData() {
        // given
        let sut = viewController!
        sut.loadView()
        let viewModelMock = ScoreboardViewModelMock()
        sut.viewModel = viewModelMock
        
        let tableViewMock = UITableViewReloadDataMock()
        sut.tableView = tableViewMock
        
        // when
        sut.viewDidLoad()
        viewModelMock.sortPreference.value = .score
        
        // then
        XCTAssertEqual(tableViewMock.reloadDataCalledCount, 1)
    }
    
    func test_ScoreboardViewController_WhenBindingsSetAndSortPreferenceSetPosition_SetScoreSortPreferenceButtonAlphaToPoint5AndTurnTo1() {
        // given
        let sut = viewController!
        sut.loadView()
        let viewModelMock = ScoreboardViewModelMock()
        sut.viewModel = viewModelMock
    
        
        // when
        sut.viewDidLoad()
        viewModelMock.sortPreference.value = .position
        
        // then
        XCTAssertEqual(sut.scoreSortButton.alpha, 0.5, accuracy: 0.01)
        XCTAssertEqual(sut.turnOrderSortButton.alpha, 1)
    }
    
    func test_ScoreboardViewController_WhenBindingsSetAndSortPreferenceSetScore_SetScoreSortPreferenceButtonAlphaTo1AndTurnToPoint5() {
        // given
        let sut = viewController!
        sut.loadView()
        let viewModelMock = ScoreboardViewModelMock()
        sut.viewModel = viewModelMock
    
        
        // when
        sut.viewDidLoad()
        viewModelMock.sortPreference.value = .score
        
        // then
        XCTAssertEqual(sut.scoreSortButton.alpha, 1)
        XCTAssertEqual(sut.turnOrderSortButton.alpha, 0.5, accuracy: 0.01)
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
    
    func test_ScoreboardViewController_WhenAddPlayerTapped_ShouldCallViewModelAddPlayer() {
        // given
        let sut = viewController!
        let viewModelMock = ScoreboardViewModelMock(game: GameMock())
        sut.viewModel = viewModelMock
        
        // when
        sut.addPlayerTapped(0)
        
        // then
        XCTAssertEqual(viewModelMock.addPlayerCalledCount, 1)
    }
    
    func test_ScoreboardViewController_WhenScoreSortButtonTappedCalled_ShouldSetViewModelSortPreferenceToScore() {
        // given
        let sut = viewController!
        let viewModelMock = ScoreboardViewModelMock()
        sut.viewModel = viewModelMock
        sut.viewModel?.sortPreference.value = .position
        
        // when
        sut.scoreSortButtonTapped(0)
        
        // then
        XCTAssertEqual(sut.viewModel?.sortPreference.value, .score)
    }
    
    func test_ScoreboardViewController_WhenTurnOrderSortButtonTappedCalled_ShouldSetViewModelSortPreferenceToPosition() {
        // given
        let sut = viewController!
        let viewModelMock = ScoreboardViewModelMock()
        sut.viewModel = viewModelMock
        sut.viewModel?.sortPreference.value = .score
        
        // when
        sut.turnOrderSortButtonTapped(0)
        
        // then
        XCTAssertEqual(sut.viewModel?.sortPreference.value, .position)
    }
    
    
    // MARK: - resetButtonTapped
    
    func test_ScoreboardViewController_WhenResetButtonTapped_ShouldPresentAlertWithCorrectTitle() {
        // given
        let sut = ScoreboardViewControllerPresentMock()
        
        // when
        sut.resetButtonTapped()
        
        // then
        XCTAssertEqual(sut.presentCalledCount, 1)
        XCTAssertEqual((sut.viewControllerPresented as? UIAlertController)?.title, "Are you sure you want to reset?")
    }
    
    func test_ScoreboardViewController_WhenResetButtonTapped_ShouldPresentAlertWithCorrectMessage() {
        // given
        let sut = ScoreboardViewControllerPresentMock()
        
        // when
        sut.resetButtonTapped()
        
        // then
        XCTAssertEqual(sut.presentCalledCount, 1)
        XCTAssertEqual((sut.viewControllerPresented as? UIAlertController)?.message, "This will erase all of the game data and player scores")
    }
    
    func test_ScoreboardViewController_WhenResetButtonTapped_ShouldPresentAlertWithFirstActionCancel() {
        // given
        let sut = ScoreboardViewControllerPresentMock()
        
        // when
        sut.resetButtonTapped()
        
        // then
        let cancelAction = (sut.viewControllerPresented as? UIAlertController)?.actions.first
        XCTAssertNotNil(cancelAction)
        XCTAssertEqual(cancelAction?.title, "Cancel")
        XCTAssertEqual(cancelAction?.style, .cancel)
    }
    
    func test_ScoreboardViewController_WhenResetButtonTapped_ShouldPresentAlertWithTwoActions() {
        // given
        let sut = ScoreboardViewControllerPresentMock()
        
        // when
        sut.resetButtonTapped()
        
        // then
        let actions = (sut.viewControllerPresented as? UIAlertController)?.actions
        XCTAssertEqual(actions?.count, 2)
    }
    
    func test_ScoreboardViewController_WhenResetButtonTapped_ShouldPresentAlertWithFirstActionReset() {
        // given
        let sut = ScoreboardViewControllerPresentMock()
        
        // when
        sut.resetButtonTapped()
        
        // then
        let resetAction = (sut.viewControllerPresented as? UIAlertController)?.actions.last
        XCTAssertNotNil(resetAction)
        XCTAssertEqual(resetAction?.title, "Reset")
        XCTAssertEqual(resetAction?.style, .destructive)
    }
    
    func test_ScoreboardViewController_WhenResetButtonTapped_ShouldSetResetActionHandlerToBeResetHandler() {
        // given
        let sut = ScoreboardViewControllerPresentMock()
        let viewModelMock = ScoreboardViewModelMock()
        sut.viewModel = viewModelMock
        
        // when
        sut.resetButtonTapped()
        let resetAction = (sut.viewControllerPresented as? UIAlertController)?.actions.last as? TestableUIAlertAction
      
        resetAction?.handler!(UIAlertAction(title: "", style: .destructive))
        
        // then
        XCTAssertEqual(viewModelMock.resetGameCalledCount, 1)
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
    
    
    // MARK: - Classes
    
    class ScoreboardViewControllerPresentMock: ScoreboardViewController {
        var presentCalledCount = 0
        var viewControllerPresented: UIViewController?
        override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
            presentCalledCount += 1
            self.viewControllerPresented = viewControllerToPresent
        }
    }
}
