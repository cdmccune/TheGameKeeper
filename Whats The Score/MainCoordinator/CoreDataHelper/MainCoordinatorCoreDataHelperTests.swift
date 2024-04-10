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
        _ = sut.getActiveGame()
        
        // then
        XCTAssertEqual(coreDataStore.makeFetchRequestCalledCount, 1)
        XCTAssertEqual((coreDataStore.makeFetchRequestRequest as? NSFetchRequest<NSFetchRequestResult>)?.entityName, "Game")
    }
    
    func test_MainCoordinatorCoreDataHelper_WhenGetActiveGameCalled_ShouldCallCoreDataStoreMakeFetchRequestWithPredicateToSortActiveGame() {
        // given
        let coreDataStore = CoreDataStoreMock()
        let sut = MainCoordinatorCoreDataHelper(coreDataStore: coreDataStore)
        
        // when
        _ = sut.getActiveGame()
        
        // then
        let fetchRequest = coreDataStore.makeFetchRequestRequest as? NSFetchRequest<NSFetchRequestResult>
        XCTAssertEqual(fetchRequest?.predicate?.predicateFormat, "gameStatus_ == \"active\"")
    }

}
