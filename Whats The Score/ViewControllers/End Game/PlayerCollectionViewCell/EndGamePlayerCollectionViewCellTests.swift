//
//  EndGamePlayerCollectionViewCellTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 3/8/24.
//

import XCTest
@testable import Whats_The_Score

final class EndGamePlayerCollectionViewCellTests: XCTestCase {

    // MARK: - Setup
    
    var collectionViewCell: EndGamePlayerCollectionViewCell?
    
    override func setUp() {
        let nibs = Bundle.main.loadNibNamed("EndGamePlayerCollectionViewCell", owner: nil)
        collectionViewCell = nibs?.first(where: { $0 is EndGamePlayerCollectionViewCell}) as? EndGamePlayerCollectionViewCell
    }
    
    override func tearDown() {
        collectionViewCell = nil
    }
    
    
    // MARK: - Initialization
    
    func test_EndGamePlayerCollectionViewCell_WhenLoadedFromNib_ShouldHaveNonNilOutlets() {
        // given
        // when
        let sut = collectionViewCell!
        
        // then
        XCTAssertNotNil(sut.playerNameLabel)
        XCTAssertNotNil(sut.playerScoreLabel)
    }
    
    
    // MARK: - AwakeFromNib
    
    func test_EndGameplayerCollectionViewCell_WhenAwakeFromNibCalled_ShouldSetImageViewsCornerRadiusTo25AndBorderWidthTo2() {
        // given
        let sut = collectionViewCell!
        
        // when
        sut.awakeFromNib()
        
        // then
        XCTAssertEqual(sut.playerIconImageView.layer.cornerRadius, 25)
        XCTAssertEqual(sut.playerIconImageView.layer.borderWidth, 2)
    }
    
    
    // MARK: - SetupErrorCell
    
    func test_EndGamePlayerCollectionViewCell_WhenSetupErrorCellCalled_ShouldSetPlayerNameToErrorAndScoreToTripleQuestionMarks() {
        // given
        let sut = collectionViewCell!
        
        // when
        sut.setupErrorCell()
        
        // then
        XCTAssertEqual(sut.playerNameLabel.text, "Error")
        XCTAssertEqual(sut.playerScoreLabel.text, "???")
    }
    
    
    // MARK: - SetupViewFor
    
    func test_EndGamePlayerCollectionViewCell_WhenSetupViewForCalled_ShouldSetPlayerNameLabelToPlayerNameAndPlayerScoreLabelToPlayerScore() {
        // given
        let sut = collectionViewCell!
        
        let playerName = UUID().uuidString
        let playerScore = Int.random(in: 1...10000)
        let player = PlayerMock(name: playerName, position: 0, score: playerScore)
        
        // when
        sut.setupViewFor(player)
        
        // then
        XCTAssertEqual(sut.playerNameLabel.text, playerName)
        XCTAssertEqual(sut.playerScoreLabel.text, String(playerScore))
    }
    
    func test_EndGamePlayerCollectionViewCell_WhenSetupViewForCalled_ShouldSetPlayerIconImageViewToPlayersIconImage() {
        // given
        let sut = collectionViewCell!
        
        let icon = PlayerIcon.allCases.randomElement()!
        let player = PlayerMock(icon: icon)
        
        // when
        sut.setupViewFor(player)
        
        // then
        XCTAssertEqual(sut.playerIconImageView.image, icon.image)
    }
    
    func test_EndGamePlayerCollectionViewCell_WhenSetupViewForCalled_ShouldSetBorderOfPlayerIconImageViewToPlayersIconColor() {
        // given
        let sut = collectionViewCell!
        
        let icon = PlayerIcon.allCases.randomElement()!
        let player = PlayerMock(icon: icon)
        
        // when
        sut.setupViewFor(player)
        
        // then
        XCTAssertTrue(sut.playerIconImageView.layer.borderColor?.same(as: icon.color.cgColor) ?? false)
    }
    
    func test_EndGamePlayerCollectionViewCell_WhenSetupViewForCalled_ShouldSetPlayerNameLabelTextColorToIconColorAndWidthToFour() {
        // given
        let sut = collectionViewCell!
        
        let icon = PlayerIcon.allCases.randomElement()!
        let player = PlayerMock(name: " ", icon: icon)
        
        // when
        sut.setupViewFor(player)
        
        // then
        XCTAssertEqual(sut.playerNameLabel.textColor, icon.color)

    }

}
