//
//  GameTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 1/19/24.
//

import XCTest
import CoreData
@testable import Whats_The_Score

final class GameTests: XCTestCase {
    
    // MARK: - Setup
    
    var context: NSManagedObjectContext!
    
    override func setUp() {
        context = CoreDataStore(.inMemory).persistentContainer.viewContext
    }
    
    override func tearDown() {
        context = nil
    }

//    // MARK: - Init
//    
//    func test_Game_WhenInitialized_ShouldCreatePlayersForNumberOfPlayersPropertiesWithCorrectPositions() {
//        // given
//        let numberOfPlayers = Int.random(in: 1...5)
//        
//        // when
//        let sut = Game(gameType: .basic, gameEndType: .none, numberOfRounds: 0, numberOfPlayers: numberOfPlayers)
//        
//        // then
//        XCTAssertEqual(sut.players.count, numberOfPlayers)
//        for (index, players) in sut.players.enumerated() {
//            XCTAssertEqual(players.position, index)
//        }
//    }
//    
//    
    // MARK: - changeNameOfPlayer
    
    func test_Game_WhenChangeNameCalled_ShouldChangePlayerNameToNewName() {
        // given
        let sut = Game(basicGameWithContext: context)
        
        let player = Player(game: sut, name: "", position: 0, context: context)
        let playerName = UUID().uuidString
        
        // when
        sut.changeName(of: player, to: playerName)
        
        // then
        XCTAssertEqual(player.name, playerName)
    }


//    // MARK: - MovePlayerAt
//    
//    func test_Game_WhenMovePlayerAtSourceCalledOutOfRange_ShouldDoNothing() {
//        // given
//        let player1 = Player(name: UUID().uuidString, position: 0)
//        let player2 = Player(name: UUID().uuidString, position: 0)
//        let players = [player1, player2]
//        var sut = Game(basicGameWithPlayers: players)
//        
//        // when
//        sut.movePlayerAt(4, to: 0)
//        
//        // then
//        XCTAssertEqual(sut.players as? [Player], players)
//    }
//    
//    func test_Game_WhenMovePlayerAtDestinationCalledOutOfRange_ShouldDoNothing() {
//        // given
//        let player1 = Player(name: UUID().uuidString, position: 0)
//        let player2 = Player(name: UUID().uuidString, position: 0)
//        let players = [player1, player2]
//        var sut = Game(basicGameWithPlayers: players)
//        
//        // when
//        sut.movePlayerAt(0, to: 5)
//        
//        // then
//        XCTAssertEqual(sut.players as? [Player], players)
//    }
//    
//    func test_Game_WhenMovePlayerAtCalledInRange_ShouldChangePlayersPositionAndPositionValues() {
//        // given
//        let player1Name = UUID().uuidString
//        let player1 = Player(name: player1Name, position: 0)
//        
//        let player2Name = UUID().uuidString
//        let player2 = Player(name: player2Name, position: 1)
//        
//        let player3Name = UUID().uuidString
//        let player3 = Player(name: player3Name, position: 2)
//        
//        let players = [player1, player2, player3]
//        
//        var sut = Game(basicGameWithPlayers: players)
//        
//        // when
//        sut.movePlayerAt(2, to: 0)
//        
//        // then
//        XCTAssertEqual(sut.players[0].name, player3Name)
//        XCTAssertEqual(sut.players[0].position, 0)
//        XCTAssertEqual(sut.players[1].name, player1Name)
//        XCTAssertEqual(sut.players[1].position, 1)
//        XCTAssertEqual(sut.players[2].name, player2Name)
//        XCTAssertEqual(sut.players[2].position, 2)
//    }
//
//
    // MARK: - AddPlayer
    
    func test_Game_WhenAddPlayerCalled_ShouldCreateANewPlayerInGame() {
        let sut = Game(basicGameWithContext: context)
        
        // when
        sut.addPlayer(withName: "")
        
        // then
        XCTAssertEqual(sut.players.count, 1)
    }
    
    func test_Game_WhenAddPlayerCalled_ShouldSetPlayerPositionAndNameCorrectly() {
        let sut = Game(basicGameWithContext: context)
        
        let count = Int.random(in: 3...5)
        
        for i in 0..<count {
            _ = Player(game: sut, name: "", position: 0, context: context)
        }
        
        let playerName = UUID().uuidString
        // when
        sut.addPlayer(withName: playerName)
        
        // then
        XCTAssertEqual(sut.players.count, count + 1)
        XCTAssertEqual(sut.players.last?.position, count)
        XCTAssertEqual(sut.players.last?.name, playerName)
    }
    

