//
//  EndRoundPopoverTableViewCellTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 2/16/24.
//

import XCTest
@testable import Whats_The_Score

final class EndRoundPopoverTableViewCellTests: XCTestCase {
    
    // MARK: - Setup
    
    var tableViewCell: EndRoundPopoverTableViewCell?
    
    override func setUp() {
        let nibs = Bundle.main.loadNibNamed("EndRoundPopoverTableViewCell", owner: nil)
        tableViewCell = nibs?.first(where: { $0 is EndRoundPopoverTableViewCell}) as? EndRoundPopoverTableViewCell
    }
    
    override func tearDown() {
        tableViewCell = nil
    }
    
    
    // MARK: - LoadedFromNib
    
    func test_EndRoundPopoverTableViewCell_WhenLoadedFromNib_ShouldHaveNonNilOutlets() {
        // given
        let sut = tableViewCell!
        
        // then
        XCTAssertNotNil(sut.playerNameLabel)
        XCTAssertNotNil(sut.scoreTextField)
    }
    
    
    // MARK: - AwakeFromNib
    
    func test_EndRoundPopoverTableViewCell_WhenAwakeFromNibCalled_ShouldAddTargetToTextFieldThatCalledTextFieldDidChange() {
        // given
        let sut = EndRoundPopoverTableViewCellMock()
        let textField = UITextField()
        sut.scoreTextField = textField
        
        // when
        sut.awakeFromNib()
        textField.sendActions(for: .editingChanged)
        
        // then
        XCTAssertEqual(sut.textFieldDidChangeCalledCount, 1)
    }
    
    
    // MARK: - SetupViewPropertiesFor

    func test_EndRoundPopoverTableViewCell_WhenSetupViewPropertiesForCalled_ShouldSetPlayerNameLabelTextToPlayerName() {
        // given
        let sut = tableViewCell!
        
        let playerName = UUID().uuidString
        let player = Player(name: playerName, position: 0)
        
        // when
        sut.setupViewProperties(for: player)
        
        // then
        XCTAssertEqual(sut.playerNameLabel.text, playerName)
    }
    
    
    // MARK: - SetupErrorCell
    
    func test_EndRoundPopoverTableViewCell_WhenSetupErrorCellCalled_ShouldSetPlayerNameLabelToError() {
        // given
        let sut = tableViewCell!
        
        // when
        sut.setupErrorCell()
        
        // then
        XCTAssertEqual(sut.playerNameLabel.text, "Error")
    }

    
    // MARK: - TextFieldDidChange
    
    func test_EndRoundPopoverTableViewCell_WhenTextFieldDidChangeCalledTextIsInt_ShouldCallTextFieldValueChangedHandlerWithCorrectText() {
        // given
        let sut = tableViewCell!
        
        let textField = UITextField()
        let randomNumber = Int.random(in: 1...10)
        textField.text = "\(randomNumber)"
        
        sut.scoreTextField = textField
        
        let expectation = XCTestExpectation(description: "TextFieldDidChangeHandler should be called ")
        
        sut.textFieldDidChangeHandler = { scoreChange in
            expectation.fulfill()
            XCTAssertEqual(scoreChange, randomNumber)
        }
        
        // when
        sut.textFieldDidChange(UITextField())
        
        wait(for: [expectation])
    }
    
    func test_EndRoundPopoverTableViewCell_WhenTextFieldDidChangeCalledTextNil_ShouldCallTextFieldValueChangedHandlerWithZero() {
        // given
        let sut = tableViewCell!
        
        let textField = UITextField()
        textField.text = nil
        
        sut.scoreTextField = textField
        
        let expectation = XCTestExpectation(description: "TextFieldDidChangeHandler should be called ")
        
        sut.textFieldDidChangeHandler = { scoreChange in
            expectation.fulfill()
            XCTAssertEqual(scoreChange, 0)
        }
        
        // when
        sut.textFieldDidChange(UITextField())
        
        wait(for: [expectation])
    }
    
    
}

class EndRoundPopoverTableViewCellMock: EndRoundPopoverTableViewCell {
    var setupViewPropertiesCalledCount = 0
    var setupViewPropertiesPlayer: Player?
    override func setupViewProperties(for player: Player) {
        setupViewPropertiesCalledCount += 1
        setupViewPropertiesPlayer = player
    }
    
    var setupErrorCellCalledCount = 0
    override func setupErrorCell() {
        setupErrorCellCalledCount += 1
    }
    
    var textFieldDidChangeCalledCount = 0
    override func textFieldDidChange(_ textfield: UITextField) {
        textFieldDidChangeCalledCount += 1
    }
}
