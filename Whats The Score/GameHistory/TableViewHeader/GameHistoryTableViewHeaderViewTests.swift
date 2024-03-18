//
//  GameHistoryTableViewHeaderViewTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 3/18/24.
//

import XCTest
@testable import Whats_The_Score

final class GameHistoryTableViewHeaderViewTests: XCTestCase {

    var view: GameHistoryTableViewHeaderView!
    
    override func setUp() {
        let nibs = Bundle.main.loadNibNamed("GameHistoryTableViewHeaderView", owner: nil)
        view = nibs?.first(where: { $0 is GameHistoryTableViewHeaderView}) as? GameHistoryTableViewHeaderView
    }
    
    override func tearDown() {
        view = nil
    }
    
    
    // MARK: - SetupView
    
    func test_GameHistoryTableView_WhenSetupViewsCalledIsRoundBasedGameTrue_ShouldSetRoundStackViewHiddenFalse() {
        // given
        let sut = view
        
        // when
        view.setupViews(isRoundBasedGame: true)
        
        // then
        XCTAssertFalse(sut?.roundStackView.isHidden ?? true)
    }
    
    func test_GameHistoryTableView_WhenSetupViewsCalledIsRoundBasedGameFalse_ShouldSetRoundStackViewHiddenTrue() {
        // given
        let sut = view
        
        // when
        view.setupViews(isRoundBasedGame: false)
        
        // then
        XCTAssertTrue(sut?.roundStackView.isHidden ?? false)
    }

}

class GameHistoryTableViewHeaderViewMock: GameHistoryTableViewHeaderView {
    var isRoundBasedGame: Bool?
    override func setupViews(isRoundBasedGame: Bool) {
        self.isRoundBasedGame = isRoundBasedGame
    }
}
