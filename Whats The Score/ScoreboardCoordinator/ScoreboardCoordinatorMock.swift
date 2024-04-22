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
    
    var showEndRoundPopoverEndRound: EndRoundSettings?
    var showEndRoundPopoverDelegate: EndRoundPopoverDelegateProtocol?
    var showEndRoundPopoverCalledCount = 0
    override func showEndRoundPopover(withEndRound endRound: EndRoundSettings, andDelegate delegate: EndRoundPopoverDelegateProtocol) {
        showEndRoundPopoverEndRound = endRound
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
    
    var showEditPlayerScorePopoverScoreChange: ScoreChangeSettings?
    var showEditPlayerScorePopoverDelegate: ScoreboardPlayerEditScorePopoverDelegate?
    var showEditPlayerScorePopoverCalledCount = 0
    override func showEditPlayerScorePopover(withScoreChange scoreChange: ScoreChangeSettings, andDelegate delegate: ScoreboardPlayerEditScorePopoverDelegate) {
        showEditPlayerScorePopoverScoreChange = scoreChange
        showEditPlayerScorePopoverDelegate = delegate
        showEditPlayerScorePopoverCalledCount += 1
    }
    
    var showEndGamePopoverGame: GameProtocol?
    var showEndGamePopoverDelegate: EndGamePopoverDelegate?
    var showEndGamePopoverDelay: CGFloat?
    var showEndGamePopoverCalledCount = 0
    override func showEndGamePopover(withGame game: GameProtocol, andDelegate delegate: EndGamePopoverDelegate, delay: CGFloat = 0) {
        showEndGamePopoverGame = game
        showEndGamePopoverDelegate = delegate
        showEndGamePopoverCalledCount += 1
        showEndGamePopoverDelay = delay
    }
    
    var showKeepPlayingPopoverGame: GameProtocol?
    var showKeepPlayingPopoverDelegate: KeepPlayingPopoverDelegate?
    var showKeepPlayingPopoverDelay: CGFloat?
    var showKeepPlayingPopoverCalledCount = 0
    override func showKeepPlayingPopover(withGame game: GameProtocol, andDelegate delegate: KeepPlayingPopoverDelegate, delay: CGFloat = 0) {
        showKeepPlayingPopoverGame = game
        showKeepPlayingPopoverDelegate = delegate
        showKeepPlayingPopoverDelay = delay
        showKeepPlayingPopoverCalledCount += 1
    }
    
    var showEndGameScreenGame: GameProtocol?
    var showEndGameScreenDelay: CGFloat?
    var showEndGameScreenCalledCount = 0
    override func showEndGameScreen(withGame game: GameProtocol, delay: CGFloat = 0) {
        showEndGameScreenGame = game
        showEndGameScreenDelay = delay
        showEndGameScreenCalledCount += 1
    }
    
    var gameWasResetCalledCount: Int = 0
    override func gameWasReset() {
        gameWasResetCalledCount += 1
    }
    
    var deleteGameCalledCount = 0
    override func deleteGame() {
        deleteGameCalledCount += 1
    }
}
