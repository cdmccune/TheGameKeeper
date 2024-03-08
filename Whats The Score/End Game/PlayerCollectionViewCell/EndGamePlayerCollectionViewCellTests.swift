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
        let player = Player(name: playerName, position: 0, score: playerScore)
        
        // when
        sut.setupViewFor(player)
        
        // then
        XCTAssertEqual(sut.playerNameLabel.text, playerName)
        XCTAssertEqual(sut.playerScoreLabel.text, String(playerScore))
    }

}
