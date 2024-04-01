//
//  EndGameViewControllerTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 3/1/24.
//

import XCTest
@testable import Whats_The_Score

final class EndGameViewControllerTests: XCTestCase {

    // MARK: - Setup
    
    var viewController: EndGameViewController!
    var views: [UIView]?

    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "EndGameViewController") as? EndGameViewController else {
            fatalError("EndGameViewController wasn't found")
        }
        self.viewController = viewController
    }
    
    override func tearDown() {
        viewController = nil
    }
    
    
    // MARK: - Initialization
    
    func test_EndGameViewController_WhenViewLoaded_ShouldHaveNonNilOutlets() {
        // given
        let sut = viewController!
        
        // when
        sut.loadView()
        
        // then
        XCTAssertNotNil(sut.tableView)
    }
    
    
    // MARK: - ViewDidLoad
    
    func test_EndGameViewController_WhenViewDidLoadCalled_ShouldSetTableViewDelegateDatasourceToEndGamePlayerTableViewDelegate() {
        // given
        let sut = viewController!
        sut.loadView()
        sut.viewModel = EndGameViewModelMock()
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertTrue(sut.tableView.delegate is EndGamePlayerTableViewDelegate)
        XCTAssertTrue(sut.tableView.dataSource is EndGamePlayerTableViewDelegate)
    }
    
    func test_EndGameViewController_WhenViewDidLoadCalled_ShouldSetTableViewDelegateViewModelAsViewModel() {
        // given
        let sut = viewController!
        let viewModelMock = EndGameViewModelMock()
        sut.viewModel = viewModelMock
        sut.loadView()
        
        // when
        sut.viewDidLoad()
        
        // then
        let tableViewDelegate = sut.tableView.delegate as? EndGamePlayerTableViewDelegate
        XCTAssertTrue((tableViewDelegate?.viewModel as? EndGameViewModelMock) === viewModelMock)
    }
    
    func test_EndGameViewController_WhenViewDidLoadCalled_ShouldSetCollectionViewDelegateDatasourceToEndGamePlayerCollectionViewDelegate() {
        // given
        let sut = viewController!
        sut.loadView()
        sut.viewModel = EndGameViewModelMock()
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertTrue(sut.collectionView.delegate is EndGamePlayerCollectionViewDelegate)
        XCTAssertTrue(sut.collectionView.dataSource is EndGamePlayerCollectionViewDelegate)
    }
    
    func test_EndGameViewController_WhenViewDidLoadCalled_ShouldSetCollectionViewDelegateViewModelAsViewModel() {
        // given
        let sut = viewController!
        let viewModelMock = EndGameViewModelMock()
        sut.viewModel = viewModelMock
        sut.loadView()
        
        // when
        sut.viewDidLoad()
        
        // then
        let collectionViewDelegate = sut.collectionView.delegate as? EndGamePlayerCollectionViewDelegate
        XCTAssertTrue((collectionViewDelegate?.viewModel as? EndGameViewModelMock) === viewModelMock)
    }
    
    func test_EndGameViewController_WhenViewDidLoadCalled_ShouldRegisterEndGamePlayerTableViewCellInTableView() {
        // given
        let sut = viewController!
        let viewModelMock = EndGameViewModelMock()
        sut.viewModel = viewModelMock
        
        
        // when
        sut.loadView()
        sut.viewDidLoad()
        
        // then
        let cell = sut.tableView.dequeueReusableCell(withIdentifier: "EndGamePlayerTableViewCell")
        
        XCTAssertTrue(cell is EndGamePlayerTableViewCell)
    }
    
    func test_EndGameViewController_WhenViewDidLoadCalled_ShouldRegisterEndGamePlayerCollectionViewCellInCollectionView() {
        // given
        let sut = viewController!
        let viewModelMock = EndGameViewModelMock()
        sut.viewModel = viewModelMock
        
        
        // when
        sut.loadView()
        sut.viewDidLoad()
        
        // then
        let cell = sut.collectionView.dequeueReusableCell(withReuseIdentifier: "EndGamePlayerCollectionViewCell", for: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(cell is EndGamePlayerCollectionViewCell)
    }
    
    func test_EndGameViewController_WhenViewDidLoadCalledWinningPlayersCellWidthLessThanScreenWidth_ShouldSetCollectionViewWidthEqualTo128XCountPlus25XCountMinus1() {
        // given
        let sut = viewController!
        
        let numberOfPlayers = Int.random(in: 1...10)
        let players = Array(repeating: Player(name: "", position: 0), count: numberOfPlayers)
        
        let numberOfPlayersCGFloat = CGFloat(numberOfPlayers)
        let expectedCollectionViewWidth: CGFloat = (128 * numberOfPlayersCGFloat) + (25 * (numberOfPlayersCGFloat - 1))
        
        let screenWidth: CGFloat = expectedCollectionViewWidth + 1
        sut.screenWidth = screenWidth
        
        let viewModel = EndGameViewModelMock()
        var game = GameMock()
        game.winningPlayers = players
        viewModel.game = game
        sut.viewModel = viewModel
        
        // when
        sut.loadView()
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(sut.collectionViewWidth.constant, expectedCollectionViewWidth)
    }
    
    func test_EndGameViewController_WhenViewDidLoadCalledWinningPlayersCellWidthMoreThanScreenWidth_ShouldSetCollectionViewWidthEqualToScreenWidth() {
        // given
        let sut = viewController!
        
        let players = Array(repeating: Player(name: "", position: 0), count: 1000)
        
        let screenWidth: CGFloat = CGFloat.random(in: 1...999)
        sut.screenWidth = screenWidth
        
        let viewModel = EndGameViewModelMock()
        var game = GameMock()
        game.winningPlayers = players
        viewModel.game = game
        sut.viewModel = viewModel
        
        // when
        sut.loadView()
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(sut.collectionViewWidth.constant, screenWidth)
    }
    
    
    // MARK: - NewGameButtonTapped
    
    func test_EndGameViewController_WhenNewGameButtonTapped_ShouldSetGameSetupViewControllerAsRootViewController() {
        // given
        let sut = viewController!
        
        let navigationController = NavigationControllerPushMock()
        navigationController.viewControllers = [sut]
        
        // when
        sut.newGameButtonTapped(0)
        
        // then
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        XCTAssertTrue(navigationController.viewControllers.first is GameSetupViewController)
    }
    
    // MARK: - keepPlayingButtonTapped
    
    func test_EndGameViewController_WhenKeepPlayingButtonTapped_ShouldCallCoordinatorGoToScoreboardWithGame() {
        // given
        let sut = viewController!
        
        let coordinator = GameTabCoordinatorMock()
        sut.coordinator = coordinator
        
        let game = GameMock()
        sut.viewModel = EndGameViewModel(game: game)
        
        // when
        sut.keepPlayingGameButtonTapped(0)
        
        // then
        XCTAssertEqual(coordinator.goToScoreboardCalledCount, 1)
        XCTAssertTrue(coordinator.goToScoreboardGame?.isEqualTo(game: game) ?? false)
    }
}