    // MARK: - RandomizePlayers
//
//    func test_Game_WhenRandomizeCalled_ShouldRandomizePlayersAndSetTheirPosition() {
//        // given
//        var players = [Player]()
//        for i in 1...5 {
//            players.append(Player(name: "\(i)", position: 0))
//        }
//        var sut = Game(basicGameWithPlayers: players)
//        
//        // when
//        sut.randomizePlayers()
//        
//        // then
//        XCTAssertNotEqual(sut.players as? [Player], players)
//        
//        for player in players {
//            XCTAssertNotNil(sut.players.first(where: { $0.name == player.name }))
//        }
//        
//        for (index, player) in sut.players.enumerated() {
//            XCTAssertEqual(player.position, index)
//        }
//    }
//    
//    
    // MARK: - DeletePlayer
    
    func test_Game_WhenDeletePlayerCalled_ShouldCallRemoveFromPlayersFunction() {
        
        class GameRemoveFromPlayersMock: GamePropertyMock {
            var removeFromPlayersCalledCount = 0
            var removeFromPlayersPlayer: Player?
            override func removeFromPlayers_(_ value: Player) {
                removeFromPlayersCalledCount += 1
                removeFromPlayersPlayer = value
            }
        }
        
        // given
        let sut = GameRemoveFromPlayersMock()
        let gameStub = Game(basicGameWithContext: context)
        
        let player = Player(game: gameStub, name: "", position: 0, context: context)
        
        // when
        sut.deletePlayer(player)
        
        // then
        XCTAssertEqual(sut.removeFromPlayersCalledCount, 1)
        XCTAssertEqual(sut.removeFromPlayersPlayer?.id, player.id)
    }
    
    func test_Game_WhenDeletePlayerCalled_ShouldCallDeleteObjectFromContext() {
        
        class GamePropertyRemoveFromPlayersMock: GamePropertyMock {
            override func removeFromPlayers_(_ value: Player) {}
        }
        
        // given
        let context = NSManagedObjectContextDeleteObjectMock()
        let sut = GamePropertyRemoveFromPlayersMock()
        sut.temporaryManagedObjectContext = context
        let player = Player(context: context)
        
        // when
        sut.deletePlayer(player)
        
        // then
        XCTAssertEqual(context.deleteNSManagedObjects.count, 1)
        XCTAssertEqual(context.deleteNSManagedObjects.first, player)
    }
    
    func test_Game_WhenDeletePlayerCalled_ShouldFixPositionsOfOtherPlayers() {
        // given
        let sut = Game(basicGameWithContext: context)
        
        let playerCount = Int.random(in: 3...8)
        for i in 0..<playerCount {
            _ = Player(game: sut, name: "", position: i, context: context)
        }
        
        let playerToRemove = sut.players.randomElement()!
        
        // when
        sut.deletePlayer(playerToRemove)
        
        // then
        XCTAssertEqual(sut.players.count, playerCount - 1)
        sut.players.enumerated().forEach { (index, player) in
            XCTAssertEqual(player.position, index)
        }
    }
    
    
    // MARK: - DeleteEndRound
    
    func test_Game_WhenDeleteEndRoundCalled_ShouldCallGameRemoveFromEndRounds() {
        
        class GameRemoveFromEndRoundsMock: GamePropertyMock {
            var removeFromEndRoundCalledCount = 0
            var removeFromEndRoundsEndRound: EndRound?
            override func removeFromEndRounds_(_ value: EndRound) {
                removeFromEndRoundCalledCount += 1
                removeFromEndRoundsEndRound = value
            }
        }
        
        // given
        let sut = GameRemoveFromEndRoundsMock()
        let gameStub = Game(basicGameWithContext: context)
        let endRound = EndRound(game: gameStub, roundNumber: 0, scoreChanges: [], context: context)
        
        // when
        sut.deleteEndRound(endRound)
        
        // then
        XCTAssertEqual(sut.removeFromEndRoundCalledCount, 1)
        XCTAssertEqual(sut.removeFromEndRoundsEndRound, endRound)
    }
    
    func test_Game_WhenDeleteEndRoundCalled_ShouldCallDeleteObjectFromContext() {
        
        class GamePropertyRemoveFromEndRoundsMock: GamePropertyMock {
            override func removeFromEndRounds_(_ value: EndRound) {}
        }
        
        // given
        let context = NSManagedObjectContextDeleteObjectMock()
        let sut = GamePropertyRemoveFromEndRoundsMock()
        sut.temporaryManagedObjectContext = context
        let endRound = EndRound(context: context)
        
        // when
        sut.deleteEndRound(endRound)
        
        // then
        XCTAssertEqual(context.deleteNSManagedObjects.count, 1)
        XCTAssertEqual(context.deleteNSManagedObjects.first, endRound)
    }
    
