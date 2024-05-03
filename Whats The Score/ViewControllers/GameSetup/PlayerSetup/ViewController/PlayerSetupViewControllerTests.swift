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
    
    
    // MARK: - ViewDidLoad
    
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
        XCTAssertNotNil(sut.instructionLabel)
        XCTAssertNotNil(sut.randomizeButton)
        XCTAssertNotNil(sut.playerTableView)
        XCTAssertNotNil(sut.addPlayerButton)
        XCTAssertNotNil(sut.startGameButton)
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
    
    func test_PlayerSetupViewController_WhenViewDidLoadCalled_ShouldRegisterNibsForPlayerTableView() {
        // given
        let sut = viewController!
        let tableViewDelegateMock = TableViewDelegateMock(cellIdentifier: "PlayerSetupPlayerTableViewCell")
        sut.loadView()
        
        // when
        sut.viewDidLoad()
        let cell = tableViewDelegateMock.tableView(sut.playerTableView, cellForRowAt: IndexPath(row: 0, section: 0))
        
        // then
        XCTAssertTrue(cell is PlayerSetupPlayerTableViewCell)
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
    
    func test_PlayerSetupViewController_WhenViewDidLoadCalled_ShouldSetCorrectStrokeOnTitleLabel() {
        // given
        let sut = viewController!
        sut.loadView()
        
        // when
        sut.viewDidLoad()
        
        // then
        let attributedString = sut.titleLabel.attributedText
        XCTAssertEqual(attributedString?.string, "Players")
        XCTAssertEqual(attributedString?.attributes(at: 0, effectiveRange: nil)[NSAttributedString.Key.strokeWidth] as? CGFloat, -4.0)
        XCTAssertEqual(attributedString?.attributes(at: 0, effectiveRange: nil)[NSAttributedString.Key.strokeColor] as? UIColor, .black)
    }
    
    func test_PlayerSetupViewController_WhenViewDidLoadCalled_ShouldCall() {
        // given
        let sut = viewController!
        sut.loadView()
        
        // when
        sut.viewDidLoad()
        
        // then
        let attributedString = sut.titleLabel.attributedText
        XCTAssertEqual(attributedString?.string, "Players")
        XCTAssertEqual(attributedString?.attributes(at: 0, effectiveRange: nil)[NSAttributedString.Key.strokeWidth] as? CGFloat, -4.0)
        XCTAssertEqual(attributedString?.attributes(at: 0, effectiveRange: nil)[NSAttributedString.Key.strokeColor] as? UIColor, .black)
    }
    
    
    // MARK: - Add Player
    
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
    
    
    // MARK: - Randomize
    
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
    
    // MARK: - StartButtonTapped
    
    func test_PlayerSetupViewController_WhenStartBarButtonTappedCalled_ShouldCallViewModelPlayersSetup() {
        // given
        let viewModel = PlayerSetupViewModelMock()
        let sut = viewController!
        
        sut.viewModel = viewModel
        
        // when
        sut.startButtonTapped(0)
        
        // then
        XCTAssertEqual(viewModel.playersSetupCalledCount, 1)
    }
    
    
    // MARK: - BindViewToViewModel
    
    func test_PlayerSetupViewContrller_WhenBindViewToViewModelCalled1Player_ShouldSetInstructionLabelTextToYouMustAddAtLeast2Players() {
        // given
        let sut = viewController!
        sut.loadView()
        let viewModel = PlayerSetupViewModelMock()
        viewModel.players = [PlayerSettings.getStub()]
        sut.viewModel = viewModel
        viewModel.delegate = sut
        
        sut.instructionLabel.text = ""
        
        // when
        viewModel.delegate?.bindViewToViewModel(dispatchQueue: DispatchQueueMainMock())
        
        // then
        XCTAssertEqual(sut.instructionLabel.text, "You must add at least 2 players!")
    }
    
    func test_PlayerSetupViewContrller_WhenBindViewToViewModelCalled1Player_ShouldHideRandomizeButtonAndDisableStartButton() {
        // given
        let sut = viewController!
        sut.loadView()
        let viewModel = PlayerSetupViewModelMock()
        viewModel.players = [PlayerSettings.getStub()]
        sut.viewModel = viewModel
        viewModel.delegate = sut
        
        sut.randomizeButton.isHidden = false
        sut.startGameButton.isEnabled = true
        
        // when
        viewModel.delegate?.bindViewToViewModel(dispatchQueue: DispatchQueueMainMock())
        
        // then
        XCTAssertTrue(sut.randomizeButton.isHidden)
        XCTAssertFalse(sut.startGameButton.isEnabled)
    }
    
    func test_PlayerSetupViewcontroller_WhenBindViewToViewModelCalled2Players_ShouldSetInstructionLabelToTapHoldAndDragPlayersToReorder() {
        // given
        let sut = viewController!
        sut.loadView()
        let viewModel = PlayerSetupViewModelMock()
        viewModel.players = [PlayerSettings.getStub(), PlayerSettings.getStub()]
        sut.viewModel = viewModel
        viewModel.delegate = sut
        
        sut.instructionLabel.text = ""
        
        // when
        viewModel.delegate?.bindViewToViewModel(dispatchQueue: DispatchQueueMainMock())
        
        // then
        XCTAssertEqual(sut.instructionLabel.text, "Tap, hold then drag players to reorder!")
    }
    
    func test_PlayerSetupViewContrller_WhenBindViewToViewModelCalled2Players_ShouldShowRandomizeButtonAndEnableStartButton() {
        // given
        let sut = viewController!
        sut.loadView()
        let viewModel = PlayerSetupViewModelMock()
        viewModel.players = [PlayerSettings.getStub(), PlayerSettings.getStub()]
        sut.viewModel = viewModel
        viewModel.delegate = sut
        
        sut.randomizeButton.isHidden = true
        sut.startGameButton.isEnabled = false
        
        // when
        viewModel.delegate?.bindViewToViewModel(dispatchQueue: DispatchQueueMainMock())
        
        // then
        XCTAssertFalse(sut.randomizeButton.isHidden)
        XCTAssertTrue(sut.startGameButton.isEnabled)
    }
    
}
