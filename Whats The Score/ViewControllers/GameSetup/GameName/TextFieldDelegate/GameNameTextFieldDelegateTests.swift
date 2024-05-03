//
//  GameNameTextFieldDelegateTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 4/18/24.
//

import XCTest
@testable import Whats_The_Score

final class GameNameTextFieldDelegateTests: XCTestCase {

    // MARK: - TextFieldShouldReturn
    
    func test_GameNameTextFieldDelegate_WhenTextFieldShouldReturnCalledBlankString_ShouldReturnFalseAndNotCallCoordinatorGameNameSet() {
        // given
        let coordinator = GameSetupCoordinatorMock()
        let sut = GameNameTextFieldDelegate(coordinator: coordinator)
        
        let textField = UITextField()
        textField.text = ""
        
        // when
        let shouldReturn = sut.textFieldShouldReturn(textField)
        
        // then
        XCTAssertFalse(shouldReturn)
        XCTAssertEqual(coordinator.gameNameSetCalledCount, 0)
    }
    
    func test_GameNameTextFieldDelegate_WhenTextFieldShouldReturnCalledNonBlankString_ShouldReturnTrueAndNotCallCoordinatorGameNameSet() {
        // given
        let coordinator = GameSetupCoordinatorMock()
        let sut = GameNameTextFieldDelegate(coordinator: coordinator)
        
        let textField = UITextField()
        textField.text = "1"
        
        // when
        let shouldReturn = sut.textFieldShouldReturn(textField)
        
        // then
        XCTAssertTrue(shouldReturn)
        XCTAssertEqual(coordinator.gameNameSetCalledCount, 1)
    }

}
