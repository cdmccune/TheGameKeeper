//
//  StackViewTextFieldTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 2/19/24.
//

import XCTest
@testable import Whats_The_Score

final class StackViewTextFieldTests: XCTestCase {
    
    // MARK: - Initialization
    
    func test_StackViewTextField_WhenInitialized_ShouldSetActionDelegateAndIndex() {
        // given
        let index = Int.random(in: 1...1000)
        let actionDelegate = StackViewTextFieldDelegateDelegateMock()
        
        // when
        let sut = StackViewTextField(delegate: actionDelegate, isLast: true, index: index)
        
        // then
        XCTAssertEqual(sut.index, index)
        XCTAssertTrue(sut.actionDelegate is StackViewTextFieldDelegateDelegateMock)
    }
    
    // MARK: - Toolbar
    
    func test_StackViewTextField_WhenInitialized_ShouldSetFirstItemInToolbarAsBlankItem() {
        // given
        // when
        let sut = StackViewTextField(delegate: StackViewTextFieldDelegateDelegateMock(), isLast: true, index: 0)
        
        // then
        let toolbar = sut.inputAccessoryView as? UIToolbar
        XCTAssertNil(toolbar?.items?.first?.title)
        XCTAssertNil(toolbar?.items?.first?.action)
        XCTAssertNil(toolbar?.items?.first?.target)
    }
    
    func test_StackViewTextField_WhenInitializedIsLast_ShouldSetToolBarActionAsDone() {
        // given
        // when
        let sut = StackViewTextField(delegate: StackViewTextFieldDelegateDelegateMock(), isLast: true, index: Int.random(in: 1...1000))
        
        // then
        let toolbar = sut.inputAccessoryView as? UIToolbar
        XCTAssertNotNil(toolbar)
        XCTAssertEqual(toolbar?.items?.last?.title, "Done")
    }
    
    func test_StackViewTextField_WhenInitializedIsLastFalse_ShouldSetToolBarActionAsNext() {
        // given
        // when
        let sut = StackViewTextField(delegate: StackViewTextFieldDelegateDelegateMock(), isLast: false, index: Int.random(in: 1...1000))
        
        // then
        let toolbar = sut.inputAccessoryView as? UIToolbar
        XCTAssertNotNil(toolbar)
        XCTAssertEqual(toolbar?.items?.last?.title, "Next")
    }
    
    func test_StackViewTextField_WhenInitializedAndToolbarActionTriggered_ShouldCallActionDelegateTextFieldShouldReturnWithIndex() {
        // given
        let index = Int.random(in: 1...1000)
        let actionDelegate = StackViewTextFieldDelegateDelegateMock()
        
        // when
        let sut = StackViewTextField(delegate: actionDelegate, isLast: true, index: index)
        let toolbar = sut.inputAccessoryView as? UIToolbar
        sut.sendAction(toolbar!.items!.last!.action!, to: sut, for: nil)
        
        // then
        XCTAssertEqual(actionDelegate.textFieldShouldReturnCalledCount, 1)
        XCTAssertEqual(actionDelegate.textFieldShouldReturnIndex, index)
    }
    
    
    // MARK: - Editing Changed
    
    func test_StackViewTextField_WhenInitialized_ShouldSetTargetForEditingChangedToCallActionDelegateTextFieldValueChangedWithText() {
        // given
        let index = Int.random(in: 1...1000)
        let actionDelegate = StackViewTextFieldDelegateDelegateMock()
        let newTextValue = UUID().uuidString
        
        // when
        let sut = StackViewTextField(delegate: actionDelegate, isLast: true, index: index)
        sut.text = newTextValue
        sut.sendActions(for: .editingChanged)
        
        // then
        XCTAssertEqual(actionDelegate.textFieldValueChangedCalledCount, 1)
        XCTAssertEqual(actionDelegate.textFieldValueChangedNewValue, newTextValue)
        XCTAssertEqual(actionDelegate.textFieldValueChangedIndex, index)
    }
}
