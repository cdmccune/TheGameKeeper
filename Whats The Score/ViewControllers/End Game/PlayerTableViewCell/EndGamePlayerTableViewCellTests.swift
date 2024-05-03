//
//  EndGamePlayerTableViewCellTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 3/8/24.
//

import XCTest
@testable import Whats_The_Score

final class EndGamePlayerTableViewCellTests: XCTestCase {

    // MARK: - Setup
    
    var tableViewCell: EndGamePlayerTableViewCell?
    
    override func setUp() {
        let nibs = Bundle.main.loadNibNamed("EndGamePlayerTableViewCell", owner: nil)
        tableViewCell = nibs?.first(where: { $0 is EndGamePlayerTableViewCell}) as? EndGamePlayerTableViewCell
    }
    
    override func tearDown() {
        tableViewCell = nil
    }
    
    
    // MARK: - Initialization
    
    func test_EndGamePlayerTableViewCell_WhenLoadedFromNib_ShouldHaveNonNilOutlets() {
        // given
        // when
        let sut = tableViewCell!
        
        // then
        XCTAssertNotNil(sut.playerNameLabel)
        XCTAssertNotNil(sut.playerScoreLabel)
    }
    
    
    // MARK: - AwakeFromNib
    
    func test_EndGamePlayerTableViewCell_WhenAwakeFromNibCalled_ShouldSetImageViewsCornerRadiusTo25AndBorderWidthTo2() {
        // given
        let sut = tableViewCell!
        
        // when
        sut.awakeFromNib()
        
        // then
        XCTAssertEqual(sut.playerIconImageView.layer.cornerRadius, 25)
        XCTAssertEqual(sut.playerIconImageView.layer.borderWidth, 2)
    }

    
    // MARK: - SetupNoLosingPlayers
    
    func test_EndGamePlayerTableViewCell_WhenSetupNoLosingPlayersCalled_ShouldSetPlayerScoreTextToThereAreNoLosersAndHideImageViewAndPlayerNameLabel() {
        // given
        let sut = tableViewCell!
        sut.playerNameLabel.isHidden = false
        sut.playerIconImageView.isHidden = false
        
        // when
        sut.setupNoLosingPlayers()
        
        // then
        XCTAssertEqual(sut.playerScoreLabel.text, "There are no losers!")
        XCTAssertTrue(sut.playerNameLabel.isHidden)
        XCTAssertTrue(sut.playerIconImageView.isHidden)
    }
    
    
    // MARK: - SetupErrorCell
    
    func test_EndGamePlayerTableViewCell_WhenSetupNoLosingPlayersCalled_ShouldSetPlayerScoreTextToThereWasAnErrorAndHideImageViewPositionLabelAndPlayerNameLabel() {
        // given
        let sut = tableViewCell!
        sut.playerNameLabel.isHidden = false
        sut.playerIconImageView.isHidden = false
        sut.positionLabel.isHidden = false
        
        // when
        sut.setupErrorCell()
        
        // then
        XCTAssertEqual(sut.playerScoreLabel.text, "There has been an error")
        XCTAssertTrue(sut.playerNameLabel.isHidden)
        XCTAssertTrue(sut.playerIconImageView.isHidden)
        XCTAssertTrue(sut.positionLabel.isHidden)
    }
    
    
    // MARK: - SetupViewFor
    
    func test_EndGamePlayerTableViewCell_WhenSetupCellWithCalledNotTied_ShouldSetPlayerPositionLabelToBeOrdinalOfPlaceSent() {
        // given
        let sut = tableViewCell!
        let place = Int.random(in: 0...100)
        
        // when
        sut.setupViewFor(PlayerMock(), inPlace: place, isTied: false)
        
        // then
        XCTAssertEqual(sut.positionLabel.text, place.ordinal)
    }
    
    func test_EndGamePlayerTableViewCell_WhenSetupCellWithCalledTied_ShouldSetPlayerPositionLabelToBeTDashOrdinalOfPlaceSent() {
        // given
        let sut = tableViewCell!
        let place = Int.random(in: 0...100)
        
        // when
        sut.setupViewFor(PlayerMock(), inPlace: place, isTied: true)
        
        // then
        XCTAssertEqual(sut.positionLabel.text, "T-\(place.ordinal)")
    }
    
    func test_EndGamePlayerTableViewCell_WhenSetupViewForCalled_ShouldShowPlayerNameLabelPositionLabelAndPlayerIconImageView() {
        // given
        let sut = tableViewCell!
        sut.playerNameLabel.isHidden = true
        sut.playerIconImageView.isHidden = true
        sut.positionLabel.isHidden = true
        
        // when
        sut.setupViewFor(PlayerMock(), inPlace: 0)
        
        // then
        XCTAssertFalse(sut.playerNameLabel.isHidden)
        XCTAssertFalse(sut.playerIconImageView.isHidden)
        XCTAssertFalse(sut.positionLabel.isHidden)
    }
    
    func test_EndGamePlayerTableViewCell_WhenSetupViewForCalled_ShouldSetPlayerNameTextPlayerNamendScoreToScore() {
        // given
        let sut = tableViewCell!
        let playerName = UUID().uuidString
        let playerScore = Int.random(in: 1...10000)
        let player = PlayerMock(name: playerName, position: 0, score: playerScore)
        
        // when
        sut.setupViewFor(player, inPlace: 0)
        
        // then
        XCTAssertEqual(sut.playerNameLabel.text, playerName)
        XCTAssertEqual(sut.playerScoreLabel.text, String(playerScore))
    }
    
    func test_EndGamePlayerTableViewCell_WhenSetupViewForCalled_ShouldSetPlayerNameLabelTextColorToIconColor() {
        // given
        let sut = tableViewCell!
        
        let icon = PlayerIcon.allCases.randomElement()!
        let player = PlayerMock(name: " ", icon: icon)
        
        // when
        sut.setupViewFor(player, inPlace: 0)
        
        // then
        XCTAssertTrue(sut.playerNameLabel.textColor.cgColor.same(as: icon.color.cgColor))
    }
    
    func test_EndGamePlayerTableViewCell_WhenSetupViewForCalled_ShouldSetPlayerIconImageViewToPlayersIconImage() {
        // given
        let sut = tableViewCell!
        
        let icon = PlayerIcon.allCases.randomElement()!
        let player = PlayerMock(icon: icon)
        
        // when
        sut.setupViewFor(player, inPlace: 0)
        
        // then
        XCTAssertEqual(sut.playerIconImageView.image, icon.image)
    }
    
    func test_EndGamePlayerTableViewCell_WhenSetupViewForCalled_ShouldSetBorderOfPlayerIconImageViewToPlayersIconColor() {
        // given
        let sut = tableViewCell!
        
        let icon = PlayerIcon.allCases.randomElement()!
        let player = PlayerMock(icon: icon)
        
        // when
        sut.setupViewFor(player, inPlace: 0)
        
        // then
        XCTAssertTrue(sut.playerIconImageView.layer.borderColor?.same(as: icon.color.cgColor) ?? false)
    }
}