    func test_Game_WhenDeleteEndRoundCalled_ShouldFixEndRoundsRoundNumberValues() {
        // given
        let sut = Game(basicGameWithContext: context)
        
        sut.endRound(with: EndRoundSettings(scoreChangeSettingsArray: [], roundNumber: 1))
        sut.endRound(with: EndRoundSettings(scoreChangeSettingsArray: [], roundNumber: 2))
        sut.endRound(with: EndRoundSettings(scoreChangeSettingsArray: [], roundNumber: 3))
        sut.endRound(with: EndRoundSettings(scoreChangeSettingsArray: [], roundNumber: 4))
        
        // when
        sut.deleteEndRound(sut.endRounds[2] as! EndRound)
        
        // then
        XCTAssertEqual(sut.endRounds.count, 3)
        XCTAssertEqual(sut.endRounds[0].roundNumber, 1)
        XCTAssertEqual(sut.endRounds[1].roundNumber, 2)
        XCTAssertEqual(sut.endRounds[2].roundNumber, 3)
    }

    
    // MARK: - DeleteScoreChange
    
    func test_Game_WhenDeleteScoreChangeCalled_ShouldCallGameRemoveFromScoreChanges() {
        class GameRemoveFromScoreChangesMock: GamePropertyMock {
            var removeFromScoreChangesCalledCount = 0
            var removeFromScoreChangesScoreChange: ScoreChange?
            override func removeFromScoreChanges_(_ value: ScoreChange) {
                removeFromScoreChangesCalledCount += 1
                removeFromScoreChangesScoreChange = value
            }
        }
        
        // given
        let sut = GameRemoveFromScoreChangesMock()
        let scoreChange = ScoreChange(context: context)
        
        // when
        sut.deleteScoreChange(scoreChange)
        
        // then
        XCTAssertEqual(sut.removeFromScoreChangesCalledCount, 1)
        XCTAssertEqual(sut.removeFromScoreChangesScoreChange, scoreChange)
    }
    
    func test_Game_WhenDeleteScoreChangeCalled_ShouldCallDeleteObjectFromContext() {
        
        class GamePropertyRemoveFromScoreChangesMock: GamePropertyMock {
            override func removeFromScoreChanges_(_ value: ScoreChange) {}
        }
        
        // given
        let context = NSManagedObjectContextDeleteObjectMock()
        let sut = GamePropertyRemoveFromScoreChangesMock()
        sut.temporaryManagedObjectContext = context
        let scoreChange = ScoreChange(context: context)
        
        // when
        sut.deleteScoreChange(scoreChange)
        
        // then
        XCTAssertEqual(context.deleteNSManagedObjects.count, 1)
        XCTAssertEqual(context.deleteNSManagedObjects.first, scoreChange)
    }
    
    func test_Game_WhenDeleteScoreChangesCalled_ShouldFixPositionsOfOtherScoreChanges() {
        // given
        let sut = Game(basicGameWithContext: context)
        
        let scoreChangeCount = Int.random(in: 3...8)
        for i in 0..<scoreChangeCount {
            _ = ScoreChange(player: Player(game: sut, name: "", position: 0, context: context),
                            scoreChange: 0,
                            position: i,
                            game: sut,
                            context: context)
        }
        
        let scoreChangeToRemove = sut.scoreChanges.randomElement()!
        
        // when
        sut.deleteScoreChange(scoreChangeToRemove as! ScoreChange)
        
        // then
        XCTAssertEqual(sut.scoreChanges.count, scoreChangeCount - 1)
        sut.scoreChanges.enumerated().forEach { (index, scoreChange) in
            XCTAssertEqual(scoreChange.position, index)
        }
    }

    
    // MARK: - Winning Players
    
    func test_Game_WhenWinningPlayersIsReadOnePlayerWithTopScore_ShouldReturnArrayWithThatPlayer() {
        
        // given
        let sut = GamePropertyMock()
        
        let player1 = PlayerMock(name: "", position: 0, score: 1)
        let player2 = PlayerMock(name: "", position: 0, score: 2)
        let player3 = PlayerMock(name: "", position: 0, score: 3)
        sut.temporaryPlayerArray = [player1, player2, player3]
        
        
        // when
        let winningPlayers = sut.winningPlayers as? [PlayerMock]
        
        // then
        XCTAssertEqual(winningPlayers, [player3])
    }
    
