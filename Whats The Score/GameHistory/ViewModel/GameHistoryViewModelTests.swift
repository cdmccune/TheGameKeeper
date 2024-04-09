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
    
    func test_GameHistoryViewModel_WhenDidSelectRowCalledGameBasic_ShouldSetScoreChangeToEdit() {
        // given
        let scoreChangeObject = ScoreChangeMock()
        let game = GameMock(gameType: .basic, scoreChanges: [scoreChangeObject])
        
        let sut = GameHistoryViewModel(game: game)
        
        let expectation = XCTestExpectation(description: "shouldShowEditPlayerScorePopover should have value changed to true")
        
        sut.scoreChangeToEdit.valueChanged = { scoreChange in
            XCTAssertTrue(scoreChangeObject === scoreChange as? ScoreChangeMock)
            expectation.fulfill()
        }
        
        // when
        sut.didSelectRow(0)
        
        // then
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_GameHistoryViewModel_WhenDidSelectRowCalledGameRound_ShouldSetEndRoundToEdit() {
        // given
        let endRound = EndRoundMock()
        let game = GameMock(gameType: .round, endRounds: [endRound])
        
        let sut = GameHistoryViewModel(game: game)
        
        let expectation = XCTestExpectation(description: "shouldShowEditPlayerScorePopover should have value changed to true")
        
        sut.endRoundToEdit.valueChanged = { endRoundToEdit in
            XCTAssertTrue(endRound === endRoundToEdit as? EndRoundMock)
            expectation.fulfill()
        }
        
        // when
        sut.didSelectRow(0)
        
        // then
        wait(for: [expectation], timeout: 0.1)
    }
    
    
    // MARK: - StartDeletingRowAt
    
    func test_GameHistoryViewModel_WhenStartDeletingHistorySegmentAtCalledGameRoundInRange_ShouldSetShowDeleteSegmentWarningIndexValueToInt() {
        // given
        let game = GameMock(gameType: .round, endRounds: [EndRoundMock()])
        let sut = GameHistoryViewModel(game: game)
        
        let expectation = XCTestExpectation(description: "ShouldShowDeleteSegmentWarning value should be set")
        
        sut.shouldShowDeleteSegmentWarningIndex.valueChanged = { index in
            expectation.fulfill()
            XCTAssertEqual(index, 0)
        }
        
        // when
        sut.startDeletingRowAt(0)
        
        // then
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_GameHistoryViewModel_WhenStartDeletingHistorySegmentGameRoundOutOfRange_ShouldNotSetShouldShowDeleteSegmentWarningToTrue() {
        // given
        let game = GameMock(gameType: .basic)
        let sut = GameHistoryViewModel(game: game)
        
        let expectation = XCTestExpectation(description: "ShouldShowDeleteSegmentWarning value should not be set")
        expectation.isInverted = true
        
        sut.shouldShowDeleteSegmentWarningIndex.valueChanged = { _ in
            expectation.fulfill()
        }
        
        // when
        sut.startDeletingRowAt(0)
        
        // then
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_GameHistoryViewModel_WhenStartDeletingHistorySegmentAtCalledGameBasicInRange_ShouldSetShowDeleteSegmentWarningIndexValueToInt() {
        // given
        let game = GameMock(gameType: .basic, scoreChanges: [ScoreChangeMock()])
        let sut = GameHistoryViewModel(game: game)
        
        let expectation = XCTestExpectation(description: "ShouldShowDeleteSegmentWarning value should be set")
        
        sut.shouldShowDeleteSegmentWarningIndex.valueChanged = { index in
            expectation.fulfill()
            XCTAssertEqual(index, 0)
        }
        
        // when
        sut.startDeletingRowAt(0)
        
        // then
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_GameHistoryViewModel_WhenStartDeletingHistorySegmentGameBasicOutOfRange_ShouldNotSetShouldShowDeleteSegmentWarningToTrue() {
        // given
        let game = GameMock(gameType: .basic)
        let sut = GameHistoryViewModel(game: game)
        
        let expectation = XCTestExpectation(description: "ShouldShowDeleteSegmentWarning value should not be set")
        expectation.isInverted = true
        
        sut.shouldShowDeleteSegmentWarningIndex.valueChanged = { _ in
            expectation.fulfill()
        }
        
        // when
        sut.startDeletingRowAt(0)
        
        // then
        wait(for: [expectation], timeout: 0.1)
    }
    
    
    // MARK: - DeleteRowAt
    
    func test_GameHistoryViewModel_WhenDeleteHistorySegmentAtCalled_ShouldCallGameDeleteHistorySegmentAtWithIndex() {
        // given
        let game = GameMock()
        let sut = GameHistoryViewModel(game: game)
        
        let index = Int.random(in: 1...1000)
        
        // when
        sut.deleteRowAt(index)
        
        // then
//        XCTAssertEqual(game.deleteHistorySegmentAtCalledCount, 1)
//        XCTAssertEqual(game.deleteHistorySegmentAtIndex, index)
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
        sut.deleteRowAt(0)
        
        // then
        wait(for: [expectation], timeout: 0.1)
    }
    
    
    // MARK: - EditScore
    
    func test_GameHistoryViewModel_WhenEditScoreCalled_ShouldCallGameEditScoreChangeWithScoreChange() {
        // given
        let game = GameMock()
        let sut = GameHistoryViewModel(game: game)
        
        let scoreChange = ScoreChangeMock()
        
        // when
//        sut.editScore(scoreChange)
        
        // then
        XCTAssertTrue(game.editScoreChangeScoreChange as? ScoreChangeMock === scoreChange)
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
//        sut.editScore(ScoreChangeMock())
        
        // then
        wait(for: [expectation], timeout: 0.1)
    }
    
    
    // MARK: - EndRound
    
    func test_GameHistoryViewModel_WhenEndRoundCalled_ShouldCallGameEditEndRoundWithEndRound() {
        // given
        let game = GameMock()
        let sut = GameHistoryViewModel(game: game)
        
        let endRound = EndRoundMock()
        
        // when
        sut.endRound(endRound)
        
        // then
        XCTAssertEqual(game.editEndRoundCalledCount, 1)
        XCTAssertTrue(game.editEndRoundEndRound as? EndRoundMock === endRound)
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
        sut.endRound(EndRoundMock())
        
        // then
        wait(for: [expectation], timeout: 0.1)
    }
    
}


class GameHistoryViewModelMock: GameHistoryViewModelProtocol, ScoreboardPlayerEditScorePopoverDelegate, EndRoundPopoverDelegateProtocol {
    var game: GameProtocol = GameMock()
    var scoreChangeToEdit: Observable<ScoreChangeProtocol> = Observable(nil)
    var endRoundToEdit: Observable<EndRoundProtocol> = Observable(nil)
    var shouldRefreshTableView: Observable<Bool> = Observable(nil)
    var shouldShowDeleteSegmentWarningIndex: Observable<Int> = Observable(nil)
    
    var didSelectRowCalledCount = 0
    var didSelectRowRow: Int?
    func didSelectRow(_ row: Int) {
        didSelectRowCalledCount += 1
        didSelectRowRow = row
    }
    
    var startDeletingRowAtCalledCount = 0
    var startDeletingRowAtIndex: Int?
    func startDeletingRowAt(_ row: Int) {
        startDeletingRowAtCalledCount += 1
        startDeletingRowAtIndex = row
    }
    
    var deleteRowAtCalledCount = 0
    var deleteRowAtIndex: Int?
    func deleteRowAt(_ index: Int) {
        deleteRowAtCalledCount += 1
        deleteRowAtIndex = index
    }
    
    func editScore(_ scoreChange: ScoreChangeSettings) {}
    func endRound(_ endRound: EndRoundProtocol) {}
}
