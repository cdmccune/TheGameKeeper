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
        XCTAssertNotNil(sut.scoreTotalLabel)
    }
    
    
    // MARK: - SetupViewProperties
    
    func test_GameHistoryScoreChangeTableViewCell_WhenSetupViewPropertiesForCalled_ShouldSetPlayerNameLabelTextToScoreChangePlayerName() {
        // given
        let sut = tableViewCell!
        let playerName = UUID().uuidString
        
        let scoreChange = ScoreChangeMock(player: PlayerMock(name: playerName))
        
        // when
        sut.setupViewProperties(for: scoreChange)
        
        // then
        XCTAssertEqual(sut.playerNameLabel.text, playerName)
    }
    
    func test_GameHistoryScoreChangeTableViewCell_WhenSetupViewPropertiesForCalled_ShouldSetScoreChangeTextToScoreChange() {
        // given
        let sut = tableViewCell!
        let scoreChangeInt = Int.random(in: (-1000)...1000)
        
        let scoreChange = ScoreChangeMock(player: PlayerMock())
        scoreChange.scoreChange = scoreChangeInt
        
        // when
        sut.setupViewProperties(for: scoreChange)
        
        // then
        XCTAssertEqual(sut.scoreChangeLabel.text, String(scoreChangeInt))
    }
    
    func test_GameHistoryScoreChangeTableViewCell_WhenSetupViewPropertiesForCalled_ShouldSetScoreTotalLabelTextToPlayerGetScoreThroughResult() {
        // given
        let sut = tableViewCell!
        
        let totalScore = Int.random(in: 1...100)
        let player = PlayerMock(getScoreThroughResult: totalScore)
        
        // when
        sut.setupViewProperties(for: ScoreChangeMock(player: player))
        
        // then
        XCTAssertEqual(sut.scoreTotalLabel.text, String(totalScore))
    }
    
    func test_GameHistoryScoreChangeTableViewCell_WhenSetupViewPropertiesForCalledPositiveScoreChange_ShouldSetTextColorToTextColor() {
        // given
        let sut = tableViewCell!
        let scoreChangeInt = Int.random(in: 1...10)
        
        let scoreChange = ScoreChangeMock(player: PlayerMock())
        scoreChange.scoreChange = scoreChangeInt
        
        // when
        sut.setupViewProperties(for: scoreChange)
        
        // then
        XCTAssertEqual(sut.scoreChangeLabel.textColor, .textColor)
    }
    
    func test_GameHistoryScoreChangeTableViewCell_WhenSetupViewPropertiesForCalledZeroScoreChange_ShouldSetTextColorToLabel() {
        // given
        let sut = tableViewCell!
        let scoreChangeInt = 0
        
        let scoreChange = ScoreChangeMock(player: PlayerMock())
        scoreChange.scoreChange = scoreChangeInt
        
        // when
        sut.setupViewProperties(for: scoreChange)
        
        // then
        XCTAssertEqual(sut.scoreChangeLabel.text, String(scoreChangeInt))
        XCTAssertEqual(sut.scoreChangeLabel.textColor, .lightGray)
    }
    
    func test_GameHistoryScoreChangeTableViewCell_WhenSetupViewPropertiesForCalledNegativeScoreChange_ShouldSetTextColorToRed() {
        // given
        let sut = tableViewCell!
        let scoreChangeInt = Int.random(in: (-1000..<0))
        
        let scoreChange = ScoreChangeMock(player: PlayerMock())
        scoreChange.scoreChange = scoreChangeInt
        
        // when
        sut.setupViewProperties(for: scoreChange)
        
        // then
        XCTAssertEqual(sut.scoreChangeLabel.text, String(scoreChangeInt))
        XCTAssertEqual(sut.scoreChangeLabel.textColor, .red)
    }
    
    func test_GameHistoryScoreChangeTableViewCell_WhenSetupViewPropertiesForCalledIsInEndRound_ShouldHideDisclosureIndicatorStackView() {
        // given
        let sut = tableViewCell!
        
        // when
        sut.setupViewProperties(for: ScoreChangeMock(), isInEndRound: true)
        
        // then
        XCTAssertTrue(sut.disclosureIndicatorStackView.isHidden)
    }
    
    func test_GameHistoryScoreChangeTableViewCell_WhenSetupViewPropertiesForCalledIsInEndRoundFalse_ShouldShowDisclosureIndicatorStackView() {
        // given
        let sut = tableViewCell!
        
        // when
        sut.setupViewProperties(for: ScoreChangeMock(), isInEndRound: false)
        
        // then
        XCTAssertFalse(sut.disclosureIndicatorStackView.isHidden)
    }
    
    func test_GameHistoryScoreChangeTableViewCell_WhenSetupViewProperties_ShouldSetPlayerNameLabelTextColorEqualToPlayerIconColor() {
        // given
        let sut = tableViewCell!
        
        let icon = PlayerIcon.allCases.randomElement()!
        let player = PlayerMock(name: " ", icon: icon)
        
        // when
        sut.setupViewProperties(for: ScoreChangeMock(player: player))
        
        // then
        XCTAssertEqual(sut.playerNameLabel.textColor, icon.color)
    }
}

class GameHistoryScoreChangeTableViewCellMock: GameHistoryScoreChangeTableViewCell {
    var setupPropertiesForCalledCount = 0
    var setupPropertiesForScoreChange: ScoreChangeProtocol?
    var setupPropertiesForIsInEndRound: Bool?
    
    override func setupViewProperties(for scoreChange: ScoreChangeProtocol, isInEndRound: Bool = false) {
        self.setupPropertiesForCalledCount += 1
        self.setupPropertiesForScoreChange = scoreChange
        self.setupPropertiesForIsInEndRound = isInEndRound
    }
    
}
