//
//  ScoreboardCoordinatorMock.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 3/21/24.
//

import Foundation
import UIKit
@testable import Whats_The_Score

class ScoreboardCoordinatorMock: ScoreboardCoordinator {
    
    var startCalledCount = 0
    override func start() {
        startCalledCount += 1
    }
    
    var showGameHistoryGame: GameProtocol?
    var showGameHistoryDelegate: GameHistoryViewControllerDelegate?
    var showGameHistoryCalledCount = 0
    override func showGameHistory(withGame game: GameProtocol, andDelegate delegate: GameHistoryViewControllerDelegate) {
        showGameHistoryGame = game
        showGameHistoryDelegate = delegate
        showGameHistoryCalledCount += 1
    }
    
    var showSettingsGame: GameProtocol?
    var showSettingsDelegate: GameSettingsDelegate?
    var showSettingsCalledCount = 0
    override func showSettings(withGame game: GameProtocol, andDelegate delegate: GameSettingsDelegate) {
        showSettingsGame = game
        showSettingsDelegate = delegate
        showSettingsCalledCount += 1
    }
    
    var showEndRoundPopoverGame: GameProtocol?
    var showEndRoundPopoverDelegate: EndRoundPopoverDelegateProtocol?
    var showEndRoundPopoverCalledCount = 0
    override func showEndRoundPopover(withGame game: GameProtocol, andDelegate delegate: EndRoundPopoverDelegateProtocol) {
        showEndRoundPopoverGame = game
        showEndRoundPopoverDelegate = delegate
        showEndRoundPopoverCalledCount += 1
    }
    
    var showEditPlayerPopoverPlayer: PlayerProtocol?
    var showEditPlayerPopoverDelegate: EditPlayerPopoverDelegateProtocol?
    var showEditPlayerPopoverCalledCount = 0
    override func showEditPlayerPopover(withPlayer player: PlayerProtocol, andDelegate delegate: EditPlayerPopoverDelegateProtocol) {
        showEditPlayerPopoverPlayer = player
        showEditPlayerPopoverDelegate = delegate
        showEditPlayerPopoverCalledCount += 1
    }
    
    var showEditPlayerScorePopoverScoreChange: ScoreChange?
    var showEditPlayerScorePopoverDelegate: ScoreboardPlayerEditScorePopoverDelegate?
    var showEditPlayerScorePopoverCalledCount = 0
    override func showEditPlayerScorePopover(withScoreChange scoreChange: ScoreChange, andDelegate delegate: ScoreboardPlayerEditScorePopoverDelegate) {
        showEditPlayerScorePopoverScoreChange = scoreChange
        showEditPlayerScorePopoverDelegate = delegate
        showEditPlayerScorePopoverCalledCount += 1
    }
    
    var showEndGamePopoverGame: GameProtocol?
    var showEndGamePopoverDelegate: EndGamePopoverDelegate?
    var showEndGamePopoverCalledCount = 0
    override func showEndGamePopover(withGame game: GameProtocol, andDelegate delegate: EndGamePopoverDelegate) {
        showEndGamePopoverGame = game
        showEndGamePopoverDelegate = delegate
        showEndGamePopoverCalledCount += 1
    }
}
