//
//  GameHistoryViewModelTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 3/11/24.
//

import XCTest
@testable import Whats_The_Score

final class GameHistoryViewModelTests: XCTestCase {
    
    
    // MARK: - DidSelectRow
    
    func test_GameHistoryViewModel_WhenDidSelectRowCalledIndexScoreChange_ShouldSetScoreChangeToEdit() {
        // given
        let game = GameMock()
        let player = Player.getBasicPlayer()
        let scoreChangeObject = ScoreChange(player: player, scoreChange: 0)
        let scoreChangeHistorySegment = GameHistorySegment.scoreChange(scoreChangeObject)
        game.historySegments = [scoreChangeHistorySegment]
        
        let sut = GameHistoryViewModel(game: game)
        
        let expectation = XCTestExpectation(description: "shouldShowEditPlayerScorePopover should have value changed to true")
        
        sut.scoreChangeToEdit.valueChanged = { scoreChange in
            XCTAssertEqual(scoreChangeObject, scoreChange)
            expectation.fulfill()
        }
        
        // when
        sut.didSelectRow(0)
        
        // then
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_GameHistoryViewModel_WhenDidSelectRowCalledIndexEndRound_ShouldSetShouldShowEndRoundPopoverValueTrue() {
        // given
        let game = GameMock()
        let endRoundHistorySegment = GameHistorySegment.endRound(UUID(), 0, [])
        game.historySegments = [endRoundHistorySegment]
        
        let sut = GameHistoryViewModel(game: game)
        
        let expectation = XCTestExpectation(description: "shouldShowEditPlayerScorePopover should have value changed to true")
        
        sut.shouldShowEndRoundPopover.valueChanged = { shouldShow in
            XCTAssertTrue(shouldShow ?? false)
            expectation.fulfill()
        }
        
        // when
        sut.didSelectRow(0)
        
        // then
        wait(for: [expectation], timeout: 0.1)
    }
    
    
    // MARK: - EditScore
    
    func test_GameHistoryViewModel_WhenEditScoreCalled_ShouldCallGameEditScoreChangeWithScoreChange() {
        // given
        let game = GameMock()
        let sut = GameHistoryViewModel(game: game)
        
        let scoreChange = ScoreChange.getBlankScoreChange()
        
        // when
        sut.editScore(scoreChange)
        
        // then
        XCTAssertEqual(game.editScoreChangeScoreChange, scoreChange)
        XCTAssertEqual(game.editScoreChangeCalledCount, 1)
    }
    
    func test_GameHistoryViewModel_WhenEditScoreCalled_ShouldSetTableViewIndexToRefreshToIndexOfScoreChange() {
        // given
        let game = GameMock()
        
        let scoreChange1 = ScoreChange.getBlankScoreChange()
        let scoreChange2 = ScoreChange.getBlankScoreChange()
        let scoreChange3 = ScoreChange.getBlankScoreChange()
        
        let scoreChanges = [
            scoreChange1,
            scoreChange2,
            scoreChange3
        ]
        
        game.historySegments = [
            GameHistorySegment.scoreChange(scoreChange1),
            GameHistorySegment.scoreChange(scoreChange2),
            GameHistorySegment.scoreChange(scoreChange3)
        ]
        
        let index = Int.random(in: 0...2)
        
        let expectation = XCTestExpectation(description: "tableViewIndexToRefresh not set")
        
        let sut = GameHistoryViewModel(game: game)
        
        sut.tableViewIndexToRefresh.valueChanged = { indexToRefresh in
            expectation.fulfill()
            XCTAssertEqual(index, indexToRefresh)
        }
        
        // when
        sut.editScore(scoreChanges[index])
        
        // then
        wait(for: [expectation], timeout: 0.1)
    }
    
}


class GameHistoryViewModelMock: GameHistoryViewModelProtocol, ScoreboardPlayerEditScorePopoverDelegate {
    var game: GameProtocol = GameMock()
    var scoreChangeToEdit: Observable<ScoreChange> = Observable(nil)
    var shouldShowEndRoundPopover: Observable<Bool> = Observable(nil)
    var tableViewIndexToRefresh: Observable<Int> = Observable(nil)
    
    var didSelectRowCalledCount = 0
    var didSelectRowRow: Int?
    func didSelectRow(_ row: Int) {
        didSelectRowCalledCount += 1
        didSelectRowRow = row
    }
    
    func editScore(_ scoreChange: ScoreChange) {}
}
