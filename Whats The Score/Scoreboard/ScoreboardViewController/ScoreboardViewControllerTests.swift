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
    var views: [UIView]?

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
    
    
    // MARK: - Initialization
    
    func test_ScoreboardViewController_WhenViewLoaded_ShouldHaveNonNilOutlets() {
        // given
        let sut = viewController!
        
        // when
        sut.loadView()
        
        // then
        XCTAssertNotNil(sut.roundLabel)
        XCTAssertNotNil(sut.tableView)
        XCTAssertNotNil(sut.filterButtonStackView)
        XCTAssertNotNil(sut.turnOrderSortButton)
        XCTAssertNotNil(sut.scoreSortButton)
        XCTAssertNotNil(sut.endRoundButton)
        XCTAssertNotNil(sut.progressBarStackView)
        XCTAssertNotNil(sut.progressBar)
        XCTAssertNotNil(sut.progressBarLeftLabel)
        XCTAssertNotNil(sut.progressBarRightLabel)
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
    
    func test_ScoreboardViewController_WhenHistoryBarButtonSet_ShouldHaveHistoryBarButtonCorrectImageAndTarget() {
        // given
        let sut = viewController!
        
        // when
        let barButton = sut.historyBarButton
        
        // then
        XCTAssertEqual(barButton.image, UIImage(systemName: "clock.arrow.2.circlepath")!)
        XCTAssertEqual(barButton.target as? ScoreboardViewController, sut)
    }
    
    func test_ScoreboardViewController_WhenHistoryBarButtonActionCalled_ShouldCallHistoryButtonTapped() {
        
        class ScoreboardViewControllerHistoryButtonTappedMock: ScoreboardViewController {
            var historyBarButtonCalledCount = 0
            override func historyButtonTapped() {
                historyBarButtonCalledCount += 1
            }
        }
        
        // given
        let sut = ScoreboardViewControllerHistoryButtonTappedMock()
        
        let tableView = UITableView()
        sut.tableView = tableView
        
        // when
        _ = sut.historyBarButton.target?.perform(sut.historyBarButton.action, with: sut.historyBarButton)
        
        // then
        XCTAssertEqual(sut.historyBarButtonCalledCount, 1)
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
        XCTAssertEqual(sut.navigationItem.rightBarButtonItems?.first, sut.resetBarButton)
    }
    
    func test_ScoreboardViewController_WhenViewDidLoadCalled_ShouldSetNavigationItemSecondRightBarButtonToHistoryBarButton() {
        // given
        let sut = viewController!
        let viewModelMock = ScoreboardViewModelMock()
        sut.viewModel = viewModelMock
        
        // when
        sut.loadView()
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(sut.navigationItem.rightBarButtonItems?[1], sut.historyBarButton)
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
    
    func test_ScoreboardViewController_WhenViewDidLoadCalled_ShouldCallViewModelOpeningGameOverCheck() {
        // given
        let sut = viewController!
        let viewModelMock = ScoreboardViewModelMock()
        sut.viewModel = viewModelMock
        
        // when
        sut.loadView()
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(viewModelMock.openingGameOverCheckCalledCount, 1)
    }
    
    // MARK: - Binding PlayerToEditScore
    
    func test_ScoreboardViewController_WhenBindingsSetAndPlayerToEditScoreSetNil_ShouldNotPresentPlayerScoreEditorPopover() {
        // given
        let sut = getScoreboardViewControllerPresentMockWithNeccessaryViewsLoaded()
        let viewModelMock = ScoreboardViewModelMock()
        sut.viewModel = viewModelMock
        
        // when
        sut.viewDidLoad()
        viewModelMock.playerToEditScore.value = nil
        
        // then
        XCTAssertEqual(sut.presentCalledCount, 0)
        XCTAssertNil(sut.viewControllerPresented)
    }
    
    func test_ScoreboardViewController_WhenBindingsSetAndPlayerToEditScoreSetNotNil_ShouldPresentPlayerScoreEditorPopover() {
        
        // given
        let sut = getScoreboardViewControllerPresentMockWithNeccessaryViewsLoaded()
        let viewModelMock = ScoreboardViewModelMock()
        sut.viewModel = viewModelMock
        
        // when
        sut.viewDidLoad()
        viewModelMock.playerToEditScore.value = Player(name: "", position: 0)
        
        // then
        XCTAssertEqual(sut.presentCalledCount, 1)
        XCTAssertTrue(sut.viewControllerPresented is ScoreboardPlayerEditScorePopoverViewController)
    }
    
    func test_ScoreboardViewController_WhenBindingsSetAndPlayerToEditScoreSetNotNil_ShouldCallSetupPopoverCenteredWithCorrectParameters() {
        
        // given
        let sut = getScoreboardViewControllerPresentMockWithNeccessaryViewsLoaded()
        let viewModelMock = ScoreboardViewModelMock()
        sut.viewModel = viewModelMock
        
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
        XCTAssertTrue(defaultPopoverPresenterMock.setupPopoverCenteredTapToExit ?? false)
    }
    
    
    func test_ScoreboardViewController_WhenBindingsSetAndPlayerToEditScoreSetNotNil_ShouldSetPlayerScoreEditorPopoverScoreChangePlayerAndDelegateToViewModel() {
        // given
        let sut = getScoreboardViewControllerPresentMockWithNeccessaryViewsLoaded()
        let viewModelMock = ScoreboardViewModelMock()
        sut.viewModel = viewModelMock

        
        let playerName = UUID().uuidString
        let player = Player(name: playerName, position: 0)
        
        // when
        sut.viewDidLoad()
        viewModelMock.playerToEditScore.value = player
        
        // then
        let playerScoreEditorVC = sut.viewControllerPresented as? ScoreboardPlayerEditScorePopoverViewController
        XCTAssertEqual(playerScoreEditorVC?.scoreChange?.playerID, player.id)
        XCTAssertTrue(playerScoreEditorVC?.delegate is ScoreboardViewModelMock)
    }
    
    
    // MARK: - Binding PlayerToEdit
    
    func getScoreboardViewControllerPresentMockWithNeccessaryViewsLoaded() -> (ScoreboardViewControllerPresentMock) {
        let sut = ScoreboardViewControllerPresentMock()
        
        let view = UIView()
        sut.view = view
        let tableView = UITableView()
        sut.tableView = tableView
        let scoreButton = UIButton()
        sut.scoreSortButton = scoreButton
        let turnButton = UIButton()
        sut.turnOrderSortButton = turnButton
        
        views = [tableView, scoreButton, turnButton]
        
        addTeardownBlock {
            self.views = nil
        }
        
        return sut
    }
    
    func test_ScoreboardViewController_WhenBindingsSetAndPlayerToEditSetNil_ShouldNotPresentEditPlayerPopover() {
        // given
        let sut = getScoreboardViewControllerPresentMockWithNeccessaryViewsLoaded()
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
        let sut = getScoreboardViewControllerPresentMockWithNeccessaryViewsLoaded()
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
        let sut = getScoreboardViewControllerPresentMockWithNeccessaryViewsLoaded()
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
        XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredHeight, 100)
        XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredView, sut.view)
        XCTAssertTrue(defaultPopoverPresenterMock.setupPopoverCenteredPopoverVC is EditPlayerPopoverViewController)
        XCTAssertTrue(defaultPopoverPresenterMock.setupPopoverCenteredTapToExit ?? false)
    }
    
    
    func test_ScoreboardViewController_WhenBindingsSetAndPlayerToEditSetNotNil_ShouldSetEditPlayerPopoverPlayerAndDelegateToViewModel() {
        // given
        let sut = getScoreboardViewControllerPresentMockWithNeccessaryViewsLoaded()
        let viewModelMock = ScoreboardViewModelMock()
        sut.viewModel = viewModelMock
        
        let player = Player(name: "", position: 0)
        
        // when
        sut.viewDidLoad()
        viewModelMock.playerToEdit.value = player
        
        // then
        let playerEditorVC = sut.viewControllerPresented as? EditPlayerPopoverViewController
        XCTAssertEqual(playerEditorVC?.player?.id, player.id)
        XCTAssertTrue(playerEditorVC?.delegate is ScoreboardViewModelMock)
    }
    
    
    // MARK: - Binding PlayerToDelete
    
    func test_ScoreboardViewController_WhenBindingsSetAndPlayerToDeleteSetNil_ShouldNotPresentAnything() {
        // given
        let sut = getScoreboardViewControllerPresentMockWithNeccessaryViewsLoaded()
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
        let sut = getScoreboardViewControllerPresentMockWithNeccessaryViewsLoaded()
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
        let sut = getScoreboardViewControllerPresentMockWithNeccessaryViewsLoaded()
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
        let sut = getScoreboardViewControllerPresentMockWithNeccessaryViewsLoaded()
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
        let sut = getScoreboardViewControllerPresentMockWithNeccessaryViewsLoaded()
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
        let sut = getScoreboardViewControllerPresentMockWithNeccessaryViewsLoaded()
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
        let sut = getScoreboardViewControllerPresentMockWithNeccessaryViewsLoaded()
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
        XCTAssertEqual(viewModelMock.deletePlayerPlayer?.id, player.id)
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
    
    func test_ScoreboardViewController_WhenBindingsSetAndSortPreferenceSetScore_ShouldSetScoreSortPreferenceButtonAlphaTo1AndTurnToPoint5() {
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
    
    
    // MARK: - Binding ShouldShowEndGamePopover
    
    func test_ScoreboardViewController_WhenBindingsSetAndShouldShowEndGamePopupSetFalse_ShouldNotShowPopup() {
        // given
        let sut = getScoreboardViewControllerPresentMockWithNeccessaryViewsLoaded()
        let viewModelMock = ScoreboardViewModelMock()
        viewModelMock.shouldShowEndGamePopup.value = true
        sut.viewModel = viewModelMock
        
        // when
        sut.viewDidLoad()
        viewModelMock.shouldShowEndGamePopup.value = false
        
        // then
        XCTAssertEqual(sut.presentCalledCount, 0)
    }
    
    func test_ScoreboardViewController_WhenBindingsSetAndShouldShowEndGamePopupSetTrue_ShouldCallSetupPopoverCenteredWithCorrectParametersSetShouldShowValueToFalse() {
        // given
        let sut = getScoreboardViewControllerPresentMockWithNeccessaryViewsLoaded()
        let viewModelMock = ScoreboardViewModelMock()
        sut.viewModel = viewModelMock
        
        let defaultPopoverPresenterMock = DefaultPopoverPresenterMock()
        sut.defaultPopoverPresenter = defaultPopoverPresenterMock
        
        // when
        sut.viewDidLoad()
        viewModelMock.shouldShowEndGamePopup.value = true
        
        // then
        XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredCalledCount, 1)
        XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredWidth, 300)
        XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredHeight, 165)
        XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredView, sut.view)
        XCTAssertTrue(defaultPopoverPresenterMock.setupPopoverCenteredPopoverVC is EndGamePopoverViewController)
        XCTAssertFalse(viewModelMock.shouldShowEndGamePopup.value ?? true)
    }
    
    func test_ScoreboardViewController_WhenBindingsSetAndShouldShowEndGamePopupSetTrueWithGameIsEndOfGameTrue_ShouldCallSetupPopoverCenteredTapToExitFalse() {
        // given
        let sut = getScoreboardViewControllerPresentMockWithNeccessaryViewsLoaded()
        let viewModelMock = ScoreboardViewModelMock()
        
        let game = GameIsEndOfGameMock()
        game.isEndOfGameBool = true
        
        viewModelMock.game = game
        sut.viewModel = viewModelMock
        
        let defaultPopoverPresenterMock = DefaultPopoverPresenterMock()
        sut.defaultPopoverPresenter = defaultPopoverPresenterMock
        
        // when
        sut.viewDidLoad()
        viewModelMock.shouldShowEndGamePopup.value = true
        
        // then
        XCTAssertFalse(defaultPopoverPresenterMock.setupPopoverCenteredTapToExit ?? true)
    }
    
    func test_ScoreboardViewController_WhenBindingsSetAndShouldShowEndGamePopupSetTrueWithGameIsEndOfGameFalse_ShouldCallSetupPopoverCenteredTapToExitTrue() {
        // given
        let sut = getScoreboardViewControllerPresentMockWithNeccessaryViewsLoaded()
        let viewModelMock = ScoreboardViewModelMock()
        
        let game = GameIsEndOfGameMock()
        game.isEndOfGameBool = false
        
        viewModelMock.game = game
        sut.viewModel = viewModelMock
        
        let defaultPopoverPresenterMock = DefaultPopoverPresenterMock()
        sut.defaultPopoverPresenter = defaultPopoverPresenterMock
        
        // when
        sut.viewDidLoad()
        viewModelMock.shouldShowEndGamePopup.value = true
        
        // then
        XCTAssertTrue(defaultPopoverPresenterMock.setupPopoverCenteredTapToExit ?? false)
    }
    
    func test_ScoreboardViewController_WhenBindingsSetAndShouldShowEndGamePopupSetTrue_ShouldPresentEndGamePopoverViewController() {
        // given
        let sut = getScoreboardViewControllerPresentMockWithNeccessaryViewsLoaded()
        let viewModelMock = ScoreboardViewModelMock()
        sut.viewModel = viewModelMock
        
        // when
        sut.viewDidLoad()
        viewModelMock.shouldShowEndGamePopup.value = true
        
        // then
        XCTAssertTrue(sut.viewControllerPresented is EndGamePopoverViewController)
        XCTAssertEqual(sut.presentCalledCount, 1)
    }
    
    func test_ScoreboardViewController_WhenBindingsSetAndShouldShowEndGamePopupSetTrue_ShouldSetGameAsViewModelsGameAndViewModelAsDelegate() {
        // given
        let sut = getScoreboardViewControllerPresentMockWithNeccessaryViewsLoaded()
        let viewModelMock = ScoreboardViewModelMock()
        let mockGame = Game(basicGameWithPlayers: [])
        viewModelMock.game = mockGame
        
        sut.viewModel = viewModelMock
        
        // when
        sut.viewDidLoad()
        viewModelMock.shouldShowEndGamePopup.value = true
        
        // then
        guard let game = (sut.viewControllerPresented as? EndGamePopoverViewController)?.game else {
            XCTFail("Game should not be nil")
            return
        }
        
        XCTAssertTrue((sut.viewControllerPresented as? EndGamePopoverViewController)?.delegate === viewModelMock)
        XCTAssertTrue(game.isEqualTo(game: mockGame))
    }
    
    
    // MARK: - Binding ShouldGoToEndGameScreen
    
    func test_ScoreboardViewController_WhenBindingsSetAndShouldGoToEndGameScreenSetFalse_ShouldNotChangNavigationControllersViewControllers() {
        // given
        let sut = getScoreboardViewControllerPresentMockWithNeccessaryViewsLoaded()
        let viewModelMock = ScoreboardViewModelMock()
        sut.viewModel = viewModelMock
        
        let navigationController = NavigationControllerPushMock()
        navigationController.viewControllers = [sut]
        
        // when
        sut.viewDidLoad()
        viewModelMock.shouldGoToEndGameScreen.value = false
        
        // then
        XCTAssertEqual(navigationController.viewControllers, [sut])
    }
    
    func test_ScoreboardViewController_WhenBindingsSetAndShouldGoToEndGameScreenSetTrue_ShouldSetEndGameViewControllerAsNavigationControllersRootViewController() {
        // given
        let sut = getScoreboardViewControllerPresentMockWithNeccessaryViewsLoaded()
        let viewModelMock = ScoreboardViewModelMock()
        sut.viewModel = viewModelMock
        
        let navigationController = NavigationControllerPushMock()
        navigationController.viewControllers = [sut]
        
        // when
        sut.viewDidLoad()
        viewModelMock.shouldGoToEndGameScreen.value = true
        
        // then
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        XCTAssertTrue(navigationController.viewControllers.first is EndGameViewController)
    }
    
    
    func test_ScoreboardViewController_WhenBindingsSetAndShouldGoToEndGameScreenSetTrue_ShouldPushEndGameViewControllerWithViewModelContainingCurrentGame() {
        // given
        let sut = getScoreboardViewControllerPresentMockWithNeccessaryViewsLoaded()
        let game = GameMock()
        let viewModelMock = ScoreboardViewModelMock(game: game)
        sut.viewModel = viewModelMock
        
        let navigationController = NavigationControllerPushMock()
        navigationController.viewControllers = [sut]
        
        // when
        sut.viewDidLoad()
        viewModelMock.shouldGoToEndGameScreen.value = true
        
        // then
        let endGameVCViewModel = (navigationController.viewControllers.first as? EndGameViewController)?.viewModel
        XCTAssertTrue(endGameVCViewModel?.game.isEqualTo(game: game) ?? false)
    }
    
    
    // MARK: - ShouldShowKeepPlayingPopup
    
    func test_ScoreboardViewController_WhenBindingsSetAndShouldShouldShowKeepPlayingPopupSetFalse_ShouldNotCallPresent() {
        // given
        let sut = getScoreboardViewControllerPresentMockWithNeccessaryViewsLoaded()
        let viewModelMock = ScoreboardViewModelMock()
        sut.viewModel = viewModelMock
        
        // when
        sut.viewDidLoad()
        viewModelMock.shouldShowKeepPlayingPopup.value = false
        
        // then
        XCTAssertEqual(sut.presentCalledCount, 0)
    }
    
    func test_ScoreboardViewController_WhenBindingsSetAndShouldShouldShowKeepPlayingPopupSetTrue_ShouldCallSetupPopoverCenteredWithCorrectParameters() {
        // given
        let sut = getScoreboardViewControllerPresentMockWithNeccessaryViewsLoaded()
        let viewModelMock = ScoreboardViewModelMock()
        sut.viewModel = viewModelMock
        
        let defaultPopoverPresenterMock = DefaultPopoverPresenterMock()
        sut.defaultPopoverPresenter = defaultPopoverPresenterMock
        
        // when
        sut.viewDidLoad()
        viewModelMock.shouldShowKeepPlayingPopup.value = true
        
        // then
        XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredCalledCount, 1)
