//
//  GameNameViewControllerTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 4/12/24.
//

import XCTest
@testable import Whats_The_Score

final class GameNameViewControllerTests: XCTestCase {

    // MARK: - Setup

    var viewController: GameNameViewController!
    
    override func setUp() {
        viewController = GameNameViewController.instantiate()
    }
    
    override func tearDown() {
        viewController = nil
    }

    
    // MARK: - Go Button Tapped
    
    func test_GameNameViewController_WhenGoButtonTapped_ShouldCallCoordinatorGameNameSet() {
        // given
        let sut = viewController!
        
        let name = UUID().uuidString
        
        let textField = UITextField()
        textField.text = name
        sut.nameTextField = textField
        
        let coordinator = GameSetupCoordinatorMock()
        sut.coordinator = coordinator
        
        // when
        sut.goButtonTapped(0)
        
        // then
        XCTAssertEqual(coordinator.gameNameSetCalledCount, 1)
        XCTAssertEqual(coordinator.gameNameSetName, name)
    }
}
