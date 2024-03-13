//
//  EndRoundPopoverTextFieldTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 3/11/24.
//

import XCTest
@testable import Whats_The_Score

final class EndRoundPopoverTextFieldTests: XCTestCase {

    // MARK: - Initialization
    
    func test_EndRoundPopoverTextField_WhenInitialized_ShouldHaveThreeToolbarItemsAndSetSecondToolbarButtonAsPlusMinusButton() {
        // given
        
        let delegate = StackViewTextFieldDelegateDelegateMock()
        
        // when
        let sut = EndRoundPopoverTextField(delegate: delegate, isLast: false, index: 0)
        
        
        // then
        let toolbar = sut.inputAccessoryView as? UIToolbar
        XCTAssertEqual(toolbar?.items?.count, 3)
        XCTAssertEqual(toolbar?.items?[1].image, UIImage(systemName: "plus.forwardslash.minus")!)
    }
    

    // MARK: - PlusNegativeActionTriggered
    
    func test_EndRoundPopoverTextField_WhenPlusNegativeActionTriggeredTextIsPositiveInt_ShouldMakeNumberNegative() {
        // given
        let delegate = StackViewTextFieldDelegateDelegateMock()
        let sut = EndRoundPopoverTextField(delegate: delegate, isLast: false, index: 0)
        
        let numberToUse = Int.random(in: 1...1000)
        sut.text = String(numberToUse)
        
        // when
        let toolbar = sut.inputAccessoryView as? UIToolbar
        sut.sendAction(toolbar!.items![1].action!, to: sut, for: nil)
        
        // then
        XCTAssertEqual("-\(String(numberToUse))", sut.text)
    }
    
    func test_EndRoundPopoverTextField_WhenPlusNegativeActionTriggeredTextIsNegativeInt_ShouldMakeNumberPositive() {
        // given
        let delegate = StackViewTextFieldDelegateDelegateMock()
        let sut = EndRoundPopoverTextField(delegate: delegate, isLast: false, index: 0)
        
        let numberToUse = Int.random(in: (-1000)...(-1))
        sut.text = String(numberToUse)
        
        // when
        let toolbar = sut.inputAccessoryView as? UIToolbar
        sut.sendAction(toolbar!.items![1].action!, to: sut, for: nil)
        
        // then
        var numberToUseWithoutNegative = String(numberToUse)
        numberToUseWithoutNegative.removeFirst()
        XCTAssertEqual(numberToUseWithoutNegative, sut.text)
    }
    
    func test_EndRoundPopoverTextField_WhenPlusNegativeActionTriggered_ShouldTriggerTextFieldActionForEditingChanged() {
        
        class EndRoundPopoverTextFieldTextFieldDidChangeMock: EndRoundPopoverTextField {
            var textFieldDidChangeCalledCount = 0
            override func textFieldDidChange() {
                textFieldDidChangeCalledCount += 1
            }
        }
        
        // given
        let delegate = StackViewTextFieldDelegateDelegateMock()
        let sut = EndRoundPopoverTextFieldTextFieldDidChangeMock(delegate: delegate, isLast: false, index: 0)
        
        // when
        let toolbar = sut.inputAccessoryView as? UIToolbar
        sut.sendAction(toolbar!.items![1].action!, to: sut, for: nil)
        
        // then
        XCTAssertEqual(sut.textFieldDidChangeCalledCount, 1)
    }

}
