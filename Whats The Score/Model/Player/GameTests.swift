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
    
    // MARK: - awakeFromInsert
    
    func test_Game_WhenAwakeFromInsertCalled_ShouldSetLastModifiedDate() {
        // given
        let sut = Game(context: context)
        
        // when
        sut.awakeFromInsert()
        
        // then
        XCTAssertNotNil(sut.lastModified)
    }
    
    
    // MARK: - willSave
    
    func test_Game_WhenWillSaveCalledIsUpdatedTrue_ShouldUpdateDateObjectToCurrentDate() {
        // given
        let sut = GamePropertyMock()
        sut.lastModified = Date(timeIntervalSince1970: 0)
        sut.temporaryIsUpdated = true
        
        
        // when
        sut.willSave()
        
        // then
        XCTAssertEqual(Date().timeIntervalSince1970, sut.lastModified.timeIntervalSince1970, accuracy: 2)
    }
    
    func test_Game_WhenWillSaveCalledIsUpdatedFalse_ShouldNotDateObjectToCurrentDate() {
        // given
        let sut = GamePropertyMock()
        sut.lastModified = Date(timeIntervalSince1970: 0)
        sut.temporaryIsUpdated = false
        
        
        // when
        sut.willSave()
        
        // then
        XCTAssertEqual(0, sut.lastModified.timeIntervalSince1970)
    }
    
    // MARK: - EditPlayer
    
    func test_Game_WhenWhenEditPlayerCalled_ShouldChangePlayerNameToNewName() {
        // given
        let sut = Game(basicGameWithContext: context)
        let player = Player(game: sut, name: "", position: 0, icon: .alien, context: context)
        
        let playerName = UUID().uuidString
        let playerSettings = PlayerSettings.getStub(name: playerName, id: player.id)
        
        // when
        sut.editPlayer(playerSettings)
        
        // then
        XCTAssertEqual(player.name, playerName)
    }
    
    func test_Game_WhenWhenEditPlayerCalled_ShouldChangePlayerIconToIconName() {
        // given
        let sut = Game(basicGameWithContext: context)
        let player = Player(game: sut, name: "", position: 0, icon: .alien, context: context)
        
        var playerIcon = PlayerIcon.allCases.randomElement()!
        while playerIcon == .alien { playerIcon = PlayerIcon.allCases.randomElement()! }
        
        
        let playerSettings = PlayerSettings.getStub(icon: playerIcon, id: player.id)
        
        // when
        sut.editPlayer(playerSettings)
        
        // then
        XCTAssertEqual(player.icon, playerIcon)
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
        sut.addPlayer(withSettings: PlayerSettings.getStub())
        
        // then
        XCTAssertEqual(sut.players.count, 1)
    }
    
    func test_Game_WhenAddPlayerCalled_ShouldSetPlayerPositionAndNameCorrectly() {
        let sut = Game(basicGameWithContext: context)
        
        let count = Int.random(in: 3...5)
        
        for _ in 0..<count {
            _ = Player(game: sut, name: "", position: 0, icon: .alien, context: context)
        }
        
        let playerName = UUID().uuidString
        // when
        sut.addPlayer(withSettings: PlayerSettings.getStub(name: playerName))
        
        // then
        XCTAssertEqual(sut.players.count, count + 1)
        XCTAssertEqual(sut.players.last?.position, count)
        XCTAssertEqual(sut.players.last?.name, playerName)
    }
    
    func test_Game_WhenAddPlayerCalled_ShouldSetPlayerIcon() {
        let sut = Game(basicGameWithContext: context)
        let icon = PlayerIcon.allCases.randomElement()!
        
        // when
        sut.addPlayer(withSettings: PlayerSettings.getStub(icon: icon))
        
        // then
        XCTAssertEqual(sut.players.first?.icon, icon)
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
        
        let player = Player(game: gameStub, name: "", position: 0, icon: .alien, context: context)
        
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
        let player = Player()
        
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
            _ = Player(game: sut, name: "", position: i, icon: .alien, context: context)
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
        let endRound = EndRound()
        
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
    
    func test_Game_WhenDeleteEndRoundCalled_ShouldDecrementCurrentRoundNumber() {
        // given
        let sut = Game(basicGameWithContext: context)
        let currentRound = Int.random(in: 1...10)
        sut.currentRound = currentRound
        
        let endRound = EndRound(game: sut, roundNumber: 0, scoreChanges: [], context: context)
        
        // when
        sut.deleteEndRound(endRound)
        
        // then
        XCTAssertEqual(sut.currentRound, currentRound - 1)
    }
    
    func test_Game_WhenDeleteEndRoundCalled_ShouldSetPositionScoreChangesInEachEndRoundRemainingToEndRoundRoundNumber() {
        // given
        let sut = Game(basicGameWithContext: context)
            
        let player1 = Player(game: sut, name: "", position: 0, icon: .alien, context: context)
        
        sut.endRound(with: EndRoundSettings(scoreChangeSettingsArray: [ScoreChangeSettings(player: player1)], roundNumber: 1))
        sut.endRound(with: EndRoundSettings(scoreChangeSettingsArray: [ScoreChangeSettings(player: player1)], roundNumber: 2))
        sut.endRound(with: EndRoundSettings(scoreChangeSettingsArray: [ScoreChangeSettings(player: player1)], roundNumber: 3))
        sut.endRound(with: EndRoundSettings(scoreChangeSettingsArray: [ScoreChangeSettings(player: player1)], roundNumber: 4))
        
        // when
        sut.deleteEndRound(sut.endRounds[2] as! EndRound)
        
        // then
        XCTAssertEqual(sut.endRounds[0].scoreChanges.first?.position, 0)
        XCTAssertEqual(sut.endRounds[1].scoreChanges.first?.position, 1)
        XCTAssertEqual(sut.endRounds[2].scoreChanges.first?.position, 2)
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
        let scoreChange = ScoreChange()
        
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
            _ = ScoreChange(player: Player(game: sut, name: "", position: 0, icon: .alien, context: context),
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
        
        let player = Player(game: sut, name: "", position: 0, icon: .alien, context: context)
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
        let player = Player(game: sut, name: "", position: 0, icon: .alien, context: context)
        
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
        let player = Player(game: sut, name: "", position: 0, icon: .alien, context: context)
        
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
    
    func test_Game_WhenEndRoundCalled_ShouldSetEndRoundRoundToEndRoundSettingsRoundNumber() {
        // given
        let sut = Game(basicGameWithContext: context)
        let roundNumber = Int.random(in: 1...10)
        
        // when
        sut.endRound(with: EndRoundSettings(scoreChangeSettingsArray: [], roundNumber: roundNumber))
        
        // then
        XCTAssertEqual(sut.endRounds.first?.roundNumber, roundNumber)
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
        
        let player1 = Player(game: sut, name: "", position: 0, icon: .alien, context: context)
        let player2 = Player(game: sut, name: "", position: 0, icon: .alien, context: context)
        
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
        
        let player1 = Player(game: sut, name: "", position: 0, icon: .alien, context: context)
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
    
    func test_Game_WhenEndRoundCalled_ShouldAddScoreChangesToPlayersAndEndRound() {
        // given
        let sut = Game(basicGameWithContext: context)
        
        let player1 = Player(game: sut, name: "", position: 0, icon: .alien, context: context)
        let player2 = Player(game: sut, name: "", position: 1, icon: .alien, context: context)
        let scoreChangeSettings1 = ScoreChangeSettings(player: player1)
        let scoreChangeSettings2 = ScoreChangeSettings(player: player2)
        
        let endRoundSettings = EndRoundSettings(scoreChangeSettingsArray: [scoreChangeSettings1, scoreChangeSettings2], roundNumber: 0)
        
        // when
        sut.endRound(with: endRoundSettings)
        
        // then
        XCTAssertEqual(player1.scoreChanges.count, 1)
        XCTAssertEqual(player2.scoreChanges.count, 1)
        XCTAssertEqual(sut.endRounds.first?.scoreChanges.count, 2)
    }
    
    func test_Game_WhenEndRoundCalled_ShouldSetEndRoundScoreChangesPositionToRoundNumber() {
        // given
        let sut = Game(basicGameWithContext: context)
        
        let player1 = Player(game: sut, name: "", position: 0, icon: .alien, context: context)
        let player2 = Player(game: sut, name: "", position: 1, icon: .alien, context: context)
        let scoreChangeSettingsArray = [
            ScoreChangeSettings(player: player1),
            ScoreChangeSettings(player: player2)
        ]
        let roundNumber = Int.random(in: 1...10)
        let endRoundSettings = EndRoundSettings(scoreChangeSettingsArray: scoreChangeSettingsArray, roundNumber: roundNumber)
        
        // when
        sut.endRound(with: endRoundSettings)
        
        // then
        XCTAssertEqual(sut.endRounds.first?.scoreChanges.first?.position, roundNumber)
        XCTAssertEqual(sut.endRounds.first?.scoreChanges[1].position, roundNumber)
    }

    
    // MARK: - UpdateSettings
    
    func test_Game_WhenUpdateSettingsCalled_ShouldSetGameEndTypeEndingScoreAndNumberOfRoundsToNewValue() {
        // given
        let sut = Game(basicGameWithContext: context)
        
        let gameEndType = GameEndType(rawValue: Int.random(in: 1...2))!
        let endingScore = Int.random(in: 15...1000)
        let numbeOfRounds = Int.random(in: 15...1000)
        let gameName = UUID().uuidString
        
        // when
        sut.updateSettings(withGameName: gameName, gameEndType, endingScore: endingScore, andNumberOfRounds: numbeOfRounds)
        
        // then
        XCTAssertEqual(sut.gameEndType, gameEndType)
        XCTAssertEqual(sut.numberOfRounds, numbeOfRounds)
        XCTAssertEqual(sut.endingScore, endingScore)
        XCTAssertEqual(sut.name, gameName)
    }
    
    
    // MARK: - IsEndOfGame
    
    func test_Game_WhenIsEndOfGameCalledNoneEndGameType_ShouldReturnFalse() {
        // given
        let sut = Game(name: "", gameType: .basic, gameEndType: .none, players: [], context: context)
        
        // when
        let isEndOfGame = sut.isEndOfGame()
        
        // then
        XCTAssertFalse(isEndOfGame)
    }
    
    func test_Game_WhenIsEndOfGameCalledRoundEndGameTypeCurrentRoundLessThanNumberOfRounds_ShouldReturnFalse() {
        // given
        let sut = Game(name: "", gameType: .round, gameEndType: .round, players: [], context: context)
        sut.currentRound = 0
        sut.numberOfRounds = 4
        
        // when
        let isEndOfGame = sut.isEndOfGame()
        
        // then
        XCTAssertFalse(isEndOfGame)
    }
    
    func test_Game_WhenIsEndOfGameCalledRoundEndGameTypeCurrentRoundEqualToNumberOfRounds_ShouldReturnFalse() {
        // given
        let sut = Game(name: "", gameType: .round, gameEndType: .round, players: [], context: context)
        sut.currentRound = 4
        sut.numberOfRounds = 4
        
        // when
        let isEndOfGame = sut.isEndOfGame()
        
        // then
        XCTAssertFalse(isEndOfGame)
    }
    
    func test_Game_WhenIsEndOfGameCalledRoundEndGameTypeCurrentRoundMoreThanNumberOfRounds_ShouldReturnTrue() {
        // given
        let sut = Game(name: "", gameType: .round, gameEndType: .round, players: [], context: context)
        sut.currentRound = 5
        sut.numberOfRounds = 4
        
        // when
        let isEndOfGame = sut.isEndOfGame()
        
        // then
        XCTAssertTrue(isEndOfGame)
    }
    
    func test_Game_WhenIsEndOfGameCalledScoreEndGameTypePlayersDontHaveEqualOrMoreThanEndingScore_ShouldReturnFalse() {
        // given
        let sut = GamePropertyMock()

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
        let sut = GamePropertyMock()

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
    
    
    // MARK: - UndoLastAction

    func test_Game_WhenUndoLastActionCalledGameTypeIsRoundAndEndRoundExists_ShouldCallRemoveFromEndRoundsAndDeleteEndRoundAndDecrementCurrentRound() {
        // given
        class GameEndRoundMock: GamePropertyMock {
            var removeFromEndRoundsCalledCount = 0
            var removedEndRound: EndRound?
            override func removeFromEndRounds_(_ value: EndRound) {
                removeFromEndRoundsCalledCount += 1
                removedEndRound = value
            }
        }
        
        let contextDeleteMock = NSManagedObjectContextDeleteObjectMock()
        let sut = GameEndRoundMock()
        let gameMock = Game(basicGameWithContext: context)
        sut.temporaryManagedObjectContext = contextDeleteMock
        sut.gameType = .round
        let endRound = EndRound(game: gameMock, roundNumber: 0, scoreChanges: [], context: context)
        sut.temporaryEndRoundsArray = [EndRoundMock(), endRound]
        sut.currentRound = 5
        
        // when
        sut.undoLastAction()
        
        // then
        XCTAssertEqual(sut.removeFromEndRoundsCalledCount, 1)
        XCTAssertEqual(sut.removedEndRound, endRound)
        XCTAssertTrue(contextDeleteMock.deleteNSManagedObjects.contains(where: { $0 as? EndRound === endRound }))
        XCTAssertEqual(sut.currentRound, 4)
    }
    
    func test_Game_WhenUndoLastActionCalledGameTypeIsBasicAndLastScoreChangeExists_ShouldCallRemoveFromScoreChangesAndDeleteScoreChange() {
        // given
        class GameScoreChangeMock: GamePropertyMock {
            var removeFromScoreChangesCalledCount = 0
            var removedScoreChange: ScoreChange?
            override func removeFromScoreChanges_(_ value: ScoreChange) {
                removeFromScoreChangesCalledCount += 1
                removedScoreChange = value
            }
        }
        
        let contextDeleteMock = NSManagedObjectContextDeleteObjectMock()
        let sut = GameScoreChangeMock()
        let gameMock = Game(basicGameWithContext: context)
        let playerMock = Player(game: gameMock, name: "", position: 0, icon: .alien, context: context)
        sut.temporaryManagedObjectContext = contextDeleteMock
        sut.gameType = .basic
        let scoreChange = ScoreChange(player: playerMock, scoreChange: 0, position: 0, context: context)
        sut.temporaryScoreChangeArray = [ScoreChangeMock(), scoreChange] // Ensure it's the last one
        
        // when
        sut.undoLastAction()
        
        // then
        XCTAssertEqual(sut.removeFromScoreChangesCalledCount, 1)
        XCTAssertEqual(sut.removedScoreChange, scoreChange)
        XCTAssertTrue(contextDeleteMock.deleteNSManagedObjects.contains(where: { $0 as? ScoreChange === scoreChange }))
    }
    
    
    // MARK: - ResetGame
    
    func test_Game_WhenResetGameCalled_ShouldCallDeleteOnGamesContextForEachScoreChange() {
        // given
        
        let contextMock = NSManagedObjectContextDeleteObjectMock()
        
        let sut = GamePropertyMock()
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
        
        let sut = GamePropertyMock()
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
        let sut = GamePropertyMock()
        sut.currentRound = 5
        
        // when
        sut.resetGame()
        
        // then
        XCTAssertEqual(sut.currentRound, 1)
    }

    // MARK: - EditScoreChange
    
    func test_Game_WhenEditScoreChangeCalledPlayerHasScoreChange_ShouldChangeScoreChangesScoreChangeValue() {
        // given
        let sut = Game(basicGameWithContext: context)
        let player = Player(game: sut, name: "", position: 0, icon: .alien, context: context)
        let scoreChange = ScoreChange(player: player, scoreChange: 0, position: 0, game: sut, context: context)
        let newScoreChangeInt = Int.random(in: 1...10)
        
        let scoreChangeSettings = ScoreChangeSettings(player: player, scoreChange: newScoreChangeInt, scoreChangeID: scoreChange.id)
        
        // when
        sut.editScoreChange(scoreChangeSettings)
        
        // then
        XCTAssertEqual(scoreChange.scoreChange, newScoreChangeInt)
    }
    

    // MARK: - EditEndRound
    
    func test_Game_WhenEditEndRoundCalledEndRoundInGame_ShouldChangeEachOfTheScoreChangesToNewInts() {
        // given
        let sut = Game(basicGameWithContext: context)
        let endRound = EndRound(game: sut, roundNumber: 0, scoreChanges: [], context: context)
        
        let player1 = Player(game: sut, name: "", position: 0, icon: .alien, context: context)
        let player2 = Player(game: sut, name: "", position: 0, icon: .alien, context: context)
        let scoreChange1 = ScoreChange(player: player1, scoreChange: 0, position: 0, endRound: endRound, context: context)
        let scoreChange2 = ScoreChange(player: player2, scoreChange: 0, position: 0, endRound: endRound, context: context)
        
        let scoreChangeNewInt1 = Int.random(in: 1...100)
        let scoreChangeNewInt2 = Int.random(in: 1...100)
        
        let scoreChangeSettings = [
            ScoreChangeSettings(player: player1, scoreChange: scoreChangeNewInt1, scoreChangeID: scoreChange1.id),
            ScoreChangeSettings(player: player2, scoreChange: scoreChangeNewInt2, scoreChangeID: scoreChange2.id)
        ]
        
        let endRoundSettings = EndRoundSettings(scoreChangeSettingsArray: scoreChangeSettings, roundNumber: 0, endRoundID: endRound.id)
        
        // when
        sut.editEndRound(endRoundSettings)
        
        // then
        XCTAssertEqual(scoreChange1.scoreChange, scoreChangeNewInt1)
        XCTAssertEqual(scoreChange2.scoreChange, scoreChangeNewInt2)
    }
}