    func test_Game_WhenWinningPlayersIsReadMultiplePlayersWithTopScore_ShouldReturnArrayWithThosePlayers() {
        
        // given
        let sut = GamePropertyMock()
        
        let player1 = PlayerMock(name: "", position: 0, score: 1)
        let player2 = PlayerMock(name: "", position: 0, score: 2)
        let player3 = PlayerMock(name: "", position: 0, score: 2)
        
        sut.temporaryPlayerArray = [player1, player2, player3]
        
        // when
        guard let winningPlayers = sut.winningPlayers as? [PlayerMock] else {
            XCTFail("object not present")
            return
        }
        
        // then
        XCTAssertEqual(winningPlayers.count, 2)
        XCTAssertTrue(winningPlayers.contains(player2))
        XCTAssertTrue(winningPlayers.contains(player3))
    }

    
    // MARK: - isEqualTo
    
    func test_Game_WhenIsEqualToCalledDifferentIDs_ShouldReturnFalse() {
        // given
        let sut = Game(basicGameWithContext: context)
        let secondGame = GameMock()
        secondGame.id = UUID()
        
        // when
        let bool = sut.isEqualTo(game: secondGame)
        
        // then
        XCTAssertFalse(bool)
    }
    
    func test_Game_WhenIsEqualToCalledSameIDs_ShouldReturnTrue() {
        // given
        let sut = Game(basicGameWithContext: context)
        let secondGame = GameMock()
        secondGame.id = sut.id
        
        // when
        let bool = sut.isEqualTo(game: secondGame)
        
        // then
        XCTAssertTrue(bool)
    }
    
    
    // MARK: - ChangeScore
    
    func test_Game_WhenChangeScoreCalledPlayerNotInGame_ShouldNotCreateScoreChangeInContext() {
        // given
        let sut = Game(basicGameWithContext: context)
        
        let playerMock = PlayerMock()
        let scoreChangeSettings = ScoreChangeSettings(player: playerMock, scoreChange: 0)
        
        // when
        sut.changeScore(with: scoreChangeSettings)
        
        // then
        
        do {
            let scoreChanges = try context.fetch(ScoreChange.fetchRequest()) as? [ScoreChange]
            XCTAssertEqual(scoreChanges?.count, 0)
        } catch {
            XCTFail("scoreChanges couldn't be loaded from view context \(error)")
        }
    }
    
    func test_Game_WhenChangeScoreCalledPlayerInGame_ShouldCreateScoreChangeInContextWithCorrectPlayerGameAndScoreChangeInt() {
        // given
        let sut = Game(basicGameWithContext: context)
        
        let player = Player(game: sut, name: "", position: 0, context: context)
        let scoreChangeInt = Int.random(in: 1...10)
        let scoreChangeSettings = ScoreChangeSettings(player: player, scoreChange: scoreChangeInt)
        
        // when
        sut.changeScore(with: scoreChangeSettings)
        
        // then
        
        do {
            let scoreChanges = try context.fetch(ScoreChange.fetchRequest()) as? [ScoreChange]
            XCTAssertEqual(scoreChanges?.count, 1)
            XCTAssertEqual(scoreChanges?.first?.game, sut)
            XCTAssertEqual(scoreChanges?.first?.scoreChange, scoreChangeInt)
            XCTAssertEqual(scoreChanges?.first?.player as? Player, player)
        } catch {
            XCTFail("scoreChanges couldn't be loaded from view context \(error)")
        }
    }
    
    func test_Game_WhenChangeScoreCalled_ShouldAddScoreChangeToPlayerAndGame() {
        // given
        let sut = Game(basicGameWithContext: context)
        let player = Player(game: sut, name: "", position: 0, context: context)
        
        let scoreChangeSettings = ScoreChangeSettings(player: player, scoreChange: 0)
        
        // when
        sut.changeScore(with: scoreChangeSettings)
        
        // then
        XCTAssertEqual(player.scoreChanges.count, 1)
        XCTAssertEqual(player.game.scoreChanges.count, 1)
    }
    
