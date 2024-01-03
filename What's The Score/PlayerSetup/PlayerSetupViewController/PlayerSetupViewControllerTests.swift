//
//  PlayerSetupViewControllerTests.swift
//  What's The Score Tests
//
//  Created by Curt McCune on 1/2/24.
//

import XCTest
@testable import What_s_The_Score

final class PlayerSetupViewControllerTests: XCTestCase {
    
    var viewController: PlayerSetupViewController!
    
    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "PlayerSetupViewController") as! PlayerSetupViewController
        viewController = VC
    }
    
    override func tearDown() {
        viewController = nil
    }
    
    
    //MARK: - Initialization
    
    func getBasicViewModel() -> PlayerSetupViewModel {
        let emptyGameSettings = GameSettings(gameType: .basic,
                                             gameEndType: .round,
                                             numberOfRounds: 0,
                                             numberOfPlayers: 0)
        return PlayerSetupViewModel(gameSettings: emptyGameSettings)
    }
    
    func test_PlayerSetupViewController_WhenLoaded_ShouldHaveNonNilOutlets() {
        //given
        let sut = viewController!
        
        //when
        viewController.loadView()
        
        //then
        XCTAssertNotNil(sut.titleLabel)
        XCTAssertNotNil(sut.randomizeButton)
        XCTAssertNotNil(sut.playerTableView)
        XCTAssertNotNil(sut.positionTableView)
    }
    
    func test_PlayerSetupViewController_WhenViewDidLoadCalled_ShouldSetPlayerTableViewDelegateAndDataSource() {
        //given
        let sut = viewController!
        sut.viewModel = getBasicViewModel()

        //when
        sut.loadView()
        sut.viewDidLoad()
        
        //then
        XCTAssertTrue(sut.playerTableView.delegate is PlayerSetupPlayerTableViewDelegate)
        XCTAssertTrue(sut.playerTableView.dataSource is PlayerSetupPlayerTableViewDelegate)
    }
    
    func test_PlayerSetupViewController_WhenViewDidLoadCalled_ShouldSetPositionTableViewDelegateAndDataSource() {
        //given
        let sut = viewController!
        sut.viewModel = getBasicViewModel()

        //when
        sut.loadView()
        sut.viewDidLoad()
        
        //then
        XCTAssertTrue(sut.positionTableView.delegate is PlayerSetupPositionTableViewDelegate)
        XCTAssertTrue(sut.positionTableView.dataSource is PlayerSetupPositionTableViewDelegate)
    }
    
    func test_PlayerSetupViewController_WhenViewDidLoadCalled_ShouldSetSelfAsViewModelsDelegate() {
        //given
        let sut = viewController!
        sut.viewModel = getBasicViewModel()
        
        //when
        sut.loadView()
        sut.viewDidLoad()
        
        //then
        XCTAssertTrue(sut.viewModel?.delegate is PlayerSetupViewController)
    }
    

}
