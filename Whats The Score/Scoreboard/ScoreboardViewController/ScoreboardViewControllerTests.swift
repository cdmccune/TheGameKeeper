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
}