//                XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredWidth, 300)
//                XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredHeight, 200)
        XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredView, sut.view)
        XCTAssertTrue(defaultPopoverPresenterMock.setupPopoverCenteredPopoverVC is KeepPlayingPopoverViewController)
        XCTAssertFalse(viewModelMock.shouldShowEndGamePopup.value ?? true)
        XCTAssertFalse(defaultPopoverPresenterMock.setupPopoverCenteredTapToExit ?? true)
    }
    
    func test_ScoreboardViewController_WhenBindingsSetAndShouldShowKeepPlayingPopupSetTrue_ShouldSetViewModelsShouldShowValueToFalse() {
        let sut = getScoreboardViewControllerPresentMockWithNeccessaryViewsLoaded()
        let viewModelMock = ScoreboardViewModelMock()
        sut.viewModel = viewModelMock
        sut.viewModel?.game.gameEndType = .round
        
        // when
        sut.viewDidLoad()
        viewModelMock.shouldShowKeepPlayingPopup.value = true
        
        // then
        XCTAssertFalse(viewModelMock.shouldShowKeepPlayingPopup.value ?? true)
    }
    
    func test_ScoreboardViewController_WhenBindingsSetAndhouldShowKeepPlayingPopupSetTrue_ShouldPresentKeepPlayingPopoverViewController() {
        // given
        let sut = getScoreboardViewControllerPresentMockWithNeccessaryViewsLoaded()
        let viewModelMock = ScoreboardViewModelMock()
        sut.viewModel = viewModelMock
        sut.viewModel?.game.gameEndType = .round
        
        // when
        sut.viewDidLoad()
        viewModelMock.shouldShowKeepPlayingPopup.value = true
        
        // then
        XCTAssertTrue(sut.viewControllerPresented is KeepPlayingPopoverViewController)
        XCTAssertEqual(sut.presentCalledCount, 1)
    }
    
    func test_ScoreboardViewController_WhenBindingsSetAndShouldShowKeepPlayingPopupSetTrue_ShouldSetGameAsViewModelsGameAndViewModelAsDelegate() {
        // given
        let sut = getScoreboardViewControllerPresentMockWithNeccessaryViewsLoaded()
        let viewModelMock = ScoreboardViewModelMock()
        var mockGame = Game(basicGameWithPlayers: [])
        mockGame.gameEndType = .round
        viewModelMock.game = mockGame
        
        sut.viewModel = viewModelMock
        
        // when
        sut.viewDidLoad()
        viewModelMock.shouldShowKeepPlayingPopup.value = true
        
        // then
        let keepPlayingVC = sut.viewControllerPresented as? KeepPlayingPopoverViewController
        guard let game = keepPlayingVC?.game else {
            XCTFail("Game should not be nil")
            return
        }
        
        XCTAssertTrue(game.isEqualTo(game: mockGame))
        XCTAssertTrue(keepPlayingVC?.delegate === viewModelMock)
    }
    
    
    // MARK: - EndRoundButtonTapped
    
    func test_ScoreboardViewController_WhenEndRoundButtonTappedCalledUnderOnePlayer_ShouldNotPresentEndRoundPopover() {
        // given
        let sut = getScoreboardViewControllerPresentMockWithNeccessaryViewsLoaded()
        sut.defaultPopoverPresenter = DefaultPopoverPresenterMock()
        let viewModelMock = ScoreboardViewModelMock()
        viewModelMock.sortedPlayers = []
        sut.viewModel = viewModelMock
        
        // when
        sut.endRoundButtonTapped(0)
        
        // then
        XCTAssertEqual(sut.presentCalledCount, 0)
    }
    
    func test_ScoreboardViewController_WhenEndRoundButtonTappedCalled_ShouldCallSetupPopoverCenteredWithCorrectParameters() {
        
        // given
        let sut = getScoreboardViewControllerPresentMockWithNeccessaryViewsLoaded()
        
        let defaultPopoverPresenterMock = DefaultPopoverPresenterMock()
        sut.defaultPopoverPresenter = defaultPopoverPresenterMock
        let viewModelMock = ScoreboardViewModelMock()
        viewModelMock.sortedPlayers = [Player(name: "", position: 0)]
        sut.viewModel = viewModelMock
        
        
        // when
        sut.endRoundButtonTapped(0)
        
        // then
        XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredCalledCount, 1)
        XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredWidth, 300)
        XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredView, sut.view)
        XCTAssertTrue(defaultPopoverPresenterMock.setupPopoverCenteredPopoverVC is EndRoundPopoverViewController)
        XCTAssertTrue(defaultPopoverPresenterMock.setupPopoverCenteredTapToExit ?? false)
    }
    
    func test_ScoreboardViewController_WhenEndRoundButtonTappedCalled_ShouldCallEndRoundPopoverHeightHelperGetPopoverHeightForWithCorrectParameters() {
        // given
        let sut = getScoreboardViewControllerPresentMockWithNeccessaryViewsLoaded()
        
        let endRoundPopoverHeightHelperMock = EndRoundPopoverHeightHelperMock()
        sut.endRoundPopoverHeightHelper = endRoundPopoverHeightHelperMock
        
        let rectHeight = CGFloat.random(in: 0...100)
        let viewMock = UIViewSafeAreaLayoutFrameMock(safeAreaFrame: CGRect(x: 0, y: 0, width: 0, height: rectHeight))
        sut.view = viewMock
        
        let viewModelMock = ScoreboardViewModelMock()
        let playerCount = Int.random(in: 1...10)
        viewModelMock.sortedPlayers = Array(repeating: Player(name: "", position: 0), count: playerCount)
        sut.viewModel = viewModelMock
        
        // when
        sut.endRoundButtonTapped(0)
        
        // then
        XCTAssertEqual(endRoundPopoverHeightHelperMock.getPopoverHeightForSafeAreaHeight, rectHeight)
        XCTAssertEqual(endRoundPopoverHeightHelperMock.getPopoverHeightForPlayerCount, playerCount)
        XCTAssertEqual(endRoundPopoverHeightHelperMock.getPopoverHeightForCalledCount, 1)
    }
    
    func test_ScoreboardViewController_WhenEndRoundButtonTappedCalled_ShouldCallSetupPopoverCenteredWithHeightFromEndRoundPopoverHeightHelper() {
        // given
        let sut = getScoreboardViewControllerPresentMockWithNeccessaryViewsLoaded()
        
        let heightToReturn = CGFloat.random(in: 0...10000)
        let endRoundPopoverHeightHelperMock = EndRoundPopoverHeightHelperMock()
        endRoundPopoverHeightHelperMock.heightToReturn = heightToReturn
        
        sut.endRoundPopoverHeightHelper = endRoundPopoverHeightHelperMock
        
        let defaultPopoverPresenterMock = DefaultPopoverPresenterMock()
        sut.defaultPopoverPresenter = defaultPopoverPresenterMock
        let viewModelMock = ScoreboardViewModelMock()
        viewModelMock.sortedPlayers = [Player(name: "", position: 0)]
        sut.viewModel = viewModelMock
        
        // when
        sut.endRoundButtonTapped(0)
        
        // then
        XCTAssertEqual(defaultPopoverPresenterMock.setupPopoverCenteredHeight, heightToReturn)
    }
    
    func test_ScoreboardViewController_WhenEndRoundButtonTappedCalled_ShouldPresentEndRoundPopover() {
        // given
        let sut = getScoreboardViewControllerPresentMockWithNeccessaryViewsLoaded()
        sut.defaultPopoverPresenter = DefaultPopoverPresenterMock()
        let viewModelMock = ScoreboardViewModelMock()
        viewModelMock.sortedPlayers = [Player(name: "", position: 0)]
        sut.viewModel = viewModelMock
        
        // when
        sut.endRoundButtonTapped(0)
        
        // then
        XCTAssertEqual(sut.presentCalledCount, 1)
        XCTAssertTrue(sut.viewControllerPresented is EndRoundPopoverViewController)
    }
    
    func test_ScoreboardViewController_WhenEndRoundButtonTappedCalled_ShouldPresentEndRoundPopoverWithEndRoundPlayersSortedByPositionAndRoundNumber() {
        // given
        let sut = getScoreboardViewControllerPresentMockWithNeccessaryViewsLoaded()
        sut.defaultPopoverPresenter = DefaultPopoverPresenterMock()
        
        let viewModelMock = ScoreboardViewModelMock()
        let players = [Player(name: "", position: 1), Player(name: "", position: 0)]
        viewModelMock.sortedPlayers = players
        
        let currentRound = Int.random(in: 1...1000)
        viewModelMock.game.currentRound = currentRound
        
        sut.viewModel = viewModelMock
        
        // when
        sut.endRoundButtonTapped(0)
        
        // then
        let endRoundPopoverVC = sut.viewControllerPresented as? EndRoundPopoverViewController
        let sortedPlayers = players.sorted { $0.position < $1.position }
        
        sortedPlayers.enumerated().forEach { (index, player) in
            XCTAssertEqual(endRoundPopoverVC?.endRound?.scoreChangeArray[index].playerID, player.id)
        }
        
        XCTAssertEqual(endRoundPopoverVC?.endRound?.roundNumber, currentRound)
    }
    
    func test_ScoreboardViewController_WhenEndRoundButtonTappedCalled_ShouldPresentEndRoundPopoverWithHeightHelperPlayerViewHeightAndPlayerSeperatorHeight() {
        // given
        let sut = getScoreboardViewControllerPresentMockWithNeccessaryViewsLoaded()
        sut.defaultPopoverPresenter = DefaultPopoverPresenterMock()
        
        let playerViewHeight = Int.random(in: 1...1000)
        let playerSeperatorHeight = Int.random(in: 1...1000)
        sut.endRoundPopoverHeightHelper = EndRoundPopoverHeightHelper(playerViewHeight: playerViewHeight, playerSeperatorHeight: playerSeperatorHeight)
        
        let viewModelMock = ScoreboardViewModelMock()
        viewModelMock.sortedPlayers = [Player(name: "", position: 0)]
        sut.viewModel = viewModelMock
        
        // when
        sut.endRoundButtonTapped(0)
        
        // then
        let endRoundPopoverVC = sut.viewControllerPresented as? EndRoundPopoverViewController
        XCTAssertEqual(endRoundPopoverVC?.playerViewHeight, playerViewHeight)
        XCTAssertEqual(endRoundPopoverVC?.playerSeparatorHeight, playerSeperatorHeight)
    }
    
    func test_ScoreboardViewController_WhenEndRoundButtonTapped_ShouldSetViewModelAsEndRoundVCDelegate() {
        // given
        let sut = getScoreboardViewControllerPresentMockWithNeccessaryViewsLoaded()
        let viewModelMock = ScoreboardViewModelMock()
        viewModelMock.sortedPlayers = [Player(name: "", position: 0)]
        sut.viewModel = viewModelMock
        
        // when
        sut.endRoundButtonTapped(0)
        
        // then
        let endRoundPopoverVC = sut.viewControllerPresented as? EndRoundPopoverViewController
        XCTAssertTrue(endRoundPopoverVC?.delegate is ScoreboardViewModelMock)
    }
    
    
    // MARK: - IBActions
    
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
    

    // MARK: - HistoryButtonTapped
    
    func test_ScoreboardViewController_WhenHistoryButtonTappedCalled_ShouldPushGameHistoryViewControllerWithCorrectGame() {
        // given
        let sut = viewController!
        let navigationController = NavigationControllerPushMock()
        navigationController.viewControllers = [sut]
        
        let game = GameMock()
        let viewModel = ScoreboardViewModelMock(game: game)
        sut.viewModel = viewModel
        
        // when
        sut.historyButtonTapped()
        
        // then
        let gameHistoryViewController = navigationController.pushedViewController as? GameHistoryViewController
        XCTAssertEqual(navigationController.pushViewControllerCount, 1)
        XCTAssertNotNil(gameHistoryViewController)
        XCTAssertTrue(gameHistoryViewController?.viewModel.game.isEqualTo(game: game) ?? false)
    }
    
    func test_ScoreboardViewController_WhenHistoryButtonTapped_ShouldSetViewModelAsGameHistoryDelegate() {
        // given
        let sut = viewController!
        let navigationController = NavigationControllerPushMock()
        navigationController.viewControllers = [sut]
        
        let game = GameMock()
        let viewModel = ScoreboardViewModelMock(game: game)
        sut.viewModel = viewModel
        
        // when
        sut.historyButtonTapped()
        
        // then
        let gameHistoryViewController = navigationController.pushedViewController as? GameHistoryViewController
        XCTAssertEqual(gameHistoryViewController?.delegate as? ScoreboardViewModelMock, viewModel)
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

    func test_ScoreboardViewController_WhenViewModelGameHasRoundGameTypeAndBindViewModelToViewCalled_ShouldShowRoundLabelAndEndRoundButton() {
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
        XCTAssertFalse(sut.endRoundButton.isHidden)
    }
    
    func test_ScoreboardViewController_WhenViewModelGameHasNotRoundGameTypeAndBindViewModelToViewCalled_ShouldHideRoundLabelAndEndRoundButton() {
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
        XCTAssertTrue(sut.endRoundButton.isHidden)
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
    
    func test_ScoreboardViewController_WhenViewModelBindViewModelToViewCalledEndGameNone_ShouldMakeProgressBarStackViewHidden() {
        // given
        let sut = viewController!
        sut.loadView()
        sut.viewModel = ScoreboardViewModelMock()
        sut.viewModel?.game.gameEndType = .none
        sut.viewModel?.game.gameType = .round
        
        // when
        sut.bindViewToViewModel(dispatchQueue: DispatchQueueMainMock())
        
        // then
        XCTAssertTrue(sut.progressBarStackView.isHidden)
    }
    
    func test_ScoreboardViewController_WhenViewModelBindViewModelToViewCalledGameTypeBasic_ShouldMakeProgressBarStackViewHidden() {
        // given
        let sut = viewController!
        sut.loadView()
        sut.viewModel = ScoreboardViewModelMock()
        sut.viewModel?.game.gameEndType = .round
        sut.viewModel?.game.gameType = .basic
        
        // when
        sut.bindViewToViewModel(dispatchQueue: DispatchQueueMainMock())
        
        // then
        XCTAssertTrue(sut.progressBarStackView.isHidden)
    }
    
    func test_ScoreboardViewController_WhenViewModelBindViewModelToViewCalledEndGameNotNone_ShouldMakeProgressBarStackViewNotHidden() {
        // given
        let sut = viewController!
        sut.loadView()
        sut.viewModel = ScoreboardViewModelMock()
        sut.viewModel?.game.gameEndType = .round
        sut.viewModel?.game.gameType = .round
        
        
        // when
        sut.bindViewToViewModel(dispatchQueue: DispatchQueueMainMock())
        
        // then
        XCTAssertFalse(sut.progressBarStackView.isHidden)
    }
    
    func test_ScoreboardViewController_WhenViewModelBindViewModelToViewCalledEndGameRound_ShouldSetProgressToOneLessOfCurrentRoundDividedByTotalRounds() {
        // given
        let sut = viewController!
        sut.loadView()
        sut.viewModel = ScoreboardViewModelMock()
        
        sut.viewModel?.game.gameEndType = .round
        sut.viewModel?.game.gameType = .round
        
        let totalNumberOfRounds = Int.random(in: 6...10)
        sut.viewModel?.game.numberOfRounds = totalNumberOfRounds
        
        let currentRound = Int.random(in: 1...5)
        sut.viewModel?.game.currentRound = currentRound
        
        // when
        sut.bindViewToViewModel(dispatchQueue: DispatchQueueMainMock())
        
        // then
        let expectedProgress: Float = (Float(currentRound - 1))/Float(totalNumberOfRounds)
        XCTAssertEqual(sut.progressBar.progress, expectedProgress)
    }
    
    func test_ScoreboardViewController_WhenViewModelBindViewModelToViewCalledEndGameRound_ShouldSetProgressRightLabelToNumberOfRounds() {
        // given
        let sut = viewController!
        sut.loadView()
        sut.viewModel = ScoreboardViewModelMock()
        
        sut.viewModel?.game.gameEndType = .round
        sut.viewModel?.game.gameType = .round
        
        let totalNumberOfRounds = Int.random(in: 6...10)
        sut.viewModel?.game.numberOfRounds = totalNumberOfRounds
        
        // when
        sut.bindViewToViewModel(dispatchQueue: DispatchQueueMainMock())
        
        // then
        XCTAssertEqual(sut.progressBarRightLabel.text, "\(totalNumberOfRounds)")
    }
    
    func test_ScoreboardViewController_WhenViewModelBindViewModelToViewCalledEndGameRoundMultipleRoundsLeft_ShouldSetProgressBarLeftLabelTextToHowManyRoundsAreLeftMultiple() {
        // given
        let sut = viewController!
        sut.loadView()
        sut.viewModel = ScoreboardViewModelMock()
        
        sut.viewModel?.game.gameEndType = .round
        sut.viewModel?.game.gameType = .round
        
        let totalNumberOfRounds = Int.random(in: 6...10)
        sut.viewModel?.game.numberOfRounds = totalNumberOfRounds
        
        let currentRound = Int.random(in: 1...5)
        sut.viewModel?.game.currentRound = currentRound
        
        // when
        sut.bindViewToViewModel(dispatchQueue: DispatchQueueMainMock())
        
        // then
        let numberOfRoundsLeft = totalNumberOfRounds - (currentRound - 1)
        XCTAssertEqual(sut.progressBarLeftLabel.text, "\(numberOfRoundsLeft) rounds left")
    }
    
    func test_ScoreboardViewController_WhenViewModelBindViewModelToViewCalledEndGameRoundMultipleRoundsLeft_ShouldSetProgressBarLeftLabelTextToLastRound() {
        // given
        let sut = viewController!
        sut.loadView()
        sut.viewModel = ScoreboardViewModelMock()
        
        sut.viewModel?.game.gameEndType = .round
        sut.viewModel?.game.gameType = .round
        
        let totalNumberOfRounds = 4
        sut.viewModel?.game.numberOfRounds = totalNumberOfRounds
        
        let currentRound = 4
        sut.viewModel?.game.currentRound = currentRound
        
        // when
        sut.bindViewToViewModel(dispatchQueue: DispatchQueueMainMock())
        
        // then
        XCTAssertEqual(sut.progressBarLeftLabel.text, "last round")
    }

    func test_ScoreboardViewController_WhenViewModelBindViewModelToViewCalledEndGameScore_ShouldSetProgressEqualToWinningPlayersScoreDividedByGameEndScore() {
        // given
        let sut = viewController!
        sut.loadView()
        sut.viewModel = ScoreboardViewModelMock()
        
        var game = GameMock()
        game.gameEndType = .score
        game.gameType = .round
        
        let topPlayerScore = Int.random(in: 1...5)
        game.winningPlayers = [PlayerMock(name: "", position: 0, score: topPlayerScore)]
        
        let endingScore = Int.random(in: 6...10)
        game.endingScore = endingScore
        
        sut.viewModel?.game = game
        
        // when
        sut.bindViewToViewModel(dispatchQueue: DispatchQueueMainMock())
        
        // then
        let expectedProgress: Float = (Float(topPlayerScore))/Float(endingScore)
        XCTAssertEqual(sut.progressBar.progress, expectedProgress)
    }
    
    func test_ScoreboardViewController_WhenViewModelBindViewModelToViewCalledEndGameScoreOneWinningPlayerSinglePoint_ShouldSetProgressBarLeftLabelTextToPlayerNeeds1PtToWin() {
        // given
        let sut = viewController!
        sut.loadView()
        sut.viewModel = ScoreboardViewModelMock()
        
        var game = GameMock()
        game.gameEndType = .score
        game.gameType = .round
        
        let topPlayerScore = 5
        let playerName = UUID().uuidString
        game.winningPlayers = [PlayerMock(name: playerName, position: 0, score: topPlayerScore)]
        
        let endingScore = 6
        game.endingScore = endingScore
        
        sut.viewModel?.game = game
        
        // when
        sut.bindViewToViewModel(dispatchQueue: DispatchQueueMainMock())
        
        // then
        XCTAssertEqual(sut.progressBarLeftLabel.text, "\(playerName) needs 1 pt to win")
    }
    
    func test_ScoreboardViewController_WhenViewModelBindViewModelToViewCalledEndGameScoreOneWinningPlayer_ShouldSetProgressBarLeftLabelTextToPlayerNeedsxPtsToWin() {
        // given
        let sut = viewController!
        sut.loadView()
        sut.viewModel = ScoreboardViewModelMock()
        
        let game = GameMock()
        game.gameEndType = .score
        game.gameType = .round
        
        let topPlayerScore = Int.random(in: 1...5)
        let playerName = UUID().uuidString
        game.winningPlayers = [PlayerMock(name: playerName, position: 0, score: topPlayerScore)]
        
        let endingScore = Int.random(in: 7...10)
        game.endingScore = endingScore
        
        sut.viewModel?.game = game
        
        // when
        sut.bindViewToViewModel(dispatchQueue: DispatchQueueMainMock())
        
        // then
        XCTAssertEqual(sut.progressBarLeftLabel.text, "\(playerName) needs \(endingScore-topPlayerScore) pts to win")
    }
    
    func test_ScoreboardViewController_WhenViewModelBindViewModelToViewCalledEndGameScoreMultipleWinningPlayers_ShouldSetProgressBarLeftLabelTextToMultiplePlayersNeedxPntsToWin() {
        // given
        let sut = viewController!
        sut.loadView()
        sut.viewModel = ScoreboardViewModelMock()
        
        var game = GameMock()
        game.gameEndType = .score
        game.gameType = .round
        
        let topPlayerScore = Int.random(in: 1...5)
        game.winningPlayers = [PlayerMock(name: "", position: 0, score: topPlayerScore),
                               PlayerMock(name: "", position: 0, score: topPlayerScore)]
        
        let endingScore = Int.random(in: 7...10)
        game.endingScore = endingScore
        
        sut.viewModel?.game = game
        
        // when
        sut.bindViewToViewModel(dispatchQueue: DispatchQueueMainMock())
        
        // then
        XCTAssertEqual(sut.progressBarLeftLabel.text, "Multiple players need \(endingScore-topPlayerScore) pts to win")
    }
    
    func test_ScoreboardViewController_WhenViewModelBindViewModelToViewCalledEndGameScore_ShouldSetProgressBarRightLabelTextToEndingScore() {
        // given
        let sut = viewController!
        sut.loadView()
        sut.viewModel = ScoreboardViewModelMock()
        
        let game = GameMock()
        game.gameEndType = .score
        game.gameType = .round
        
        let endingScore = Int.random(in: 6...10)
        game.endingScore = endingScore
        
        sut.viewModel?.game = game
        
        // when
        sut.bindViewToViewModel(dispatchQueue: DispatchQueueMainMock())
        
        // then
        XCTAssertEqual(sut.progressBarRightLabel.text, "\(endingScore)")
    }
    
    func test_ScoreboardViewController_WhenViewModelBindViewModelToViewCalledIsEndOfGameTrue_ShouldHideProgressViewAndSetRoundLabelToGameOver() {
        
        // given
        let sut = viewController!
        sut.loadView()
        
        let viewModelMock = ScoreboardViewModelMock()
        let gameMock = GameIsEndOfGameMock()
        gameMock.isEndOfGameBool = true
        viewModelMock.game = gameMock
        
        sut.viewModel = viewModelMock
        
        // when
        sut.bindViewToViewModel(dispatchQueue: DispatchQueueMainMock())
        
        // then
        XCTAssertEqual(sut.roundLabel.text, "Game Over")
        XCTAssertTrue(sut.progressBarStackView.isHidden)
        XCTAssertEqual(gameMock.isEndOfGameCalledCount, 1)
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
