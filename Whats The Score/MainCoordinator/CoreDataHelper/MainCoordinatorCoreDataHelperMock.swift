//
//  MainCoordinatorCoreDataHelperMock.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 4/11/24.
//

import Foundation
@testable import Whats_The_Score

class MainCoordinatorCoreDataHelperMock: MainCoordinatorCoreDataHelperProtocol {
    var coreDataStore: Whats_The_Score.CoreDataStoreProtocol = CoreDataStoreMock()
    
    var getActiveGameErrorToReturn: CoreDataStoreError? = nil
    var getActiveGameGameToReturn: Game? = nil
    var getActiveGameCalledCount = 0
    func getActiveGame() throws -> Whats_The_Score.Game? {
        getActiveGameCalledCount += 1
        if let getActiveGameErrorToReturn {
            throw getActiveGameErrorToReturn
        } else {
            return getActiveGameGameToReturn
        }
    }
}