    func test_Game_WhenChangeScoreCalled_ShouldSetScoreChangePosition() {
        // given
        let sut = Game(basicGameWithContext: context)
        let player = Player(game: sut, name: "", position: 0, context: context)
        
        let scoreChangeSettings = ScoreChangeSettings(player: player, scoreChange: 0)
        
        // when
        sut.changeScore(with: scoreChangeSettings)
        sut.changeScore(with: scoreChangeSettings)
        sut.changeScore(with: scoreChangeSettings)
        
        // then
        XCTAssertEqual(sut.scoreChanges[0].position, 0)
        XCTAssertEqual(sut.scoreChanges[1].position, 1)
        XCTAssertEqual(sut.scoreChanges[2].position, 2)
    }

    
    // MARK: - EndRound
    
    func test_Game_WhenEndRoundCalled_ShouldAddEndRoundToGame() {
        // given
        let sut = Game(basicGameWithContext: context)
        
        // when
        sut.endRound(with: EndRoundSettings(scoreChangeSettingsArray: [], roundNumber: 0))
        
        // then
        XCTAssertEqual(sut.endRounds.count, 1)
    }
    
    func test_Game_WhenEndRoundCalled_ShouldIncrementTheCurrentRound() {
        // given
        let sut = Game(basicGameWithContext: context)
        
        let currentRound = Int.random(in: 1...10)
        sut.currentRound = currentRound
        
        // when
        sut.endRound(with: EndRoundSettings(scoreChangeSettingsArray: [], roundNumber: currentRound))
        
        // then
        XCTAssertEqual(sut.currentRound, currentRound + 1)
    }
    
    func test_Game_WhenEndRoundCalled_ShouldCreateScoreChangesForEachScoreChangeSettings() {
        // given
        let sut = Game(basicGameWithContext: context)
        
        let player1 = Player(game: sut, name: "", position: 0, context: context)
        let player2 = Player(game: sut, name: "", position: 0, context: context)
        
        let scoreChangeSetting1 = ScoreChangeSettings(player: player1)
        let scoreChangeSetting2 = ScoreChangeSettings(player: player2)
        
        let endRoundSettings = EndRoundSettings(scoreChangeSettingsArray: [scoreChangeSetting1, scoreChangeSetting2], roundNumber: 0)
        
        // when
        sut.endRound(with: endRoundSettings)
        
        // then
        do {
            let scoreChanges = try context.fetch(ScoreChange.fetchRequest()) as? [ScoreChange]
            XCTAssertEqual(scoreChanges?.count, 2)
        } catch {
            XCTFail("scoreChanges couldn't be loaded from view context \(error)")
        }
    }
    
    func test_Game_WhenEndRoundCalled_ShouldCreateScoreChangesWithCorrectScoreChange() {
        // given
        let sut = Game(basicGameWithContext: context)
        
        let scoreChangeInt = Int.random(in: 2...100)
        
        let player1 = Player(game: sut, name: "", position: 0, context: context)
        let scoreChangeSetting1 = ScoreChangeSettings(player: player1, scoreChange: scoreChangeInt)
        let endRoundSettings = EndRoundSettings(scoreChangeSettingsArray: [scoreChangeSetting1], roundNumber: 0)
        
        // when
        sut.endRound(with: endRoundSettings)
        
        // then
        do {
            let scoreChanges = try context.fetch(ScoreChange.fetchRequest()) as? [ScoreChange]
            XCTAssertEqual(scoreChanges?.first?.scoreChange, scoreChangeInt)
        } catch {
            XCTFail("scoreChanges couldn't be loaded from view context \(error)")
        }
    }
    
    func test_Game_WhenEndRoundCalled_ShouldAddScoreChangesToPlayersAndEndRoundWithPositions() {
        // given
        let sut = Game(basicGameWithContext: context)
        
        let player1 = Player(game: sut, name: "", position: 0, context: context)
        let player2 = Player(game: sut, name: "", position: 1, context: context)
        let scoreChangeSettings1 = ScoreChangeSettings(player: player1)
        let scoreChangeSettings2 = ScoreChangeSettings(player: player2)
        
        let endRoundSettings = EndRoundSettings(scoreChangeSettingsArray: [scoreChangeSettings1, scoreChangeSettings2], roundNumber: 0)
        
        // when
        sut.endRound(with: endRoundSettings)
        
        // then
        XCTAssertEqual(player1.scoreChanges.count, 1)
        XCTAssertEqual(player2.scoreChanges.count, 1)
        XCTAssertEqual(sut.endRounds.first?.scoreChanges.count, 2)
        XCTAssertEqual(sut.endRounds.first?.scoreChanges[0].position, 0)
        XCTAssertEqual(sut.endRounds.first?.scoreChanges[1].position, 1)
    }

    
    // MARK: - UpdateSettings
    
