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
        
        // given
        let playerName = UUID().uuidString
        let playerID = UUID()
        
        let textField = UITextField()
        let textFieldDelegate = UITextFieldDelegateMock()
        
        // when
        let sut = EndRoundPopoverPlayerStackView(playerName: playerName, playerID: playerID, textField: textField, textFieldDelegate: textFieldDelegate)
        
        // then
        XCTAssertEqual(sut.playerName, playerName)
        XCTAssertEqual(sut.playerID, playerID)
        XCTAssertEqual(sut.textField, textField)
        XCTAssertEqual(sut.textFieldDelegate as? UITextFieldDelegateMock, textFieldDelegate)
        XCTAssertTrue(sut.textField.delegate is UITextFieldDelegateMock)
    }
    
    func test_EndRoundPopoverPlayerStackView_WhenInitialized_ShouldSetItsAxisAsHorizontalAndSpacingAs5AndAlignmentCenter() {
        
        // given
        let textField = UITextField()
        let textFieldDelegate = UITextFieldDelegateMock()
        
        // when
        let sut = EndRoundPopoverPlayerStackView(playerName: "", playerID: UUID(), textField: textField, textFieldDelegate: textFieldDelegate)
        
        // then
        XCTAssertEqual(sut.axis, .horizontal)
        XCTAssertEqual(sut.spacing, 5)
        XCTAssertEqual(sut.alignment, .center)
    }
    
    func test_EndRoundPopoverPlayerStackView_WhenInitialized_ShouldAddTextFieldAndLabelInCorrectOrder() {
        // given
        let textField = UITextField()
        let textFieldDelegate = UITextFieldDelegateMock()
        
        // when
        let sut = EndRoundPopoverPlayerStackView(playerName: "", playerID: UUID(), textField: textField, textFieldDelegate: textFieldDelegate)
        
        // then
        XCTAssertTrue(sut.subviews.first is UILabel)
        XCTAssertEqual(sut.subviews.last, textField)
    }
    
    func test_EndRoundPopoverPlayerStackView_WhenInitialized_ShouldSetLabelTexttoPlayerName() {
        // given
        let playerName = UUID().uuidString
        let textField = UITextField()
        let textFieldDelegate = UITextFieldDelegateMock()
        
        // when
        let sut = EndRoundPopoverPlayerStackView(playerName: playerName, playerID: UUID(), textField: textField, textFieldDelegate: textFieldDelegate)
        
        // then
        XCTAssertEqual((sut.subviews.first as? UILabel)?.text, playerName)
    }
    
    func test_EndRoundPopoverPlayerStackView_WhenInitialized_ShouldSetLabelFontToPressPlay2PSize15WithWhiteText() {
        // given
        let textField = UITextField()
        let textFieldDelegate = UITextFieldDelegateMock()
        
        
        // when
        let sut = EndRoundPopoverPlayerStackView(playerName: "", playerID: UUID(), textField: textField, textFieldDelegate: textFieldDelegate)
        
        // then
        let label = sut.subviews.first as? UILabel
        XCTAssertEqual(label?.font, UIFont(name: "Press Start 2P Regular", size: 15))
        XCTAssertEqual(label?.textColor, .textColor)
    }
    
    func test_EndRoundPopoverPlayerStackView_WhenInitialized_ShouldSetCorrectPropertiesOnTextField() {
        // given
        let textField = UITextField()
        let textFieldDelegate = UITextFieldDelegateMock()
        
        // when
        let sut = EndRoundPopoverPlayerStackView(playerName: "", playerID: UUID(), textField: textField, textFieldDelegate: textFieldDelegate)
        
        // then
        XCTAssertEqual(textField.borderStyle, .roundedRect)
        XCTAssertEqual(textField.placeholder, "0")
        XCTAssertEqual(textField.keyboardType, .numberPad)
    }
    
    func test_EndRoundPopoverPlayerStackView_WhenInitialized_ShouldSetWidthConstraintForTextField() {
        // given
        let textField = UITextField()
        let textFieldDelegate = UITextFieldDelegateMock()
        
        // when
        _ = EndRoundPopoverPlayerStackView(playerName: "", playerID: UUID(), textField: textField, textFieldDelegate: textFieldDelegate)
        
        // then
        let constraints = textField.constraints
        
        guard constraints.contains(where: { constraint in
            constraint.firstAttribute == .width &&
            constraint.constant == 100
        }) else {
            XCTFail("TextField should have a width set")
            return
        }
    }
}
