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

    func test_PlayerSetupPlayerTableViewCell_WhenAwakeFromNibCalled_ShouldHaveNonNilOutlets() {
        // given
        // when
        let sut = tableViewCell!
        
        // then
        XCTAssertNotNil(sut.playerNameLabel)
    }
}
