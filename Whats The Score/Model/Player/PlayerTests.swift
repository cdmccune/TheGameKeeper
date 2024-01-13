//
//  PlayerTests.swift
//  What's The Score Tests
//
//  Created by Curt McCune on 1/9/24.
//

import XCTest
@testable import Whats_The_Score

final class PlayerTests: XCTestCase {

    func test_Player_WhenHasEmptyNameAndPositionZero_ShouldReturnPlayerWithPositionPlusOneForDisplayName() {
        //given
        let position = Int.random(in: 0...4)
        let sut = Player(name: "", position: position)
        
        //when
        let name = sut.name
        
        //then
        XCTAssertEqual(name, "Player \(position+1)")
    }
    
    func test_Player_WhenHasName_ShouldReturnNameFromName() {
        //given
        let name = UUID().uuidString
        let sut = Player(name: name, position: 0)
        
        //when
        let displayName = sut.name
        
        //then
        XCTAssertEqual(displayName, name)
    }
    
    func test_Player_WhenHasEmptyName_ShouldHaveTrueForHasDefaultName() {
        //given
        //when
        let sut = Player(name: "", position: 0)
        
        //then
        XCTAssertTrue(sut.hasDefaultName)
    }
    
    func test_Player_WhenHasNonEmptyName_ShouldHaveFalseForHasDefaultName() {
        //given
        //when
        let sut = Player(name: UUID().uuidString, position: 0)
        
        //then
        XCTAssertFalse(sut.hasDefaultName)
    }
    
}
