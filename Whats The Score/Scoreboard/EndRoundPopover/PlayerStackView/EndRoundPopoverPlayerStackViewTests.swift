//
//  EndRoundPopoverPlayerStackViewTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 2/19/24.
//

import XCTest
@testable import Whats_The_Score

final class EndRoundPopoverPlayerStackViewTests: XCTestCase {

    func test_EndRoundPopoverPlayerStackView_WhenInitialized_ShouldSetPropertiesAndTextFieldDelegate() {
        
        class UITextFieldDelegateMock: NSObject, UITextFieldDelegate { }
        
        // given
        let player = Player(name: "", position: 0)
        let textField = UITextField()
        let textFieldDelegate = UITextFieldDelegateMock()
        
        // when
        let sut = EndRoundPopoverPlayerStackView(player: player, textField: textField, textFieldDelegate: textFieldDelegate)
        
        // then
        XCTAssertEqual(sut.player, player)
        XCTAssertEqual(sut.textField, textField)
        XCTAssertEqual(sut.textFieldDelegate as? UITextFieldDelegateMock, textFieldDelegate)
        XCTAssertTrue(sut.textField.delegate is UITextFieldDelegateMock)
    }
    
    func test_EndRoundPopoverPlayerStackView_WhenInitialized_ShouldSetItsAxisAsHorizontalAndSpacingAs5() {
        
        class UITextFieldDelegateMock: NSObject, UITextFieldDelegate { }
        
        // given
        let player = Player(name: "", position: 0)
        let textField = UITextField()
        let textFieldDelegate = UITextFieldDelegateMock()
        
        // when
        let sut = EndRoundPopoverPlayerStackView(player: player, textField: textField, textFieldDelegate: textFieldDelegate)
        
        // then
        XCTAssertEqual(sut.axis, .horizontal)
        XCTAssertEqual(sut.spacing, 5)
    }
    
    
}
