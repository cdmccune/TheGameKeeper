//
//  HomeTabCoordinatorCoreDataHelperTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 4/11/24.
//

import XCTest
import CoreData
@testable import Whats_The_Score

final class HomeTabCoordinatorCoreDataHelperTests: XCTestCase {
    
    func test_HomeTabCoordinatorCoreDataHelper_WhenGetAllGamesCalled_ShouldCallCoreDataStoreFetchWithFetchRequestForGames() {
        // given
        let coreDataStore = CoreDataStoreMock()
        let sut = HomeTabCoordinatorCoreDataHelper(coreDataStore: coreDataStore)
        
        // when
        _ = try? sut.getAllGames()
        
        // then
        XCTAssertEqual(coreDataStore.makeFetchRequestCalledCount, 1)
        XCTAssertEqual((coreDataStore.makeFetchRequestRequest as? NSFetchRequest<NSFetchRequestResult>)?.entityName, "Game")
    }
    
    func test_HomeTabCoordinatorCoreDataHelper_WhenGetAllGamesThrowsError_ShouldThrowError() {
        // given
        let coreDataStore = CoreDataStoreMock()
        let sut = HomeTabCoordinatorCoreDataHelper(coreDataStore: coreDataStore)
        
        let errorDescription = UUID().uuidString
        let error = CoreDataStoreError.dataError(description: errorDescription)
        coreDataStore.errorToReturn = error
        
        // when
        do {
            _ = try sut.getAllGames()
            XCTFail("Call should fail")
        } catch CoreDataStoreError.dataError(let description) {
            XCTAssertEqual(description, errorDescription)
        } catch {
            XCTFail("Wrong type of error")
        }
    }
    
    func test_HomeTabCoordinatorCoreDataHelper_WhenGetAllGamesReturnsGames_ShouldReturnGames() {
        // given
        let coreDataStore = CoreDataStoreMock()
        let sut = HomeTabCoordinatorCoreDataHelper(coreDataStore: coreDataStore)
        
        let gamesToReturn = [Game()]
        coreDataStore.makeFetchRequestArrayToReturn = gamesToReturn
        
        let games = try! sut.getAllGames()
        XCTAssertEqual(games[0] as? Game, gamesToReturn[0])
    }

}

class HomeTabCoordinatorCoreDataHelperMock: HomeTabCoordinatorCoreDataHelperProtocol {
    var coreDataStore: Whats_The_Score.CoreDataStoreProtocol = CoreDataStoreMock()
    
    var errorToReturn: CoreDataStoreError?
    var gamesToReturn: [GameProtocol] = []
    
    var getAllGamesCalledCount = 0
    func getAllGames() throws -> [Whats_The_Score.GameProtocol] {
        getAllGamesCalledCount += 1
        if let errorToReturn {
            throw errorToReturn
        }
        return gamesToReturn
    }
}
