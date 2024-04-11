//
//  MainCoordinatorCoreDataHelperTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 4/10/24.
//

import XCTest
import CoreData
@testable import Whats_The_Score

final class MainCoordinatorCoreDataHelperTests: XCTestCase {

    func test_MainCoordinatorCoreDataHelper_WhenGetActiveGameCalled_ShouldCallCoreDataStoreMakeFetchRequestForGames() {
        // given
        let coreDataStore = CoreDataStoreMock()
        let sut = MainCoordinatorCoreDataHelper(coreDataStore: coreDataStore)
        
        // when
        _ = try? sut.getActiveGame()
        
        // then
        XCTAssertEqual(coreDataStore.makeFetchRequestCalledCount, 1)
        XCTAssertEqual((coreDataStore.makeFetchRequestRequest as? NSFetchRequest<NSFetchRequestResult>)?.entityName, "Game")
    }
    
    func test_MainCoordinatorCoreDataHelper_WhenGetActiveGameCalled_ShouldCallCoreDataStoreMakeFetchRequestWithPredicateToSortActiveGame() {
        // given
        let coreDataStore = CoreDataStoreMock()
        let sut = MainCoordinatorCoreDataHelper(coreDataStore: coreDataStore)
        
        // when
        _ = try? sut.getActiveGame()
        
        // then
        let fetchRequest = coreDataStore.makeFetchRequestRequest as? NSFetchRequest<NSFetchRequestResult>
        XCTAssertEqual(fetchRequest?.predicate?.predicateFormat, "gameStatus_ == \"active\"")
    }
    
    func test_MainCoordinatorCoreDataHelper_WhenGetActiveGameCalledCoreDataStoreThrowsError_ShouldThrowTheErrorWithSameDescription() {
        // given
        let coreDataStore = CoreDataStoreMock()
        let sut = MainCoordinatorCoreDataHelper(coreDataStore: coreDataStore)
        
        let errorDescription = UUID().uuidString
        coreDataStore.errorToReturn = CoreDataStoreError.fetchError(description: errorDescription)
        
        // when
        do {
            _ = try sut.getActiveGame()
            XCTFail("Function should throw error")
        } catch CoreDataStoreError.fetchError(let description) {
            XCTAssertEqual(description, errorDescription)
        } catch {
            XCTFail("Wrong error type")
        }
    }
    
    func test_MainCoordinatorCoreDataHelper_WhenGetActiveGameCalledReturnsMultipleGames_ShouldThrowDataErrorWithCorrectErrorDescription() {
        // given
        let coreDataStore = CoreDataStoreMock()
        let sut = MainCoordinatorCoreDataHelper(coreDataStore: coreDataStore)
        
        coreDataStore.makeFetchRequestArrayToReturn = [
            Game(),
            Game()
        ]
        
        // when
        do {
            _ = try sut.getActiveGame()
            XCTFail("Function should throw error")
        } catch CoreDataStoreError.dataError(let description) {
            XCTAssertEqual(description, "Error - there are multiple active games")
        } catch {
            XCTFail("Wrong error type")
        }
    }
    
    func test_MainCoordinatorCoreDataHelper_WhenGetActiveGameReturns1Game_ShouldReturnGame() {
        // given
        let coreDataStore = CoreDataStoreMock()
        let sut = MainCoordinatorCoreDataHelper(coreDataStore: coreDataStore)
        
        let game = Game()
        coreDataStore.makeFetchRequestArrayToReturn = [game]
        
        // when
        guard let gameReturned = try? sut.getActiveGame() else { XCTFail("Should return game")
            return
        }
        
        XCTAssertEqual(game.id, gameReturned.id)
    }
    
    func test_MainCoordinatorCoreDataHelper_WhenGetActiveGameReturns0Game_ShouldReturnNil() {
        // given
        let coreDataStore = CoreDataStoreMock()
        let sut = MainCoordinatorCoreDataHelper(coreDataStore: coreDataStore)
        
        coreDataStore.makeFetchRequestArrayToReturn = []
        
        // when
        let gameReturned = try? sut.getActiveGame()
        
        XCTAssertNil(gameReturned)
    }

}
