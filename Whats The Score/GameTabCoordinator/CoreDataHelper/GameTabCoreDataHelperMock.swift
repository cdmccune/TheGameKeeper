//
//  GameTabCoreDataHelperMock.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 4/5/24.
//

import Foundation
@testable import Whats_The_Score

class GameTabCoreDataHelperMock: GameTabCoreDataHelperProtocol {
    var coreDataStore: Whats_The_Score.CoreDataStoreProtocol = CoreDataStoreMock()
    
    var startQuickGameCalledCount = 0
    func startQuickGame() -> GameProtocol {
        startQuickGameCalledCount += 1
        return GameMock()
    }
    
    
}
