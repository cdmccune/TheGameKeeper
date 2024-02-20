//
//  StackViewTextFieldDelegateTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 2/19/24.
//

import XCTest
@testable import Whats_The_Score

final class StackViewTextFieldDelegateTests: XCTestCase {

    func test_StackViewTextFieldDelegate_WhenTextFieldDidBeginEditing_ShouldCallDelegateTextFieldEditingBeganWithTextFieldTag() {
        // given
        let delegate = StackViewTextFieldDelegateDelegateMock()
        let sut = StackViewTextFieldDelegate(delegate: delegate)
        
        let index = Int.random(in: 1...1000)
        let textField = UITextField()
        textField.tag = index
        
        // when
        sut.textFieldDidBeginEditing(textField)
        
        // then
        XCTAssertEqual(delegate.textFieldEditingBeganIndex, index)
        XCTAssertEqual(delegate.textFieldEditingBeganCalledCount, 1)
    }

}

class StackViewTextFieldDelegateDelegateMock: NSObject, StackViewTextFieldDelegateDelegateProtocol {
    var textFieldEditingBeganCalledCount = 0
    var textFieldEditingBeganIndex: Int?
    func textFieldEditingBegan(index: Int) {
        textFieldEditingBeganCalledCount += 1
        textFieldEditingBeganIndex = index
    }
    
    var textFieldShouldReturnCalledCount = 0
    var textFieldShouldReturnIndex: Int?
    func textFieldShouldReturn(for index: Int) {
        textFieldShouldReturnCalledCount += 1
        textFieldShouldReturnIndex = index
    }
    
    var textFieldValueChangedCalledCount = 0
    var textFieldValueChangedIndex: Int?
    var textFieldValueChangedNewValue: String?
    func textFieldValueChanged(forIndex index: Int, to newValue: String?) {
        textFieldValueChangedCalledCount += 1
        textFieldValueChangedIndex = index
        textFieldValueChangedNewValue = newValue
    }
    
    
}
