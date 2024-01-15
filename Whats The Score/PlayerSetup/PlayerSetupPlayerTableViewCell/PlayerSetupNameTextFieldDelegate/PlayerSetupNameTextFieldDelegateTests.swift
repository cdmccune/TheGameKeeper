//
//  PlayerSetupNameTextFieldDelegateTests.swift
//  What's The Score Tests
//
//  Created by Curt McCune on 1/11/24.
//

import XCTest
@testable import Whats_The_Score

final class PlayerSetupNameTextFieldDelegateTests: XCTestCase {

    func test_PlayerSetupNameTextFieldDelegate_WhenTextFieldDidBeginEditingHasDefaultNameTrue_ShouldDeleteTextFieldsText() {
        // given
        let sut = PlayerSetupNameTextFieldDelegate()
        sut.hasDefaultName = true
        let textField = UITextField()
        textField.text = UUID().uuidString
        
        // when
        sut.textFieldDidBeginEditing(textField)
        
        // then
        XCTAssertEqual(textField.text, "")
    }
    
    func test_PlayerSetupNameTextFieldDelegate_WhenTextFieldDidBeginEditingHasDefaultNameFalse_ShouldNotDeleteTextFieldsText() {
        // given
        let sut = PlayerSetupNameTextFieldDelegate()
        sut.hasDefaultName = false
        let textField = UITextField()
        let text = UUID().uuidString
        textField.text = text
        
        // when
        sut.textFieldDidBeginEditing(textField)
        
        // then
        XCTAssertEqual(textField.text, text)
    }

}
