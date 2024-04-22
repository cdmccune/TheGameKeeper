//
//  ScoreboardTableViewCellTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 1/24/24.
//

import XCTest
@testable import Whats_The_Score

final class ScoreboardTableViewCellTests: XCTestCase {
    
    // MARK: - Setup
    
    var tableViewCell: ScoreboardTableViewCell?
    
    override func setUp() {
        let nibs = Bundle.main.loadNibNamed("ScoreboardTableViewCell", owner: nil)
        tableViewCell = nibs?.first(where: { $0 is ScoreboardTableViewCell}) as? ScoreboardTableViewCell
    }
    
    override func tearDown() {
        tableViewCell = nil
    }
    
    // MARK: - LoadedFromNib

    func test_ScoreboardTableViewCell_WhenLoadedFromNib_ShouldHaveNonNilOutlets() {
        // given
        // when
        let sut = tableViewCell!
        
        // then
        XCTAssertNotNil(sut.playerNameLabel)
        XCTAssertNotNil(sut.playerScoreLabel)
    }
    
    
    // MARK: - AwakeFromNib
    
    func test_ScoreboardTableViewCell_WhenAwakeFromNibCalled_ShouldSetPlayerIconImageViewCornerRadiusTo25AndBorderWidthTo2() {
        // given
        let sut = tableViewCell!
        
        // when
        sut.awakeFromNib()
        
        // then
        XCTAssertEqual(sut.playerIconImageView.layer.cornerRadius, 25, "The playerIconImageView should have a corner radius of 25.")
        XCTAssertEqual(sut.playerIconImageView.layer.borderWidth, 2, "The playerIconImageView should have a border width of 2.")
    }
    
    
    // MARK: - SetupCellWith
    
    func test_ScoreboardTableViewCell_WhenSetupCellWithCalled_ShouldSetPlayerNameToPlayerNameLabel() {
        // given
        let sut = tableViewCell!
        let playerName = UUID().uuidString
        let player = PlayerMock(name: playerName)
        
        // when
        sut.setupCellWith(player, inPlace: 0)
        
        // then
        XCTAssertEqual(sut.playerNameLabel.text, playerName)
    }
    
    func test_ScoreboardTableViewCell_WhenSetupCellWithCalled_ShouldSetPlayerScoreLabelTextToScore() {
        // given
        let sut = tableViewCell!
        let playerScore = Int.random(in: 0...1000)
        let player = PlayerMock(score: playerScore)
        
        // when
        sut.setupCellWith(player, inPlace: 0)
        
        // then
        XCTAssertEqual(sut.playerScoreLabel.text, String(playerScore))
    }
    
    func test_ScoreboardTableViewCell_WhenSetupCellWithCalledNotTied_ShouldSetPlayerPositionLabelToBeOrdinalOfPlaceSent() {
        // given
        let sut = tableViewCell!
        let place = Int.random(in: 0...100)
        
        // when
        sut.setupCellWith(PlayerMock(), inPlace: place, isTied: false)
        
        // then
        XCTAssertEqual(sut.positionLabel.text, place.ordinal)
    }
    
    func test_ScoreboardTableViewCell_WhenSetupCellWithCalledTied_ShouldSetPlayerPositionLabelToBeTDashOrdinalOfPlaceSent() {
        // given
        let sut = tableViewCell!
        let place = Int.random(in: 0...100)
        
        // when
        sut.setupCellWith(PlayerMock(), inPlace: place, isTied: true)
        
        // then
        XCTAssertEqual(sut.positionLabel.text, "T-\(place.ordinal)")
    }
    
    func test_ScoreboardTableViewCell_WhenSetupCellWithCalled_ShouldSetPlayerStrokeEqualToPlayerIconColor() {
        // given
        let sut = tableViewCell!
        
        let icon = PlayerIcon.allCases.randomElement()!
        
        // when
        sut.setupCellWith(PlayerMock(name: " ", icon: icon), inPlace: 0)
        
        // then
        let playerNameAttributedString = sut.playerNameLabel.attributedText
        
        XCTAssertEqual(playerNameAttributedString?.attributes(at: 0, effectiveRange: nil)[NSAttributedString.Key.strokeWidth] as? CGFloat, -4.0)
        XCTAssertEqual(playerNameAttributedString?.attributes(at: 0, effectiveRange: nil)[NSAttributedString.Key.strokeColor] as? UIColor, icon.color)
    }
    
    func test_ScoreboardTableViewCell_WhenSetupCellWithPlayerCalled_ShouldSetPlayerIconImageViewImageToPlayerIconImage() {
        // given
        let sut = tableViewCell!

        let icon = PlayerIcon.allCases.randomElement()!

        // when
        sut.setupCellWith(PlayerMock(icon: icon), inPlace: 0)

        // then
        XCTAssertEqual(sut.playerIconImageView.image, icon.image, "Player icon image should match the icon's image.")
    }
    
    func test_ScoreboardTableViewCell_WhenSetupCellWithPlayerCalled_ShouldSetPlayerStrokeEqualToPlayerIconColor() {
        // given
        let sut = tableViewCell!

        let icon = PlayerIcon.allCases.randomElement()!

        // when
        sut.setupCellWith( PlayerMock(icon: icon), inPlace: 0)

        // then
        XCTAssertTrue(sut.playerIconImageView.layer.borderColor?.same(as: icon.color.cgColor) ?? false, "The playerIconImageView border color should match the player's icon color.")
    }
    
    
    // MARK: - SetupCellForError
    
    func test_ScoreboardTableViewCell_WhenSetupCellForErrorCalled_ShouldSetPlayerNameLabelToErrorAndPlayerScoreToTripleZeros() {
        // given
        let sut = tableViewCell!
        
        // when
        sut.setupCellForError()
        
        // then
        XCTAssertEqual(sut.playerNameLabel.text, "Error")
        XCTAssertEqual(sut.playerScoreLabel.text, "000")
    }
}
