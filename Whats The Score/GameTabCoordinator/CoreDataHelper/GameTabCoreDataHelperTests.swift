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

    func test_GameTabCoreDataHelper_WhenStartQuickGameCalled_ShouldInitializeAGameInViewContext() {
        // given
        let coreDataStore = CoreDataStoreMock()
        let sut = GameTabCoreDataHelper(coreDataStore: coreDataStore)
        
        // when
        _ = sut.startQuickGame()
        
        // then
        
        do {
            let games = try coreDataStore.persistentContainer.viewContext.fetch(Game.fetchRequest())
            XCTAssertEqual(games.count, 1)
        } catch {
            print("hit error", error)
            XCTFail()
        }
        
        
    }

}