    func test_Game_WhenUpdateSettingsCalled_ShouldSetGameEndTypeEndingScoreAndNumberOfRoundsToNewValue() {
        // given
        var sut = Game(basicGameWithContext: context)
        
        let gameEndType = GameEndType(rawValue: Int.random(in: 1...2))!
        let endingScore = Int.random(in: 15...1000)
        let numbeOfRounds = Int.random(in: 15...1000)
        
        // when
        sut.updateSettings(with: gameEndType, endingScore: endingScore, andNumberOfRounds: numbeOfRounds)
        
        // then
        XCTAssertEqual(sut.gameEndType, gameEndType)
        XCTAssertEqual(sut.numberOfRounds, numbeOfRounds)
        XCTAssertEqual(sut.endingScore, endingScore)
    }
    
    
    // MARK: - IsEndOfGame
    
    func test_Game_WhenIsEndOfGameCalledNoneEndGameType_ShouldReturnFalse() {
        // given
        let sut = Game(gameType: .basic, gameEndType: .none, players: [], context: context)
        
        // when
        let isEndOfGame = sut.isEndOfGame()
        
        // then
        XCTAssertFalse(isEndOfGame)
    }
    
    func test_Game_WhenIsEndOfGameCalledRoundEndGameTypeCurrentRoundLessThanNumberOfRounds_ShouldReturnFalse() {
        // given
        var sut = Game(gameType: .round, gameEndType: .round, players: [], context: context)
        sut.currentRound = 0
        sut.numberOfRounds = 4
        
        // when
        let isEndOfGame = sut.isEndOfGame()
        
        // then
        XCTAssertFalse(isEndOfGame)
    }
    
    func test_Game_WhenIsEndOfGameCalledRoundEndGameTypeCurrentRoundEqualToNumberOfRounds_ShouldReturnFalse() {
        // given
        var sut = Game(gameType: .round, gameEndType: .round, players: [], context: context)
        sut.currentRound = 4
        sut.numberOfRounds = 4
        
        // when
        let isEndOfGame = sut.isEndOfGame()
        
        // then
        XCTAssertFalse(isEndOfGame)
    }
    
    func test_Game_WhenIsEndOfGameCalledRoundEndGameTypeCurrentRoundMoreThanNumberOfRounds_ShouldReturnTrue() {
        // given
        var sut = Game(gameType: .round, gameEndType: .round, players: [], context: context)
        sut.currentRound = 5
        sut.numberOfRounds = 4
        
        // when
        let isEndOfGame = sut.isEndOfGame()
        
        // then
        XCTAssertTrue(isEndOfGame)
    }
    
    func test_Game_WhenIsEndOfGameCalledScoreEndGameTypePlayersDontHaveEqualOrMoreThanEndingScore_ShouldReturnFalse() {
        // given
        var sut = GamePropertyMock()

        sut.gameType = .round
        sut.gameEndType = .score
        let player = PlayerMock(score: 0)
        sut.temporaryPlayerArray = [player]
        sut.endingScore = 100
        
        // when
        let isEndOfGame = sut.isEndOfGame()
        
        // then
        XCTAssertFalse(isEndOfGame)
    }
    
    func test_Game_WhenIsEndOfGameCalledScoreEndGameTypePlayersDontHaveEqualOrMoreThanWinningScore_ShouldReturnTrue() {
        // given
        var sut = GamePropertyMock()

        sut.gameType = .round
        sut.gameEndType = .score
        let player = PlayerMock(score: 100)
        sut.temporaryPlayerArray = [player]
        sut.endingScore = 100
        
        // when
        let isEndOfGame = sut.isEndOfGame()
        
        // then
        XCTAssertTrue(isEndOfGame)
    }
    
    
    // MARK: - ResetGame
    
    func test_Game_WhenResetGameCalled_ShouldCallDeleteOnGamesContextForEachScoreChange() {
        // given
        
        let contextMock = NSManagedObjectContextDeleteObjectMock()
        
        var sut = GamePropertyMock()
        sut.temporaryManagedObjectContext = contextMock
        
        let scoreChange1 = ScoreChange()
        let scoreChange2 = ScoreChange()
        sut.temporaryScoreChangeArray = [scoreChange1, scoreChange2]
        
        // when
        sut.resetGame()
        
        // then
        XCTAssertEqual(contextMock.deleteNSManagedObjects.count, 2)
        XCTAssertTrue(contextMock.deleteNSManagedObjects[0] is ScoreChange)
        XCTAssertTrue(contextMock.deleteNSManagedObjects[1] is ScoreChange)
    }
    
