//
//  PlayerTests.swift
//  What's The Score Tests
//
//  Created by Curt McCune on 1/9/24.
//

import XCTest
@testable import Whats_The_Score

final class PlayerTests: XCTestCase {

//    func test_Player_WhenHasEmptyNameAndPositionZero_ShouldReturnPlayerWithPositionPlusOneForDisplayName() {
//        // given
//        let position = Int.random(in: 0...4)
//        let sut = Player(name: "", position: position)
//        
//        // when
//        let name = sut.name
//        
//        // then
//        XCTAssertEqual(name, "Player \(position+1)")
//    }
//    
//    func test_Player_WhenHasName_ShouldReturnNameFromName() {
//        // given
//        let name = UUID().uuidString
//        let sut = Player(name: name, position: 0)
//        
//        // when
//        let displayName = sut.name
//        
//        // then
//        XCTAssertEqual(displayName, name)
//    }
//    
//    func test_Player_WhenHasEmptyName_ShouldHaveTrueForHasDefaultName() {
//        // given
//        // when
//        let sut = Player(name: "", position: 0)
//        
//        // then
//        XCTAssertTrue(sut.hasDefaultName)
//    }
//    
//    func test_Player_WhenHasNonEmptyName_ShouldHaveFalseForHasDefaultName() {
//        // given
//        // when
//        let sut = Player(name: UUID().uuidString, position: 0)
//        
//        // then
//        XCTAssertFalse(sut.hasDefaultName)
//    }
//    
//    
    // MARK: - GetScoreThrough
    
//    func test_Player_WhenGetScoreThroughCalled_ShouldReduceScoreChangesUpUntilIndexAndSumThem() {
//        // given
//        
//        let context = CoreDataStore(.inMemory).persistentContainer.viewContext
//        let sut = Player(game: Game(context: context), name: "", position: 0, context: context)
//        
//        let scoreChangeCount = Int.random(in: 5...10)
//        var scoreChangeIntArray = [Int]()
//        
//        for _ in 0..<scoreChangeCount {
//            let scoreChangeInt = Int.random(in: 100...1000)
//            scoreChangeIntArray.append(scoreChangeInt)
//            let scoreChange = ScoreChange(player: sut, context: context)
//            scoreChange.scoreChange = scoreChangeInt
//            sut.addToScoreChanges_(scoreChange)
//        }
//        
//        let randomIndex = Int.random(in: 3..<scoreChangeCount)
//        let scoreChangeAtIndex = sut.scoreChanges[randomIndex]
//        
//        // when
//        let scoreThroughIndex = sut.getScoreThrough(scoreChangeAtIndex)
//        
//        // then
//        let limitedArray = scoreChangeIntArray[0...randomIndex]
//        let expectedScoreThroughIndex = limitedArray.reduce(0) { partialResult, scoreChangeInt in
//            partialResult + scoreChangeInt
//        }
//        XCTAssertEqual(expectedScoreThroughIndex, scoreThroughIndex)
//    }
    
}

class PlayerMock: PlayerProtocol {
    
    init(name: String = "", position: Int = 0, score: Int = 0, icon: PlayerIcon = .alien, id: UUID = UUID(), scoreChanges: [ScoreChangeProtocol] = [], getScoreThroughResult: Int = 0) {
        self.name = name
        self.score = score
        self.id = id
        self.position = position
        self.icon = icon
        self.scoreChanges = scoreChanges
        self.getScoreThroughResult = getScoreThroughResult
    }
    
    var name: String
    var score: Int
    var position: Int
    var id: UUID
    var icon: PlayerIcon
    var scoreChanges: [ScoreChangeProtocol]
    
    var getScoreThroughResult: Int
    func getScoreThrough(_ scoreChange: ScoreChangeProtocol) -> Int {
        return getScoreThroughResult
    }
}

extension PlayerMock: Equatable {}
func == (lhs: PlayerMock, rhs: PlayerMock) -> Bool {
    return lhs.id == rhs.id
}
