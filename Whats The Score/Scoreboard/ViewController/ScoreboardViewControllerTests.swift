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
        views = nil
    }
    
    func getScoreboardViewControllerPresentMockWithNeccessaryViewsLoaded() -> (ScoreboardViewControllerPresentMock) {
        let sut = ScoreboardViewControllerPresentMock()
        
        let view = UIView()
        sut.view = view
        let tableView = UITableView()
        sut.tableView = tableView
        let button = UIButton()
        sut.scoreSortButton = button
        sut.turnOrderSortButton = button
        sut.addPlayerButton = button
        sut.endGameButton = button
        sut.endRoundButton = button
        
        views = [tableView, button]
        
        addTeardownBlock {
            self.views = nil
        }
        
        return sut
    }
    
    
    // MARK: - Initialization
    
    func test_ScoreboardViewController_WhenViewLoaded_ShouldHaveNonNilOutlets() {
        // given
        let sut = viewController!
        
        // when
        sut.loadView()
        
        // then
        XCTAssertNotNil(sut.gameNameLabel)
        XCTAssertNotNil(sut.roundLabel)
        XCTAssertNotNil(sut.tableView)
        XCTAssertNotNil(sut.filterButtonStackView)
        XCTAssertNotNil(sut.turnOrderSortButton)
        XCTAssertNotNil(sut.scoreSortButton)
        XCTAssertNotNil(sut.endRoundButton)
        XCTAssertNotNil(sut.progressLabel)
    }
    
    
    // MARK: - Properties
    
    func test_ScoreboardViewController_WhenSettingsBarButtonSet_ShouldHaveSettingsBarButtonCorrectImageTintAndTarget() {
        // given
        let sut = viewController!
        
        // when
        let barButton = sut.settingsBarButton
        
        // then
        XCTAssertEqual(barButton.image, UIImage(named: "gearIcon")!)
        XCTAssertEqual(barButton.target as? ScoreboardViewController, sut)
        XCTAssertEqual(barButton.tintColor, UIColor.textColor)
    }
    
        func test_ScoreboardViewController_WhenSettingsBarButtonActionCalled_ShouldCallSettingsButtonTapped() {
    
            class ScoreboardViewControllerSettingsButtonTappedMock: ScoreboardViewController {
                var settingsBarButtonCalledCount = 0
                override func settingsButtonTapped() {
                    settingsBarButtonCalledCount += 1
                }
            }
    
            // given
            let sut = ScoreboardViewControllerSettingsButtonTappedMock()
    
            let tableView = UITableView()
            sut.tableView = tableView
    
            // when
            _ = sut.settingsBarButton.target?.perform(sut.settingsBarButton.action, with: sut.settingsBarButton)
    
            // then
            XCTAssertEqual(sut.settingsBarButtonCalledCount, 1)
        }
    
    func test_ScoreboardViewController_WhenHistoryBarButtonSet_ShouldHaveHistoryBarButtonCorrectImageTintAndTarget() {
        // given
        let sut = viewController!
        
        // when
        let barButton = sut.historyBarButton
        
        // then
        XCTAssertEqual(barButton.image, UIImage(named: "clockIcon")!)
        XCTAssertEqual(barButton.target as? ScoreboardViewController, sut)
        XCTAssertEqual(barButton.tintColor, .textColor)

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
    
    func test_ScoreboardViewController_WhenViewDidLoadCalled_ShouldSetSecondNavigationItemRightBarButtonToSettingsBarButton() {
        // given
        let sut = viewController!
        let viewModelMock = ScoreboardViewModelMock()
        sut.viewModel = viewModelMock
        
        // when
        sut.loadView()
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(sut.navigationItem.rightBarButtonItems?[0], sut.settingsBarButton)
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
    
    func test_ScoreboardViewController_WhenViewDidLoadCalled_ShouldCallSetAttributeUnderlinedTitleWithSubtextOnAddPlayerButtonWithCorrectParameters() {
        // given
        let sut = viewController!
        sut.loadView()
        
        let addPlayerButton = UIButtonUnderlineButtonForButtonStatesMock()
        sut.addPlayerButton = addPlayerButton
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(addPlayerButton.underlineButtonForButtonStatesCalledCount, 1)
        XCTAssertEqual(addPlayerButton.underlineButtonForButtonStatesTitle, "Add Player")
        XCTAssertEqual(addPlayerButton.underlineButtonForButtonStatesTextSize, 15)
    }
    
    func test_ScoreboardViewController_WhenViewDidLoadCalled_ShouldCallSetAttributeUnderlinedTitleWithSubtextOnEndRoundButtonWithCorrectParameters() {
        // given
        let sut = viewController!
        sut.loadView()
        
        let endRoundButton = UIButtonUnderlineButtonForButtonStatesMock()
        sut.endRoundButton = endRoundButton
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(endRoundButton.underlineButtonForButtonStatesCalledCount, 1)
        XCTAssertEqual(endRoundButton.underlineButtonForButtonStatesTitle, "End Round")
        XCTAssertEqual(endRoundButton.underlineButtonForButtonStatesTextSize, 22)
    }
    
    func test_ScoreboardViewController_WhenViewDidLoadCalled_ShouldCallSetAttributeUnderlinedTitleWithSubtextOnEndGameButtonWithCorrectParameters() {
        // given
        let sut = viewController!
        sut.loadView()
        
        let endGameButton = UIButtonUnderlineButtonForButtonStatesMock()
        sut.endGameButton = endGameButton
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(endGameButton.underlineButtonForButtonStatesCalledCount, 1)
        XCTAssertEqual(endGameButton.underlineButtonForButtonStatesTitle, "End Game")
        XCTAssertEqual(endGameButton.underlineButtonForButtonStatesTextSize, 22)
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
        viewModelMock.playerToDelete.value = PlayerMock()
        
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
        let player = PlayerMock(name: playerName)
        
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
        viewModelMock.playerToDelete.value = PlayerMock()
        
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
        viewModelMock.playerToDelete.value = PlayerMock()
        
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
        viewModelMock.playerToDelete.value = PlayerMock()
        
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
        
        let player = PlayerMock()
        
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

    
    // MARK: - EndRoundButtonTapped
    
    func test_ScoreboardViewController_WhenEndRoundButtonTapped_ShouldCallViewModelShowEndRoundPopoverWithSelfAsViewController() {
        // given
        let sut = viewController!
        let viewModel = ScoreboardViewModelMock()
        sut.viewModel = viewModel
        
        // when
        sut.endRoundButtonTapped(0)
        
        // then
        XCTAssertEqual(viewModel.showEndRoundPopoverCalledCount, 1)
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
    

    // MARK: - HistoryButtonTapped
    
    func test_ScoreboardViewController_WhenHistoryButtonTappedCalled_ShouldCallViewModelShowGameHistory() {
        // given
        let sut = viewController!
        let viewModel = ScoreboardViewModelMock()
        sut.viewModel = viewModel
        
        // when
        sut.historyButtonTapped()
        
        // then
        XCTAssertEqual(viewModel.showGameHistoryCalledCount, 1)
    }
    
    
    // MARK: - SettingsButtonTapped
    
    func test_ScoreboardViewController_WhenSettingsButtonTapped_ShouldCallViewModelShowGameHistory() {
        // given
        let sut = viewController!
        let viewModel = ScoreboardViewModelMock()
        sut.viewModel = viewModel
        
        // when
        sut.settingsButtonTapped()
        
        // then
        XCTAssertEqual(viewModel.showGameSettingsCalledCount, 1)
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
    
    func test_ScoreboardViewController_WhenBindViewModelToViewCalled_ShouldGameNameLabelTextToGameNameLabel() {
        // given
        let sut = viewController!
        
        let gameName = UUID().uuidString
        let game = GameMock(name: gameName)
        sut.viewModel = ScoreboardViewModelMock(game: game)
        
        // when
        sut.loadView()
        sut.bindViewToViewModel(dispatchQueue: DispatchQueueMainMock())
        
        // then
        XCTAssertEqual(sut.gameNameLabel.text, gameName)
    }
    
    func test_ScoreboardViewController_WhenBindViewModelToViewCalled_ShouldSetAttributesForStrokeAndForegroundColorOnGameNameLabel() {
        // given
        let sut = viewController!
        
        let game = GameMock(name: UUID().uuidString)
        sut.viewModel = ScoreboardViewModelMock(game: game)
        
        // when
        sut.loadView()
        sut.bindViewToViewModel(dispatchQueue: DispatchQueueMainMock())
        
        // then
        let attributes = sut.gameNameLabel.attributedText?.attributes(at: 0, effectiveRange: nil)
        XCTAssertEqual(attributes?[.foregroundColor] as? UIColor, .white)
        XCTAssertEqual(attributes?[.strokeWidth] as? CGFloat, -4.0)
        XCTAssertEqual(attributes?[.strokeColor] as? UIColor, .black)
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
    
    func test_ScoreboardViewController_WhenViewModelBindViewModelToViewCalledEndGameNone_ShouldMakeProgressLabelHidden() {
        // given
        let sut = viewController!
        sut.loadView()
        sut.viewModel = ScoreboardViewModelMock()
        sut.viewModel?.game.gameEndType = .none
        sut.viewModel?.game.gameType = .round
        
        // when
        sut.bindViewToViewModel(dispatchQueue: DispatchQueueMainMock())
        
        // then
        XCTAssertTrue(sut.progressLabel.isHidden)
    }
    
    func test_ScoreboardViewController_WhenViewModelBindViewModelToViewCalledGameTypeBasic_ShouldMakeProgressLabelHidden() {
        // given
        let sut = viewController!
        sut.loadView()
        sut.viewModel = ScoreboardViewModelMock()
        sut.viewModel?.game.gameEndType = .round
        sut.viewModel?.game.gameType = .basic
        
        // when
        sut.bindViewToViewModel(dispatchQueue: DispatchQueueMainMock())
        
        // then
        XCTAssertTrue(sut.progressLabel.isHidden)
    }
    
    func test_ScoreboardViewController_WhenViewModelBindViewModelToViewCalledIsEndofGame_ShouldShowProgressLabelWithEmptyText() {
        // given
        let sut = viewController!
        sut.loadView()
        sut.viewModel = ScoreboardViewModelMock()
        let game = GameIsEndOfGameMock(gameType: .round, gameEndType: .round)
        game.isEndOfGameBool = true
        sut.viewModel?.game = game
        
        
        // when
        sut.bindViewToViewModel(dispatchQueue: DispatchQueueMainMock())
        
        // then
        XCTAssertFalse(sut.progressLabel.isHidden)
        XCTAssertEqual(sut.progressLabel.text, "")
    }
    
    func test_ScoreboardViewController_WhenViewModelBindViewModelToViewCalledEndGameNotNone_ShouldMakeProgressLabelNotHidden() {
        // given
        let sut = viewController!
        sut.loadView()
        sut.viewModel = ScoreboardViewModelMock()
        sut.viewModel?.game.gameEndType = .round
        sut.viewModel?.game.gameType = .round
        
        
        // when
        sut.bindViewToViewModel(dispatchQueue: DispatchQueueMainMock())
        
        // then
        XCTAssertFalse(sut.progressLabel.isHidden)
    }
    
    func test_ScoreboardViewController_WhenViewModelBindViewModelToViewCalledEndGameRoundMultipleRoundsLeft_ShouldSetProgressLabelTextToHowManyRoundsAreLeftMultiple() {
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
        XCTAssertEqual(sut.progressLabel.text, "\(numberOfRoundsLeft) rounds left!")
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
        XCTAssertEqual(sut.progressLabel.text, "Last round!")
    }
    
    func test_ScoreboardViewController_WhenViewModelBindViewModelToViewCalledEndGameScoreOneWinningPlayerSinglePoint_ShouldSetProgressLabelTextToPlayerNeeds1PtToWin() {
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
        XCTAssertEqual(sut.progressLabel.text, "\(playerName) needs 1 pt to win!")
    }
    
    func test_ScoreboardViewController_WhenViewModelBindViewModelToViewCalledEndGameScoreOneWinningPlayer_ShouldSetProgressLabelTextToPlayerNeedsxPtsToWin() {
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
        XCTAssertEqual(sut.progressLabel.text, "\(playerName) needs \(endingScore-topPlayerScore) pts to win!")
    }
    
    func test_ScoreboardViewController_WhenViewModelBindViewModelToViewCalledEndGameScoreMultipleWinningPlayers_ShouldSetProgresstLabelTextToMultiplePlayersNeedxPntsToWin() {
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
        XCTAssertEqual(sut.progressLabel.text, "Multiple players need \(endingScore-topPlayerScore) pts to win!")
    }
    
    func test_ScoreboardViewController_WhenViewModelBindViewModelToViewCalledIsEndOfGameTrue_ShouldHideProgressLabelAndSetRoundLabelToGameOver() {
        
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
        XCTAssertTrue(sut.progressLabel.isHidden)
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
