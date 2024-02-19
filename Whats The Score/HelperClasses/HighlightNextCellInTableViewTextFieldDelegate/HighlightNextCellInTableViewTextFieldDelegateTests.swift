//
//  HighlightNextCellInTableViewTextFieldDelegateTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 2/19/24.
//

import XCTest
@testable import Whats_The_Score

final class HighlightNextCellInTableViewTextFieldDelegateTests: XCTestCase {
    
    func test_HighlightNextCellInTableViewTextFieldDelegate_WhenTextFieldShouldReturnCalled_ShouldCallBecomeFirstResponderOnViewWithTagOneHigherThanTextField() {
        // given
        let tableView = UITableView()
        
        let startingTag = Int.random(in: 1...10)
        let textFieldMock = UITextField()
        textFieldMock.tag = startingTag
        
        let viewBecomeFirstResponderMock = UIViewBecomeFirstResponderMock()
        viewBecomeFirstResponderMock.tag = startingTag + 1
        tableView.addSubview(viewBecomeFirstResponderMock)
        
        
        let sut = HighlightNextCellInTableViewTextFieldDelegate(tableView: tableView)
        
        // when
        _ = sut.textFieldShouldReturn(textFieldMock)
        
        // then
        XCTAssertEqual(viewBecomeFirstResponderMock.becomeFirstResponderCalledCount, 1)
    }
}
