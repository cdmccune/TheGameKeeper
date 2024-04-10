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
    
    func test_GameHistoryViewModel_WhenDidSelectRowCalledGameRound_ShouldCallCoordinatorShowEndRoundWithEndRoundIDAtIndex() {
        // given
        
        let endRoundArray = [
            EndRoundMock(),
            EndRoundMock(),
            EndRoundMock()
        ]
        let game = GameMock(gameType: .round, endRounds: endRoundArray)
        
        let sut = GameHistoryViewModel(game: game)
        
        let coordinator = ScoreboardCoordinatorMock(navigationController: RootNavigationController())
        sut.coordinator = coordinator
        
        let index = Int.random(in: 0...2)
        
        // when
        sut.didSelectRow(index)
        
        // then
        XCTAssertEqual(coordinator.showEndRoundPopoverEndRound?.endRoundID, endRoundArray[index].id)
    }
    
    func test_GameHistoryViewModel_WhenDidSelectRowCalledGameRound_ShouldCallCoordinatorEndRoundWithScoreChangesInEndRoundAtIndex() {
        // given
        
        let scoreChangeArray = [
            ScoreChangeMock(scoreChange: Int.random(in: 1...10)),
            ScoreChangeMock(scoreChange: Int.random(in: 1...10)),
            ScoreChangeMock(scoreChange: Int.random(in: 1...10))
        ]
        let endRound = EndRoundMock(scoreChangeArray: scoreChangeArray)
        let game = GameMock(gameType: .round, endRounds: [endRound])
        
        let sut = GameHistoryViewModel(game: game)
        
        let coordinator = ScoreboardCoordinatorMock(navigationController: RootNavigationController())
        sut.coordinator = coordinator
        
        // when
        sut.didSelectRow(0)
        
        // then
        let endRoundSettings = coordinator.showEndRoundPopoverEndRound
        scoreChangeArray.enumerated().forEach({ (index, scoreChange) in
            XCTAssertEqual(endRoundSettings?.scoreChangeSettingsArray[index].scoreChangeID, scoreChange.id)
            XCTAssertEqual(endRoundSettings?.scoreChangeSettingsArray[index].scoreChange, scoreChange.scoreChange)
            XCTAssertEqual(endRoundSettings?.scoreChangeSettingsArray[index].player.id, scoreChange.player.id)
        })
    }
    
    func test_GameHistoryViewModel_WhenDidSelectRowCalledGameRound_ShouldCallCoordinatorShowEndRoundPopoverWithEndRoundRoundNumber() {
        // given
        
        let roundNumber = Int.random(in: 1...10)
        let endRound = EndRoundMock(roundNumber: roundNumber)
        let game = GameMock(gameType: .round, endRounds: [endRound])
        let sut = GameHistoryViewModel(game: game)
        
        let coordinator = ScoreboardCoordinatorMock(navigationController: RootNavigationController())
        sut.coordinator = coordinator
        
        // when
        sut.didSelectRow(0)
        
        // then
        let endRoundSettings = coordinator.showEndRoundPopoverEndRound
        XCTAssertEqual(endRoundSettings?.roundNumber, roundNumber)
    }
    
    func test_GameHistoryViewModel_WhenDidSelectRowAtCalledGameBasic_ShouldCallCoordianatorShowEditPlayerScoreWithSelfAsDelegate() {
        // given
        let game = GameMock(scoreChanges: [ScoreChangeMock()])
        let sut = GameHistoryViewModel(game: game)
        
        let coordinator = ScoreboardCoordinatorMock(navigationController: RootNavigationController())
        sut.coordinator = coordinator
        
        // when
        sut.didSelectRow(0)
        
        // then
        XCTAssertEqual(coordinator.showEditPlayerScorePopoverCalledCount, 1)
        XCTAssertTrue(coordinator.showEditPlayerScorePopoverDelegate as? GameHistoryViewModel === sut)
    }
    
    func test_GameHistoryViewModel_WhenDidSelectRowAtCalledBasic_ShouldCallCoordiantorShowEditPlayerScoreWithInfoFromScoreChangeAtIndex() {
        // given
        
        let scoreChanges = [
            ScoreChangeMock(scoreChange: Int.random(in: 1...10)),
            ScoreChangeMock(scoreChange: Int.random(in: 1...10)),
            ScoreChangeMock(scoreChange: Int.random(in: 1...10))
        ]
        
        let sut = GameHistoryViewModel(game: GameMock(scoreChanges: scoreChanges))
        
        let coordinator = ScoreboardCoordinatorMock(navigationController: RootNavigationController())
        sut.coordinator = coordinator
        
        let index = Int.random(in: 0...2)
        
        // when
        sut.didSelectRow(index)
        
        // then
        XCTAssertEqual(scoreChanges[index].id, coordinator.showEditPlayerScorePopoverScoreChange?.scoreChangeID)
        XCTAssertEqual(scoreChanges[index].player.id, coordinator.showEditPlayerScorePopoverScoreChange?.player.id)
        XCTAssertEqual(scoreChanges[index].scoreChange, coordinator.showEditPlayerScorePopoverScoreChange?.scoreChange)
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
    
    func test_GameHistoryViewModel_WhenDeleteRowAtCalledGameBasic_ShouldCallGameDeleteScoreChangeForGameScoreChangeAtIndex() {
        // given
        let scoreChangeArray = [
            ScoreChangeMock(scoreChange: Int.random(in: 1...10)),
            ScoreChangeMock(scoreChange: Int.random(in: 1...10)),
            ScoreChangeMock(scoreChange: Int.random(in: 1...10))
        ]
        let game = GameMock(scoreChanges: scoreChangeArray)
        let sut = GameHistoryViewModel(game: game)
        
        let index = Int.random(in: 0...2)
        
        // when
        sut.deleteRowAt(index)
        
        // then
        XCTAssertEqual(game.deleteScoreChangeScoreChange?.id, scoreChangeArray[index].id)
        XCTAssertEqual(game.deleteScoreChangeCalledCount, 1)
    }
    
    func test_GameHistoryViewModel_WhenDeleteRowAtCalledGameRound_ShouldCallGameDeleteEndRoundForGameEndRoundAtIndex() {
        // given
        let endRoundArray = [
            EndRoundMock(),
            EndRoundMock(),
            EndRoundMock()
        ]
        let game = GameMock(gameType: .round, endRounds: endRoundArray)
        let sut = GameHistoryViewModel(game: game)
        
        let index = Int.random(in: 0...2)
        
        // when
        sut.deleteRowAt(index)
        
        // then
        XCTAssertEqual(game.deleteEndRoundEndRound?.id, endRoundArray[index].id)
        XCTAssertEqual(game.deleteEndRoundCalledCount, 1)
    }
    
    func test_GameHistoryViewModel_WhenDeleteRowAtCalled_ShouldSetShouldRefreshTableViewToTrue() {
        // given
        let game = GameMock(scoreChanges: [ScoreChangeMock()])
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
    
    func test_GameHistoryViewModel_WhenDeleteRowAtCalled_ShouldCallCoreDataStoreSaveContext() {
        // given
        let coreDataStore = CoreDataStoreMock()
        let sut = GameHistoryViewModel(game: GameMock(scoreChanges: [ScoreChangeMock()]), coreDataStore: coreDataStore)
        
        // when
        sut.deleteRowAt(0)
        
        // then
        XCTAssertEqual(coreDataStore.saveContextCalledCount, 1)
    }
    
    
    // MARK: - EditScore
    
    func test_GameHistoryViewModel_WhenEditScoreCalled_ShouldCallGameEditScoreChangeWithScoreChangeSettings() {
        // given
        let game = GameMock()
        let sut = GameHistoryViewModel(game: game)
        
        let scoreChange = ScoreChangeSettings(player: PlayerMock(), scoreChangeID: UUID())
        
        // when
        sut.editScore(scoreChange)
        
        // then
        XCTAssertTrue(game.editScoreChangeScoreChange == scoreChange)
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
        sut.editScore(ScoreChangeSettings.getStub())
        
        // then
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_GameHistoryViewModel_WhenEditScoreCalled_ShouldCallCoreDataStoreSaveContext() {
        // given
        let coreDataStore = CoreDataStoreMock()
        let sut = GameHistoryViewModel(game: GameMock(), coreDataStore: coreDataStore)
        
        // when
        sut.editScore(ScoreChangeSettings.getStub())
        
        // then
        XCTAssertEqual(coreDataStore.saveContextCalledCount, 1)
    }
    
    
    // MARK: - EndRound
    
    func test_GameHistoryViewModel_WhenEndRoundCalled_ShouldCallGameEditEndRoundWithEndRoundSettings() {
        // given
        let game = GameMock()
        let sut = GameHistoryViewModel(game: game)
        
        let endRound = EndRoundSettings(scoreChangeSettingsArray: [], roundNumber: 0, endRoundID: UUID())
        
        // when
        sut.endRound(endRound)
        
        // then
        XCTAssertEqual(game.editEndRoundCalledCount, 1)
        XCTAssertTrue(game.editEndRoundEndRound == endRound)
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
        sut.endRound(EndRoundSettings.getStub(withPlayerCount: 0))
        
        // then
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_GameHistoryViewModel_WhenEndRoundCalled_ShouldCallCoreDataStoreSaveContext() {
        // given
        let coreDataStore = CoreDataStoreMock()
        let sut = GameHistoryViewModel(game: GameMock(), coreDataStore: coreDataStore)
        
        // when
        sut.endRound(EndRoundSettings.getStub(withPlayerCount: 0))
        
        // then
        XCTAssertEqual(coreDataStore.saveContextCalledCount, 1)
    }
}
