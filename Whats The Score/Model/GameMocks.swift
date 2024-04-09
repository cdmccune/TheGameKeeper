//
//  GamePropertyMock.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/8/24.
//

import XCTest
import CoreData
@testable import Whats_The_Score


class GamePropertyMock: Game {
    
    var temporaryManagedObjectContext: NSManagedObjectContext?
    override var managedObjectContext: NSManagedObjectContext? {
        return temporaryManagedObjectContext
    }
    
    var temporaryPlayerArray: [PlayerProtocol] = []
    override var players: [PlayerProtocol] { temporaryPlayerArray }
    
    var temporaryScoreChangeArray: [ScoreChangeProtocol] = []
    override var scoreChanges: [ScoreChangeProtocol] { temporaryScoreChangeArray }
    
    var temporaryEndRoundsArray: [EndRoundProtocol] = []
    override var endRounds: [EndRoundProtocol] { temporaryEndRoundsArray }
    
    private var temporaryGameType: GameType = .basic
    override var gameType: GameType {
        get { temporaryGameType }
        set { temporaryGameType = newValue}
    }
    
    private var temporaryGameEndType: GameEndType = .none
    override var gameEndType: GameEndType {
        get { temporaryGameEndType }
        set { temporaryGameEndType = newValue}
    }
    
    private var temporaryEndingScoreType: Int = 0
    override var endingScore: Int {
        get { temporaryEndingScoreType }
        set { temporaryEndingScoreType = newValue}
    }
    
    private var temporaryCurrentRound: Int = 0
    override var currentRound: Int {
        get { temporaryCurrentRound }
        set { temporaryCurrentRound = newValue}
    }
}

class GameIsEndOfGameMock: GameMock {
    var isEndOfGameBool = false
    var isEndOfGameCalledCount = 0
    override func isEndOfGame() -> Bool {
        isEndOfGameCalledCount += 1
        return isEndOfGameBool
    }
}

class GameMock: GameProtocol {
    convenience init(gameType: GameType = .basic,
                     gameEndType: GameEndType = .none,
                     numberOfRounds: Int = 0,
                     endingScore: Int = 0,
                     currentRounts: Int = 0,
                     players: [PlayerProtocol] = [],
                     endRounds: [EndRoundProtocol] = [],
                     scoreChanges: [ScoreChangeProtocol] = []) {
        self.init()
        self.players = players
        self.gameType = gameType
        self.gameEndType = gameEndType
        self.numberOfRounds = numberOfRounds
        self.endingScore = endingScore
        self.currentRound = currentRounts
        self.scoreChanges = scoreChanges
        self.endRounds = endRounds
    }
    
    var id: UUID = UUID()
    var gameType: GameType = .basic
    var gameEndType: GameEndType = .none
    var numberOfRounds: Int = 2
    var endingScore: Int = 10
    var currentRound: Int = 0
    var players: [PlayerProtocol] = []
    var winningPlayers: [PlayerProtocol] = []
    
    var endRounds: [EndRoundProtocol] = []
    var scoreChanges: [ScoreChangeProtocol] = []
    
    func changeName(of player: PlayerProtocol, to name: String) {
        
    }
    
//    var playerNameChangedCalledCount = 0
//    var playerNameChangedIndex: Int?
//    var playerNameChangedName: String?
//    func playerNameChanged(withIndex index: Int, toName name: String) {
//        self.playerNameChangedCalledCount += 1
//        self.playerNameChangedIndex = index
//        self.playerNameChangedName = name
//    }
    
    var movePlayerAtCalledCount = 0
    var movePlayerAtSourceRowIndex: Int?
    var movePlayerAtDestinationRowIndex: Int?
    func movePlayerAt(_ sourceRowIndex: Int, to destinationRowIndex: Int) {
        movePlayerAtCalledCount += 1
        movePlayerAtSourceRowIndex = sourceRowIndex
        movePlayerAtDestinationRowIndex = destinationRowIndex
    }
    
    var addPlayerCalledCount = 0
    func addPlayer(withName name: String) {
        addPlayerCalledCount += 1
    }
    
    var randomizePlayersCalledCount = 0
    func randomizePlayers() {
        randomizePlayersCalledCount += 1
    }
    
    func deletePlayer(_ player: PlayerProtocol) {
        
    }
    
    func deleteEndRound(_ endRound: EndRoundProtocol) {
        
    }
    
    func deleteScoreChange(_ scoreChange: ScoreChangeProtocol) {
        
    }
    
    func changeScore(with scoreChangeSettings: ScoreChangeSettings) {
        
    }
    
//    var deletePlayerAtCalledCount = 0
//    var deletePlayerAtIndex: Int?
//    func deletePlayerAt(_ index: Int) {
//        deletePlayerAtIndex = index
//        deletePlayerAtCalledCount += 1
//    }
    
//    var editScoreScoreChange: ScoreChangeProtocol?
//    var editScoreChange: Int?
//    var editScoreCalledCount = 0
//    func editScore(scoreChange: ScoreChangeProtocol) {
//        editScoreScoreChange = scoreChange
//        editScoreCalledCount += 1
//    }
    
    var endRoundEndRound: EndRoundSettings?
    var endRoundCalledCount = 0
    func endRound(with endRoundSettings: EndRoundSettings) {
        endRoundEndRound = endRoundSettings
        endRoundCalledCount += 1
    }
    
    var updateSettingsCalledCount = 0
    var updateSettingsGameEndType: GameEndType?
    var updateSettingsEndingScore: Int?
    var updateSettingsNumberOfRounds: Int?
    
    func updateSettings(with gameEndType: Whats_The_Score.GameEndType, endingScore: Int, andNumberOfRounds numberOfRounds: Int) {
        self.updateSettingsCalledCount += 1
        self.updateSettingsGameEndType = gameEndType
        self.updateSettingsEndingScore = endingScore
        self.updateSettingsNumberOfRounds = numberOfRounds
    }
    
    var resetGameCalledCount = 0
    func resetGame() {
        resetGameCalledCount += 1
    }
    
    var editScoreChangeScoreChange: ScoreChangeSettings?
    var editScoreChangeCalledCount = 0
    func editScoreChange(_ scoreChange: ScoreChangeSettings) {
        editScoreChangeScoreChange = scoreChange
        editScoreChangeCalledCount += 1
    }
    
    var editEndRoundCalledCount = 0
    var editEndRoundEndRound: EndRoundSettings?
    func editEndRound(_ newEndRound: EndRoundSettings) {
        editEndRoundCalledCount += 1
        editEndRoundEndRound = newEndRound
    }
    
    var deleteHistorySegmentAtCalledCount = 0
    var deleteHistorySegmentAtIndex: Int?
    func deleteHistorySegmentAt(index: Int) {
        deleteHistorySegmentAtCalledCount += 1
        deleteHistorySegmentAtIndex = index
    }
    
    func isEqualTo(game: GameProtocol) -> Bool {
        game.id == self.id
    }
    
    func isEndOfGame() -> Bool {
        return false
    }
}
