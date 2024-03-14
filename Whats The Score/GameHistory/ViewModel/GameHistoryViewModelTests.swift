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
    
    func test_GameHistoryViewModel_WhenDidSelectRowCalledIndexEndRound_ShouldSetEndRoundToEdit() {
        // given
        let game = GameMock()
        
        let endRound = EndRound.getBlankEndRound()
        let endRoundHistorySegment = GameHistorySegment.endRound(endRound)
        game.historySegments = [endRoundHistorySegment]
        
        let sut = GameHistoryViewModel(game: game)
        
        let expectation = XCTestExpectation(description: "shouldShowEditPlayerScorePopover should have value changed to true")
        
        sut.endRoundToEdit.valueChanged = { endRoundToEdit in
            XCTAssertEqual(endRound, endRoundToEdit)
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
    
    
    // MARK: - EndRound
    
    func test_GameHistoryViewModel_WhenEndRoundCalled_ShouldCallGameEditEndRoundWithEndRound() {
        // given
        let game = GameMock()
        let sut = GameHistoryViewModel(game: game)
        
        let endRound = EndRound.getBlankEndRound()
        
        // when
        sut.endRound(endRound)
        
        // then
        XCTAssertEqual(game.editEndRoundCalledCount, 1)
        XCTAssertEqual(game.editEndRoundEndRound, endRound)
    }
    
    func test_GameHistoryViewmodel_WhenEndRoundCalled_ShouldSetTableViewIndexToRefresToIndexOfEndRound() {
        // given
        let game = GameMock()
        
        let endRound1 = EndRound.getBlankEndRound()
        let endRound2 = EndRound.getBlankEndRound()
        let endRound3 = EndRound.getBlankEndRound()
        
        let endRounds = [
            endRound1,
            endRound2,
            endRound3
        ]
        
        game.historySegments = [
            GameHistorySegment.endRound(endRound1),
            GameHistorySegment.endRound(endRound2),
            GameHistorySegment.endRound(endRound3)
        ]
        
        let index = Int.random(in: 0...2)
        
        let expectation = XCTestExpectation(description: "tableViewIndexToRefresh not set")
        
        let sut = GameHistoryViewModel(game: game)
        
        sut.tableViewIndexToRefresh.valueChanged = { indexToRefresh in
            expectation.fulfill()
            XCTAssertEqual(index, indexToRefresh)
        }
        
        // when
        sut.endRound(endRounds[index])
        
        // then
        wait(for: [expectation], timeout: 0.1)
    }
    
}


class GameHistoryViewModelMock: GameHistoryViewModelProtocol, ScoreboardPlayerEditScorePopoverDelegate, EndRoundPopoverDelegateProtocol {
    var game: GameProtocol = GameMock()
    var scoreChangeToEdit: Observable<ScoreChange> = Observable(nil)
    var endRoundToEdit: Observable<EndRound> = Observable(nil)
    var tableViewIndexToRefresh: Observable<Int> = Observable(nil)
    
    var didSelectRowCalledCount = 0
    var didSelectRowRow: Int?
    func didSelectRow(_ row: Int) {
        didSelectRowCalledCount += 1
        didSelectRowRow = row
    }
    
    func editScore(_ scoreChange: ScoreChange) {}
    func endRound(_ endRound: EndRound) {}
}
