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
    
    // MARK: - Outlets

    func test_PlayerSetupPlayerTableViewCell_WhenAwakeFromNibCalled_ShouldHaveNonNilOutlets() {
        // given
        // when
        let sut = tableViewCell!
        
        // then
        XCTAssertNotNil(sut.playerNameLabel)
    }
    
    
    // MARK: - SetupViewProperties
    
    func test_PlayerSetupPlayerTableViewCell_WhenSetupViewPropertiesForPlayerCalled_ShouldSetPlayerNameLabelTextToPlayerName() {
        // given
        let sut = tableViewCell!
        
        let playerName = UUID().uuidString
        let player = PlayerSettings.getStub(name: playerName)
        
        // when
        sut.setupViewPropertiesFor(player: player)
        
        // then
        XCTAssertEqual(sut.playerNameLabel.text, playerName)
    }
    
    func test_PlayerSetupPlayerTableViewCell_WhenSetupViewPropertiesForPlayerCalled_ShouldSetPlayerNameLabelTextColorToIconColor() {
        // given
        let sut = tableViewCell!
        
        let icon = PlayerIcon.allCases.randomElement()!
        let playerSettings = PlayerSettings.getStub(name: " ", icon: icon)
        
        // when
        sut.setupViewPropertiesFor(player: playerSettings)
        
        // then
        XCTAssertEqual(sut.playerNameLabel.textColor, icon.color)
    }
    
    func test_PlayerSetupPlayerTableViewCell_WhenSetupViewPropertiesForPlayerCalled_ShouldSetPlayerIconImageViewImageToPlayerIconImage() {
        // given
        let sut = tableViewCell!

        let icon = PlayerIcon.allCases.randomElement()!
        let playerSettings = PlayerSettings.getStub(icon: icon)

        // when
        sut.setupViewPropertiesFor(player: playerSettings)

        // then
        XCTAssertEqual(sut.playerIconImageView.image, icon.image, "Player icon image should match the icon's image.")
    }
    
    func test_PlayerSetupPlayerTableViewCell_WhenSetupViewPropertiesForPlayerCalled_ShouldCorrectlySetupPlayerIconImageViewProperties() {
        // given
        let sut = tableViewCell!
        
        let icon = PlayerIcon.allCases.randomElement()!
        let playerSettings = PlayerSettings.getStub(name: "Test Player", icon: icon)
        
        // when
        sut.setupViewPropertiesFor(player: playerSettings)
        
        // then
        XCTAssertEqual(sut.playerIconImageView.layer.cornerRadius, 25, "The playerIconImageView should have a corner radius of 25.")
        XCTAssertEqual(sut.playerIconImageView.layer.borderWidth, 2, "The playerIconImageView should have a border width of 2.")
        XCTAssertTrue(sut.playerIconImageView.layer.borderColor?.same(as: icon.color.cgColor) ?? false, "The playerIconImageView border color should match the player's icon color.")
    }

}
