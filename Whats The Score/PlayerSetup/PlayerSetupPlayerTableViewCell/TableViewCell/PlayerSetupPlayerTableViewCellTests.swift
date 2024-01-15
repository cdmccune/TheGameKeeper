//
//  PlayerSetupPlayerTableViewCellTests.swift
//  What's The Score Tests
//
//  Created by Curt McCune on 1/10/24.
//

import XCTest
@testable import Whats_The_Score

final class PlayerSetupPlayerTableViewCellTests: XCTestCase {
    
    // MARK: - Setup
    
    var tableViewCell: PlayerSetupPlayerTableViewCell?
    
    override func setUp() {
        let nibs = Bundle.main.loadNibNamed("PlayerSetupPlayerTableViewCell", owner: nil)
        tableViewCell = nibs?.first(where: { $0 is PlayerSetupPlayerTableViewCell}) as? PlayerSetupPlayerTableViewCell
    }
    
    override func tearDown() {
        tableViewCell = nil
    }
    
    // MARK: - Testing

    func test_PlayerSetupPlayerTableViewCell_WhenPlayerTextFieldEndsEditing_ShouldCallPlayerNameChangedFunctionWithTextFieldsString() {
        // given
        let sut = tableViewCell!
        let testString = UUID().uuidString
        sut.playerTextField.text = testString
        
        let expectation = XCTestExpectation(description: "playerNameChanged should be called")
        
        sut.playerNameChanged = {string in
            expectation.fulfill()
            XCTAssertEqual(string, testString)
        }
        
        // when
        sut.playerTextFieldEditingDidEnd(0)
        
        // then
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_PlayerSetupPlayerTableViewCell_WhenCellIsAwokenFromNib_ShouldSetTextFieldDelegateToPlayerSetupNameTextFieldDelegate() {
        // given
        // when
        let sut = tableViewCell!
        
        // then
        XCTAssertTrue(sut.playerTextField.delegate is PlayerSetupNameTextFieldDelegate)
    }
    
    func test_PlayerSetupPlayerTableViewcell_WhenNibIsLoaded_ShouldHaveAutoCaptilizationTypeOfPlayerTextFieldSetToWord() {
        // given
        // when
        let sut = tableViewCell!
        
        // then
        XCTAssertEqual(sut.playerTextField.autocapitalizationType, .words)
    }

}