    func test_Game_WhenResetGameCalled_ShouldCallDeleteOnGamesContextForEachEndRound() {
        // given
        
        let contextMock = NSManagedObjectContextDeleteObjectMock()
        
        var sut = GamePropertyMock()
        sut.temporaryManagedObjectContext = contextMock
        
        let endRound1 = EndRound()
        let endRound2 = EndRound()
        sut.temporaryEndRoundsArray = [endRound1, endRound2]
        
        // when
        sut.resetGame()
        
        // then
        XCTAssertEqual(contextMock.deleteNSManagedObjects.count, 2)
        XCTAssertTrue(contextMock.deleteNSManagedObjects[0] is EndRound)
        XCTAssertTrue(contextMock.deleteNSManagedObjects[1] is EndRound)
    }
    
    func test_Game_WhenResetGameCalled_ShouldSetCurrentRoundTo1() {
        // given
        var sut = GamePropertyMock()
        sut.currentRound = 5
        
        // when
        sut.resetGame()
        
        // then
        XCTAssertEqual(sut.currentRound, 1)
    }

//    // MARK: - EditScoreChange
//    
//    func test_Game_WhenEditScoreChangeCalled_ShouldEditPlayerScoreChangeToNewValue() {
//        // given
//        let player1 = Player.getBasicPlayer()
//        let scoreChangeOriginalChange = Int.random(in: 0...1000)
//        
//        var scoreChangeObject = ScoreChange(player: player1, scoreChange: scoreChangeOriginalChange)
//        
//        player1.scoreChanges = [scoreChangeObject]
//        
//        var sut = Game(basicGameWithPlayers: [player1])
//        
//        let gameHistorySegmentScoreChange = GameHistorySegment.scoreChange(scoreChangeObject, player1)
//        sut.historySegments = [gameHistorySegmentScoreChange]
//        
//        let scoreChangeAfterChange = Int.random(in: 0...1000)
//        scoreChangeObject.scoreChange = scoreChangeAfterChange
//        
//        // when
//        sut.editScoreChange(scoreChangeObject)
//        
//        // then
//        XCTAssertEqual(sut.players.first?.scoreChanges.first?.scoreChange, scoreChangeAfterChange)
//    }
//    
//    func test_Game_WhenEditScoreChangeCalled_ShouldEditHistorySegmentScoreChange() {
//        // given
//        let player1 = Player.getBasicPlayer()
//        let player2 = Player.getBasicPlayer()
//        let players = [player1, player2]
//        
//        var sut = Game(basicGameWithPlayers: players)
//        sut.players = [player1, player2]
//        
//        let indexOfPlayer = Int.random(in: 0...1)
//        var scoreChangeObject = ScoreChange(player: players[indexOfPlayer], scoreChange: 0)
//        players[indexOfPlayer].scoreChanges = [scoreChangeObject]
//        let gameHistorySegmentScoreChange = GameHistorySegment.scoreChange(scoreChangeObject, players[indexOfPlayer])
//        sut.historySegments = [gameHistorySegmentScoreChange]
//        
//        let scoreChangeAfterChange = Int.random(in: 0...1000)
//        scoreChangeObject.scoreChange = scoreChangeAfterChange
//        
//        // when
//        sut.editScoreChange(scoreChangeObject)
//        
//        // then
//        guard case GameHistorySegment.scoreChange(let newScoreChange, _) = sut.historySegments.first! else {
//            XCTFail("The history segment should be a score change")
//            return
//        }
//        
//        XCTAssertEqual(newScoreChange.scoreChange, scoreChangeAfterChange)
//    }
//    
//    func test_Game_WhenEditScoreChangeCalled_ShouldSetScoreChangeHistorySegmentPlayerToPlayer() {
//        // given
//        let player = PlayerMock()
//        
//        var sut = Game(basicGameWithPlayers: [player])
//        let scoreChange = ScoreChange(player: player, scoreChange: 0)
//        player.scoreChanges = [scoreChange]
//        sut.historySegments = [GameHistorySegment.scoreChange(scoreChange, player)]
//        
//        // when
//        sut.editScoreChange(scoreChange)
//        
//        // then
//        guard case GameHistorySegment.scoreChange(_, let playerFromSegment) = sut.historySegments.first! else {
//            XCTFail("The history segment should be a score change")
//            return
//        }
//        
//        XCTAssertEqual(player.id, playerFromSegment.id)
//    }
//    
//    
//    // MARK: - EditEndRound
//    
//    func test_Game_WhenEditEndRoundCalled_ShouldEditPlayersScoreChanges() {
//        // given
//        let player1 = Player.getBasicPlayer()
//        let player2 = Player.getBasicPlayer()
//        let players = [player1, player2]
//        
//        var sut = Game(basicGameWithPlayers: players)
//        
//        var scoreChangeObjects = [
//            ScoreChange(player: player1, scoreChange: 0),
//            ScoreChange(player: player2, scoreChange: 0)
//        ]
//        
//        player1.scoreChanges = [scoreChangeObjects[0]]
//        player2.scoreChanges = [scoreChangeObjects[1]]
//        
//        var endRound = EndRound(roundNumber: 0, scoreChangeArray: scoreChangeObjects)
//        let gameHistorySegment = GameHistorySegment.endRound(endRound, [])
//        sut.historySegments = [gameHistorySegment]
//        
//        let scoreChangePointAfters = [
//            Int.random(in: 1...1000),
//            Int.random(in: 1...1000)
//        ]
//        
//        scoreChangeObjects[0].scoreChange = scoreChangePointAfters[0]
//        scoreChangeObjects[1].scoreChange = scoreChangePointAfters[1]
//        
//        endRound.scoreChangeArray = scoreChangeObjects
//        
//        // when
//        sut.editEndRound(endRound)
//        
//        // then
//        XCTAssertEqual(sut.players[0].scoreChanges.first?.scoreChange, scoreChangePointAfters[0])
//        XCTAssertEqual(sut.players[1].score, scoreChangePointAfters[1])
//    }
//    
//    func test_Game_WhenEditEndRoundCalled_ShouldSetEndRoundGameHistoryObjectScoreChanges() {
//        // given
//        let player1 = Player.getBasicPlayer()
//        var sut = Game(basicGameWithPlayers: [player1])
//        
//        var endRound = EndRound(roundNumber: 0, scoreChangeArray: [])
//        let endRoundHistoryObject = GameHistorySegment.endRound(endRound, [])
//        sut.historySegments = [endRoundHistoryObject]
//        
//        let scoreChangeInt = Int.random(in: 1...1000)
//        var scoreChangeObject = ScoreChange(player: player1, scoreChange: 0)
//        player1.scoreChanges = [scoreChangeObject]
//        
//        scoreChangeObject.scoreChange = scoreChangeInt
//        
//        endRound.scoreChangeArray = [scoreChangeObject]
//        
//        // when
//        sut.editEndRound(endRound)
//        
//        // then
//        guard case .endRound(let newEndRound, _) = sut.historySegments[0] else {
//            XCTFail("History Segment not present")
//            return
//        }
//        
//        XCTAssertEqual(newEndRound.scoreChangeArray, [scoreChangeObject])
//    }
//    
//    func test_Game_WhenEditEndRoundCalled_ShouldSetEndRoundHistorySegmentPlayersToPlayersInScoreChange() {
//        // given
//        let player1 = PlayerMock()
//        let player2 = PlayerMock()
//        
//        var sut = Game(basicGameWithPlayers: [player1, player2])
//        
//        let scoreChange1 = ScoreChange(player: player1, scoreChange: 0)
//        player1.scoreChanges = [scoreChange1]
//        
//        let scoreChange2 = ScoreChange(player: player2, scoreChange: 0)
//        player2.scoreChanges = [scoreChange2]
//        
//        let endRound = EndRound(roundNumber: 0, scoreChangeArray: [scoreChange1, scoreChange2])
//        let endRoundHistorySegment = GameHistorySegment.endRound(endRound, [])
//        
//        sut.historySegments = [
//            endRoundHistorySegment
//        ]
//        
//        // when
//        sut.editEndRound(endRound)
//        
//        // then
//        guard case .endRound(_, let playersFromSegment) = sut.historySegments[0] else {
//            XCTFail("History Segment not present")
//            return
//        }
//        XCTAssertEqual(playersFromSegment[0].id, player1.id)
//        XCTAssertEqual(playersFromSegment[1].id, player2.id)
//    }
    
    
    // MARK: - Classes
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
    
    var editScoreChangeScoreChange: ScoreChangeProtocol?
    var editScoreChangeCalledCount = 0
    func editScoreChange(_ scoreChange: ScoreChangeProtocol) {
        editScoreChangeScoreChange = scoreChange
        editScoreChangeCalledCount += 1
    }
    
    var editEndRoundCalledCount = 0
    var editEndRoundEndRound: EndRoundProtocol?
    func editEndRound(_ newEndRound: EndRoundProtocol) {
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
