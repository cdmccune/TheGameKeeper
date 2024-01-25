//
//  ObservableTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 1/25/24.
//

import XCTest
@testable import Whats_The_Score

final class ObservableTests: XCTestCase {

    func test_Observable_WhenValueChanged_ShouldSetNewValue() {
        // given
        let sut = Observable(0)
        let newValue = Int.random(in: 1...10)
        
        // when
        sut.value = newValue
        
        // then
        XCTAssertEqual(sut.value, newValue)
    }

    func test_Observable_WhenValueChanged_ShouldCallValueChangedFunction() {
        // given
        let sut = Observable(0)
        let newValue = Int.random(in: 1...10)
        let expectation = XCTestExpectation(description: "Value changed should be called")
        
        sut.valueChanged = { value in
            expectation.fulfill()
            XCTAssertEqual(value, newValue)
        }
        
        // when
        sut.value = newValue
        
        // then
        wait(for: [expectation])
    }
}
