//
//  GameEndQuantitySelectionViewControllerTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 4/1/24.
//

import XCTest
@testable import Whats_The_Score

final class GameEndQuantitySelectionViewControllerTests: XCTestCase {
    
    // MARK: - Setup

    var viewController: GameEndQuantitySelectionViewController!
    
    override func setUp() {
        viewController = GameEndQuantitySelectionViewController.instantiate()
    }
    
    override func tearDown() {
        viewController = nil
    }
    
    
    // MARK: - Go Button Tapped
    
    func test_GameEndQuantitySelectionViewController_WhenGoButtonTapped_ShouldCallCoordinatorgameEndQuantitySelectedWithGameEndQuantityTextFieldTextAsInt() {
        // given
        let sut = viewController!
        
        let score = Int.random(in: 1...1000)
        
        let textField = UITextField()
        textField.text = String(score)
        sut.gameEndQuantityTextField = textField
        
        let coordinator = GameSetupCoordinatorMock()
        sut.coordinator = coordinator
        
        // when
        sut.goButtonTapped(0)
        
        // then
        XCTAssertEqual(coordinator.gameEndQuantityCalledCount, 1)
        XCTAssertEqual(coordinator.gameEndQuantity, score)
    }

}
