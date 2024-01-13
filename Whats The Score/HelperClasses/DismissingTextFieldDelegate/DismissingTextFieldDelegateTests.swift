//
//  DismissingTextFieldDelegateTests.swift
//  What's The Score Tests
//
//  Created by Curt McCune on 1/10/24.
//

import XCTest
@testable import Whats_The_Score

final class DismissingTextFieldDelegateTests: XCTestCase {

    func test_DismissingTextFieldDelegate_WhenTextFieldShouldReturnCalled_ShouldCallResignFirstResponderOnTextFieldAndReturnFalse() {
        //given
        let sut = DismissingTextFieldDelegate()
        let textFieldMock = UITextFieldShouldReturnMock()
        
        //when
        let _ = sut.textFieldShouldReturn(textFieldMock)
        
        //then
        XCTAssertEqual(textFieldMock.resignFirstResponderCalledCount, 1)
    }
    
    class UITextFieldShouldReturnMock: UITextField {
        var resignFirstResponderCalledCount = 0
        override func resignFirstResponder() -> Bool {
            resignFirstResponderCalledCount += 1
            return true
        }
    }

}
