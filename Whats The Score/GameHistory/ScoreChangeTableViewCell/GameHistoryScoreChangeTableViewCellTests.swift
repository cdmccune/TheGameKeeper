//
//  GameHistoryScoreChangeTableViewCellTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 3/11/24.
//

import XCTest
@testable import Whats_The_Score

final class GameHistoryScoreChangeTableViewCellTests: XCTestCase {

    // MARK: - Setup
    
    var tableViewCell: GameHistoryScoreChangeTableViewCell?
    
    override func setUp() {
        let nibs = Bundle.main.loadNibNamed("GameHistoryScoreChangeTableViewCell", owner: nil)
        tableViewCell = nibs?.first(where: { $0 is GameHistoryScoreChangeTableViewCell}) as? GameHistoryScoreChangeTableViewCell
    }
    
    override func tearDown() {
        tableViewCell = nil
    }
    
    
    // MARK: - LoadedFromNib

    func test_GameHistoryScoreChangeTableViewCell_WhenLoadedFromNib_ShouldHaveNonNilOutlets() {
        // given
        // when
        let sut = tableViewCell!
        
        // then
        XCTAssertNotNil(sut.playerNameLabel)
        XCTAssertNotNil(sut.scoreChangeLabel)
    }
    
    
    // MARK: - SetupViewProperties
    
    func test_GameHistoryScoreChangeTableViewCell_WhenSetupViewPropertiesForCalled_ShouldSetPlayerNameLabelTextToScoreChangePlayerName() {
        // given
        let sut = tableViewCell!
        let playerName = UUID().uuidString
        
        var scoreChange = ScoreChange.getBlankScoreChange()
        scoreChange.playerName = playerName
        
        // when
        sut.setupViewProperties(for: scoreChange)
        
        // then
        XCTAssertEqual(sut.playerNameLabel.text, playerName)
    }
    
    func test_GameHistoryScoreChangeTableViewCell_WhenSetupViewPropertiesForCalled_ShouldSetScoreChangeTextToScoreChange() {
        // given
        let sut = tableViewCell!
        let scoreChangeInt = Int.random(in: (-1000)...1000)
        
        var scoreChange = ScoreChange.getBlankScoreChange()
        scoreChange.scoreChange = scoreChangeInt
        
        // when
        sut.setupViewProperties(for: scoreChange)
        
        // then
        XCTAssertEqual(sut.scoreChangeLabel.text, String(scoreChangeInt))
    }
    
    func test_GameHistoryScoreChangeTableViewCell_WhenSetupViewPropertiesForCalledPositiveScoreChange_ShouldSetTextColorToBlue() {
        // given
        let sut = tableViewCell!
        let scoreChangeInt = Int.random(in: 1...10)
        
        var scoreChange = ScoreChange.getBlankScoreChange()
        scoreChange.scoreChange = scoreChangeInt
        
        // when
        sut.setupViewProperties(for: scoreChange)
        
        // then
        XCTAssertEqual(sut.scoreChangeLabel.textColor, .systemBlue)
    }
    
    func test_GameHistoryScoreChangeTableViewCell_WhenSetupViewPropertiesForCalledZeroScoreChange_ShouldSetTextColorToLabel() {
        // given
        let sut = tableViewCell!
        let scoreChangeInt = 0
        
        var scoreChange = ScoreChange.getBlankScoreChange()
        scoreChange.scoreChange = scoreChangeInt
        
        // when
        sut.setupViewProperties(for: scoreChange)
        
        // then
        XCTAssertEqual(sut.scoreChangeLabel.text, String(scoreChangeInt))
        XCTAssertEqual(sut.scoreChangeLabel.textColor, .label)
    }
    
    func test_GameHistoryScoreChangeTableViewCell_WhenSetupViewPropertiesForCalledNegativeScoreChange_ShouldSetTextColorToRed() {
        // given
        let sut = tableViewCell!
        let scoreChangeInt = Int.random(in: (-1000..<0))
        
        var scoreChange = ScoreChange.getBlankScoreChange()
        scoreChange.scoreChange = scoreChangeInt
        
        // when
        sut.setupViewProperties(for: scoreChange)
        
        // then
        XCTAssertEqual(sut.scoreChangeLabel.text, String(scoreChangeInt))
        XCTAssertEqual(sut.scoreChangeLabel.textColor, .red)
    }
}
