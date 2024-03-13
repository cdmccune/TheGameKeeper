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
        let endRoundHistorySegment = GameHistorySegment.endRound(0, [])
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

}


class GameHistoryViewModelMock: GameHistoryViewModelProtocol, ScoreboardPlayerEditScorePopoverDelegate {
    var game: GameProtocol = GameMock()
    var scoreChangeToEdit: Observable<ScoreChange> = Observable(nil)
    var shouldShowEndRoundPopover: Observable<Bool> = Observable(nil)
    
    var didSelectRowCalledCount = 0
    var didSelectRowRow: Int?
    func didSelectRow(_ row: Int) {
        didSelectRowCalledCount += 1
        didSelectRowRow = row
    }
    
    func editScore(_ scoreChange: ScoreChange) {
        
    }
}
