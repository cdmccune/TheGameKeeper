//
//  GameHistoryViewModelMock.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 4/10/24.
//

import Foundation
@testable import Whats_The_Score

class GameHistoryViewModelMock: GameHistoryViewModelProtocol, ScoreboardPlayerEditScorePopoverDelegate, EndRoundPopoverDelegateProtocol {
    
    var coreDataStore: Whats_The_Score.CoreDataStoreProtocol = CoreDataStoreMock()
    var coordinator: ScoreboardCoordinator? = ScoreboardCoordinatorMock(navigationController: RootNavigationController())
    var game: GameProtocol = GameMock()
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
    func endRound(_ endRound: EndRoundSettings) {}
}
