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
        let scoreChangeHistorySegment = GameHistorySegment.scoreChange(scoreChangeObject, PlayerMock())
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
        let endRoundHistorySegment = GameHistorySegment.endRound(endRound, [])
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
    
    
    // MARK: - StartDeletingHistorySegmentAt
    
    func test_GameHistoryViewModel_WhenStartDeletingHistorySegmentAtCalledInRange_ShouldSetShowDeleteSegmentWarningValueToInt() {
        // given
        let game = GameMock()
        game.historySegments = [GameHistorySegment.scoreChange(ScoreChange.getBlankScoreChange(), PlayerMock())]
        let sut = GameHistoryViewModel(game: game)
        
        let expectation = XCTestExpectation(description: "ShouldShowDeleteSegmentWarning value should be set")
        
        sut.shouldShowDeleteSegmentWarningIndex.valueChanged = { index in
            expectation.fulfill()
            XCTAssertEqual(index, 0)
        }
        
        // when
        sut.startDeletingHistorySegmentAt(0)
        
        // then
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_GameHistoryViewModel_WhenStartDeletingHistorySegmentAtCalledInRange_ShouldNotSetShowDeleteSegmentWarningValueToTrue() {
        // given
        let game = GameMock()
        let sut = GameHistoryViewModel(game: game)
        
        let expectation = XCTestExpectation(description: "ShouldShowDeleteSegmentWarning value should not be set")
        expectation.isInverted = true
        
        sut.shouldShowDeleteSegmentWarningIndex.valueChanged = { _ in
            expectation.fulfill()
        }
        
        // when
        sut.startDeletingHistorySegmentAt(0)
        
        // then
        wait(for: [expectation], timeout: 0.1)
    }
    
    
    // MARK: - DeleteHistorySegmentAt
    
    func test_GameHistoryViewModel_WhenDeleteHistorySegmentAtCalled_ShouldCallGameDeleteHistorySegmentAtWithIndex() {
        // given
        let game = GameMock()
        let sut = GameHistoryViewModel(game: game)
        
        let index = Int.random(in: 1...1000)
        
        // when
        sut.deleteHistorySegmentAt(index)
        
        // then
        XCTAssertEqual(game.deleteHistorySegmentAtCalledCount, 1)
        XCTAssertEqual(game.deleteHistorySegmentAtIndex, index)
    }
    
    func test_GameHistoryViewModel_WhenDeleteHistorySegmentAtCalled_ShouldSetShouldRefreshTableViewToTrue() {
        // given
        let game = GameMock()
        let sut = GameHistoryViewModel(game: game)
        
        let expectation = XCTestExpectation(description: "ShouldRefreshTableview should be set")
        
        sut.shouldRefreshTableView.valueChanged = { shouldRefresh in
            expectation.fulfill()
            XCTAssertTrue(shouldRefresh ?? false)
        }
        
        // when
        sut.deleteHistorySegmentAt(0)
        
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
    
    func test_GameHistoryViewModel_WhenEditScoreCalled_ShouldSetShouldRefreshTableViewToTrue() {
        // given
        let game = GameMock()
        
        let expectation = XCTestExpectation(description: "tableViewIndexToRefresh not set")
        
        let sut = GameHistoryViewModel(game: game)
        
        sut.shouldRefreshTableView.valueChanged = { shouldRefresh in
            expectation.fulfill()
            XCTAssertTrue(shouldRefresh ?? false)
        }
        
        // when
        sut.editScore(ScoreChange.getBlankScoreChange())
        
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
    
    func test_GameHistoryViewmodel_WhenEndRoundCalled_ShouldSetShouldRefreshTableViewToTrue() {
        // given
        let game = GameMock()
        
        let expectation = XCTestExpectation(description: "tableViewIndexToRefresh not set")
        
        let sut = GameHistoryViewModel(game: game)
        
        sut.shouldRefreshTableView.valueChanged = { shouldRefresh in
            expectation.fulfill()
            XCTAssertTrue(shouldRefresh ?? false)
        }
        
        // when
        sut.endRound(EndRound.getBlankEndRound())
        
        // then
        wait(for: [expectation], timeout: 0.1)
    }
    
}


class GameHistoryViewModelMock: GameHistoryViewModelProtocol, ScoreboardPlayerEditScorePopoverDelegate, EndRoundPopoverDelegateProtocol {
    var game: GameProtocol = GameMock()
    var scoreChangeToEdit: Observable<ScoreChange> = Observable(nil)
    var endRoundToEdit: Observable<EndRound> = Observable(nil)
    var shouldRefreshTableView: Observable<Bool> = Observable(nil)
    var shouldShowDeleteSegmentWarningIndex: Observable<Int> = Observable(nil)
    
    var didSelectRowCalledCount = 0
    var didSelectRowRow: Int?
    func didSelectRow(_ row: Int) {
        didSelectRowCalledCount += 1
        didSelectRowRow = row
    }
    
    var startDeletingHistorySegmentAtCalledCount = 0
    var startDeletingHistorySegmentAtIndex: Int?
    func startDeletingHistorySegmentAt(_ row: Int) {
        startDeletingHistorySegmentAtCalledCount += 1
        startDeletingHistorySegmentAtIndex = row
    }
    
    var deleteHistorySegmentAtCalledCount = 0
    var deleteHistorySegmentAtIndex: Int?
    func deleteHistorySegmentAt(_ index: Int) {
        deleteHistorySegmentAtCalledCount += 1
        deleteHistorySegmentAtIndex = index
    }
    
    func editScore(_ scoreChange: ScoreChange) {}
    func endRound(_ endRound: EndRound) {}
}
