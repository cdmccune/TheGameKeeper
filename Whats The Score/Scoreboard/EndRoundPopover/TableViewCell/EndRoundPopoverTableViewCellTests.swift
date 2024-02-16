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
}
