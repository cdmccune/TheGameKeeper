//
//  GameTabCoreDataHelperTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 4/5/24.
//

import XCTest
import CoreData
@testable import Whats_The_Score

final class GameTabCoreDataHelperTests: XCTestCase {
    
    // MARK: - StartQuickGame

    func test_GameTabCoreDataHelper_WhenStartQuickGameCalled_ShouldInitializeAGameInViewContext() {
        // given
        let coreDataStore = CoreDataStoreMock()
        let sut = GameTabCoreDataHelper(coreDataStore: coreDataStore)
        
        // when
        _ = sut.startQuickGame()
        
        // then
        
        do {
            let games = try coreDataStore.persistentContainer.viewContext.fetch(Game.fetchRequest()) as? [Game]
            XCTAssertEqual(games?.count, 1)
        } catch {
            XCTFail("games couldn't be loaded from view context \(error)")
        }
    }
    
    func test_GameTabCoreDataHelper_WhenStartQuickGameCalled_ShouldSetTwoPlayersInGameWithNamesPlayer1AndPlayer2AndCorrectPositions() {
        // given
        let coreDataStore = CoreDataStoreMock()
        let sut = GameTabCoreDataHelper(coreDataStore: coreDataStore)
        
        // when
        _ = sut.startQuickGame()
        
        // then
        
        do {
            let games = try coreDataStore.persistentContainer.viewContext.fetch(Game.fetchRequest())  as? [Game]
            XCTAssertEqual(games?.first?.players.count, 2)
            XCTAssertEqual(games?.first?.players[0].name, "Player 1")
            XCTAssertEqual(games?.first?.players[0].position, 0)
            XCTAssertEqual(games?.first?.players[1].name, "Player 2")
            XCTAssertEqual(games?.first?.players[1].position, 1)
        } catch {
            XCTFail("games couldn't be loaded from view context \(error)")
        }
    }
    
    func test_GameTabCoreDataHelper_WhenStartQuickGameCalled_ShouldCallSaveContextOnCoreDataStore() {
        // given
        let coreDataStore = CoreDataStoreMock()
        let sut = GameTabCoreDataHelper(coreDataStore: coreDataStore)
        
        // when
        _ = sut.startQuickGame()
        
        // then
        XCTAssertEqual(coreDataStore.saveContextCalledCount, 1)
    }

    // MARK: - InitializeGame
    
    func test_GameTabCoreDataHelper_WhenInitializeGameCalled_ShouldInitializeGameWithGameTypeAndGameEndType() {
        // given
        let coreDataStore = CoreDataStoreMock()
        let sut = GameTabCoreDataHelper(coreDataStore: coreDataStore)
        
        let gameType = GameType.allCases.randomElement()!
        let gameEndType = GameEndType.allCases.randomElement()!
        
        // when
        _ = sut.initializeGame(with: gameType, gameEndType, gameEndQuantity: 0, [])
        
        // then
        do {
            let games = try coreDataStore.persistentContainer.viewContext.fetch(Game.fetchRequest())  as? [Game]
            XCTAssertEqual(games?.first?.gameType, gameType)
            XCTAssertEqual(games?.first?.gameEndType, gameEndType)
        } catch {
            XCTFail("games couldn't be loaded from view context \(error)")
        }
    }
    
    func test_GameTabCoordiantor_WhenInitializeGameCalledGameTypeRoundGameEndTypeRound_ShouldSetGameNumberOfRoundsToGameEndQuantity() {
        // given
        let coreDataStore = CoreDataStoreMock()
        let sut = GameTabCoreDataHelper(coreDataStore: coreDataStore)
        let gameEndQuantity = Int.random(in: 2...10)
        
        // when
        _ = sut.initializeGame(with: GameType.round,
                               GameEndType.round,
                               gameEndQuantity: gameEndQuantity,
                               [])
        
        // then
        do {
            let games = try coreDataStore.persistentContainer.viewContext.fetch(Game.fetchRequest())  as? [Game]
            XCTAssertEqual(games?.first?.numberOfRounds, gameEndQuantity)
            
        } catch {
            XCTFail("games couldn't be loaded from view context \(error)")
        }
    }
    
    func test_GameTabCoordiantor_WhenInitializeGameCalledGameTypeRoundGameEndTypeScore_ShouldSetGameEndingScoreToGameEndQuantity() {
        // given
        let coreDataStore = CoreDataStoreMock()
        let sut = GameTabCoreDataHelper(coreDataStore: coreDataStore)
        let gameEndQuantity = Int.random(in: 2...10)
        
        // when
        _ = sut.initializeGame(with: GameType.round,
                               GameEndType.score,
                               gameEndQuantity: gameEndQuantity,
                               [])
        
        // then
        do {
            let games = try coreDataStore.persistentContainer.viewContext.fetch(Game.fetchRequest())  as? [Game]
            XCTAssertEqual(games?.first?.endingScore, gameEndQuantity)
            
        } catch {
            XCTFail("games couldn't be loaded from view context \(error)")
        }
    }
    
    func test_GameTabCoordiantor_WhenInitializeGameCalled_ShouldCreatePlayersFromPlayerSettings() {
        // given
        let coreDataStore = CoreDataStoreMock()
        let sut = GameTabCoreDataHelper(coreDataStore: coreDataStore)
        
        let playerCount = Int.random(in: 2...10)
        let playerSettings = Array(repeating: PlayerSettings(name: ""), count: playerCount)
        
        // when
        _ = sut.initializeGame(with: .round,
                               .score,
                               gameEndQuantity: 0,
                               playerSettings)
        
        // then
        do {
            let games = try coreDataStore.persistentContainer.viewContext.fetch(Game.fetchRequest())  as? [Game]
            XCTAssertEqual(games?.first?.players.count, playerCount)
            
        } catch {
            XCTFail("games couldn't be loaded from view context \(error)")
        }
    }
    
    func test_GameTabCoordinator_WhenInitializeGameCalled_ShouldSetPlayerPositionsCorrectly() {
        // given
        let coreDataStore = CoreDataStoreMock()
        let sut = GameTabCoreDataHelper(coreDataStore: coreDataStore)
        
        let playerCount = Int.random(in: 2...10)
        let playerSettings = Array(repeating: PlayerSettings(name: ""), count: playerCount)
        
        // when
        _ = sut.initializeGame(with: .round,
                               .score,
                               gameEndQuantity: 0,
                               playerSettings)
        
        // then
        do {
            let games = try coreDataStore.persistentContainer.viewContext.fetch(Game.fetchRequest())  as? [Game]
            games?.first?.players.enumerated().forEach({ (index, player) in
                XCTAssertEqual(player.position, index - 1)
            })
            
        } catch {
            XCTFail("games couldn't be loaded from view context \(error)")
        }
    }
    
    func test_GameTabCoordinator_WhenInitializeGameCalled_ShouldCallSaveContextOnCoreDataStore() {
        // given
        let coreDataStore = CoreDataStoreMock()
        let sut = GameTabCoreDataHelper(coreDataStore: coreDataStore)
        
        // when
        _ = sut.initializeGame(with: .basic, .none, gameEndQuantity: 0, [])
        
        // then
        XCTAssertEqual(coreDataStore.saveContextCalledCount, 1)
    }
}
