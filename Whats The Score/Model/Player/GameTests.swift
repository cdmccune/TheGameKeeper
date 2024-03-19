//
//  GameTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 1/19/24.
//

import XCTest
@testable import Whats_The_Score

final class GameTests: XCTestCase {

    // MARK: - Init
    
    func test_Game_WhenInitialized_ShouldCreatePlayersForNumberOfPlayersPropertiesWithCorrectPositions() {
        // given
        let numberOfPlayers = Int.random(in: 1...5)
        
        // when
        let sut = Game(gameType: .basic, gameEndType: .none, numberOfRounds: 0, numberOfPlayers: numberOfPlayers)
        
        // then
        XCTAssertEqual(sut.players.count, numberOfPlayers)
        for (index, players) in sut.players.enumerated() {
            XCTAssertEqual(players.position, index)
        }
    }
    
    
    // MARK: - PlayerNameChanged
    
    func test_Game_WhenPlayerNameChangedCalledOutOfPlayerRange_ShouldDoNothing() {
        // given
        let player = Player(name: UUID().uuidString, position: 0)
        var sut = Game(basicGameWithPlayers: [player])
        
        // when
        sut.playerNameChanged(withIndex: 1, toName: UUID().uuidString)
        
        // then
        XCTAssertEqual(sut.players[0].name, player.name)
    }
    
    func test_Game_WhenPlayerNameChangedCalledInRange_ShouldChangePlayerName() {
        // given
        let player = Player(name: "", position: 0)
        var sut = Game(basicGameWithPlayers: [player])
        
        // when
        let newName = UUID().uuidString
        sut.playerNameChanged(withIndex: 0, toName: newName)
        
        // then
        XCTAssertEqual(sut.players[0].name, newName)
    }
    
    func test_Game_WhenPlayerNameChanged_ShouldChangePlayerNameOnAppropriateScoreChangeHistorySegment() {
        // given
        let player = PlayerMock()
        var sut = Game(basicGameWithPlayers: [player])
        
        let scoreChange = ScoreChange(player: player, scoreChange: 0)
        let scoreChangeHistorySegment = GameHistorySegment.scoreChange(scoreChange, player)
        sut.historySegments = [scoreChangeHistorySegment]
        
        // when
        let newName = UUID().uuidString
        sut.playerNameChanged(withIndex: 0, toName: newName)
        
        // then
        guard case .scoreChange(let scoreChange, _) = sut.historySegments[0] else {
            XCTFail("history segment not there")
            return
        }

        XCTAssertEqual(scoreChange.playerName, newName)
    }
    
    func test_Game_WhenPlayerNameChanged_ShouldChangePlayerNameAllPlayersScoreChanges() {
        // given
        let player = PlayerMock()
        var sut = Game(basicGameWithPlayers: [player])
        
        let scoreChange = ScoreChange(player: player, scoreChange: 0)
        player.scoreChanges = [scoreChange]
        
        // when
        let newName = UUID().uuidString
        sut.playerNameChanged(withIndex: 0, toName: newName)
        
        // then
        let playerScoreChange = player.scoreChanges.first

        XCTAssertEqual(playerScoreChange?.playerName, newName)
    }
    
    func test_Game_WhenPlayerNameChanged_ShouldChangePlayerNameOnAppropriateScoreChangeInEndRoundHistorySegment() {
        // given
        let player = PlayerMock()
        var sut = Game(basicGameWithPlayers: [player])
        
        let scoreChange = ScoreChange(player: player, scoreChange: 0)
        let endRound = EndRound(roundNumber: 0, scoreChangeArray: [scoreChange])
        let endRoundHistorySegment = GameHistorySegment.endRound(endRound, [player])
        sut.historySegments = [endRoundHistorySegment]
        
        // when
        let newName = UUID().uuidString
        sut.playerNameChanged(withIndex: 0, toName: newName)
        
        // then
        guard case .endRound(let endRound, _) = sut.historySegments[0] else {
            XCTFail("history segment not there")
            return
        }

        XCTAssertEqual(endRound.scoreChangeArray[0].playerName, newName)
    }
    
    
    // MARK: - MovePlayerAt
    
    func test_Game_WhenMovePlayerAtSourceCalledOutOfRange_ShouldDoNothing() {
        // given
        let player1 = Player(name: UUID().uuidString, position: 0)
        let player2 = Player(name: UUID().uuidString, position: 0)
        let players = [player1, player2]
        var sut = Game(basicGameWithPlayers: players)
        
        // when
        sut.movePlayerAt(4, to: 0)
        
        // then
        XCTAssertEqual(sut.players as? [Player], players)
    }
    
    func test_Game_WhenMovePlayerAtDestinationCalledOutOfRange_ShouldDoNothing() {
        // given
        let player1 = Player(name: UUID().uuidString, position: 0)
        let player2 = Player(name: UUID().uuidString, position: 0)
        let players = [player1, player2]
        var sut = Game(basicGameWithPlayers: players)
        
        // when
        sut.movePlayerAt(0, to: 5)
        
        // then
        XCTAssertEqual(sut.players as? [Player], players)
    }
    
    func test_Game_WhenMovePlayerAtCalledInRange_ShouldChangePlayersPositionAndPositionValues() {
        // given
        let player1Name = UUID().uuidString
        let player1 = Player(name: player1Name, position: 0)
        
        let player2Name = UUID().uuidString
        let player2 = Player(name: player2Name, position: 1)
        
        let player3Name = UUID().uuidString
        let player3 = Player(name: player3Name, position: 2)
        
        let players = [player1, player2, player3]
        
        var sut = Game(basicGameWithPlayers: players)
        
        // when
        sut.movePlayerAt(2, to: 0)
        
        // then
        XCTAssertEqual(sut.players[0].name, player3Name)
        XCTAssertEqual(sut.players[0].position, 0)
        XCTAssertEqual(sut.players[1].name, player1Name)
        XCTAssertEqual(sut.players[1].position, 1)
        XCTAssertEqual(sut.players[2].name, player2Name)
        XCTAssertEqual(sut.players[2].position, 2)
    }
    
    
    // MARK: - AddPlayer
    
    func test_Game_WhenAddPlayerCalled_ShouldAddPlayerToPlayersArrayWithCorrectPosition() {
        // given
        let player = Player(name: "", position: 0)
        let players = Array(repeating: player, count: Int.random(in: 1...5))
        var sut = Game(basicGameWithPlayers: players)
        
        // when
        sut.addPlayer()
        
        // then
        XCTAssertEqual(sut.players.count, players.indices.upperBound + 1)
        XCTAssertTrue(sut.players.last?.hasDefaultName ?? false)
        XCTAssertEqual(sut.players.last?.position, players.indices.upperBound)
    }
    
    
    // MARK: - RandomizePlayers
    
    func test_Game_WhenRandomizeCalled_ShouldRandomizePlayersAndSetTheirPosition() {
        // given
        var players = [Player]()
        for i in 1...5 {
            players.append(Player(name: "\(i)", position: 0))
        }
        var sut = Game(basicGameWithPlayers: players)
        
        // when
        sut.randomizePlayers()
        
        // then
        XCTAssertNotEqual(sut.players as? [Player], players)
        
        for player in players {
            XCTAssertNotNil(sut.players.first(where: { $0.name == player.name }))
        }
        
        for (index, player) in sut.players.enumerated() {
            XCTAssertEqual(player.position, index)
        }
    }
    
    
    // MARK: - DeletePlayersAt
    
    func test_Game_WhenDeletePlayerAtCalledOutOfRange_ShouldDoNothing() {
        // given
        let player = Player(name: "", position: 0)
        var sut = Game(basicGameWithPlayers: [player])
        
        // when
        sut.deletePlayerAt(1)
        
        // then
        XCTAssertEqual([player], sut.players as? [Player])
    }
    
    func test_Game_WhenDeletePlayerAtCalledInRange_ShouldRemovePlayerFromIndexAndSetPositions() {
        // given

        let player1 = Player(name: UUID().uuidString, position: 0)
        let player2 = Player(name: UUID().uuidString, position: 0)
        let player3 = Player(name: UUID().uuidString, position: 0)
        var players: [PlayerProtocol] = [player1, player2, player3]
        
        var sut = Game(basicGameWithPlayers: players)
        let playerToRemoveIndex = Int.random(in: 0...2)
        
        // when
        sut.deletePlayerAt(playerToRemoveIndex)
        players.remove(at: playerToRemoveIndex)
        players.setPositions()
        
        // then)
        XCTAssertEqual(sut.players as? [Player], players as? [Player])
        for (index, player) in sut.players.enumerated() {
            XCTAssertEqual(player.position, index)
        }
    }
    
    func test_Game_WhenDeletePlayerAtCalled_ShouldRemoveScoreChangesForThatPlayerFromGameHistory() {
        // given
        let player = PlayerMock()
        var sut = Game(basicGameWithPlayers: [player])
        
        let playerScoreChangeHistorySegments = Array(repeating: GameHistorySegment.scoreChange(ScoreChange(player: player, scoreChange: 1), player), count: Int.random(in: 3...10))
        let otherScoreChangeHistorySegment = GameHistorySegment.scoreChange(ScoreChange.getBlankScoreChange(), PlayerMock())
        sut.historySegments = playerScoreChangeHistorySegments
        sut.historySegments.append(otherScoreChangeHistorySegment)
        sut.historySegments.shuffle()
        
        // when
        sut.deletePlayerAt(0)
        
        // then
        XCTAssertEqual(sut.historySegments, [otherScoreChangeHistorySegment])
    }
    
    func test_Game_WhenDeletePlayerAtCalled_ShouldDeleteEndRoundHistorySegmentScoreChangesForThatPlayer() {
        // given
        let player = PlayerMock()
        var sut = Game(basicGameWithPlayers: [player])
        
        let endRound = EndRound(withPlayers: [player], roundNumber: 0)
        let endRoundHistorySegment = GameHistorySegment.endRound(endRound, [player])
        sut.historySegments = [endRoundHistorySegment]
        
        // when
        sut.deletePlayerAt(0)
        
        // then
        guard case .endRound(let endRound, _) = sut.historySegments.first else {
            return
        }

        XCTAssertTrue(endRound.scoreChangeArray.isEmpty)
    }
    
    func test_Game_WhenDeletePlayerAtCalled_ShouldRemovePlayerFromEndRoundHistorySegmentPlayersArray() {
        // given
        let player = PlayerMock()
        var sut = Game(basicGameWithPlayers: [player])
        
        let endRound = EndRound(withPlayers: [player], roundNumber: 0)
        let endRoundHistorySegment = GameHistorySegment.endRound(endRound, [player])
        sut.historySegments = [endRoundHistorySegment]
        
        // when
        sut.deletePlayerAt(0)
        
        // then
        guard case .endRound(_, let playerArray) = sut.historySegments.first else {
            return
        }

        XCTAssertTrue(playerArray.isEmpty)
    }
    
    
    // MARK: - Winning Players
    
    func test_Game_WhenWinningPlayersIsReadOnePlayerWithTopScore_ShouldReturnArrayWithThatPlayer() {
        // given
        var sut = Game(gameType: .basic, gameEndType: .none, numberOfPlayers: 0)
        
        let player1 = PlayerMock(name: "", position: 0, score: 1)
        let player2 = PlayerMock(name: "", position: 0, score: 2)
        let player3 = PlayerMock(name: "", position: 0, score: 3)
        
        sut.players = [player1, player2, player3]
        
        // when
        let winningPlayers = sut.winningPlayers as? [PlayerMock]
        
        // then
        XCTAssertEqual(winningPlayers, [player3])
    }
    
    func test_Game_WhenWinningPlayersIsReadMultiplePlayersWithTopScore_ShouldReturnArrayWithThosePlayers() {
        // given
        var sut = Game(gameType: .basic, gameEndType: .none, numberOfPlayers: 0)
        
        let player1 = PlayerMock(name: "", position: 0, score: 1)
        let player2 = PlayerMock(name: "", position: 0, score: 2)
        let player3 = PlayerMock(name: "", position: 0, score: 2)
        
        sut.players = [player1, player2, player3]
        
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
        let sut = Game(basicGameWithPlayers: [])
        let secondGame = GameMock()
        secondGame.id = UUID()
        
        // when
        let bool = sut.isEqualTo(game: secondGame)
        
        // then
        XCTAssertFalse(bool)
    }
    
    func test_Game_WhenIsEqualToCalledSameIDs_ShouldReturnTrue() {
        // given
        let sut = Game(basicGameWithPlayers: [])
        let secondGame = GameMock()
        secondGame.id = sut.id
        
        // when
        let bool = sut.isEqualTo(game: secondGame)
        
        // then
        XCTAssertTrue(bool)
    }
    
    
    // MARK: - EditScore
    
    func test_Game_WhenEditPlayerScoreCalled_ShouldAppendScoreChangeToPlayer() {
        // given
        let player = Player(name: "", position: 0)
        var sut = Game(basicGameWithPlayers: [player])
        
        let pointsChange = Int.random(in: (-1000...1000))
        
        let scoreChangeObject = ScoreChange(player: player, scoreChange: pointsChange)
        
        // when
        sut.editScore(scoreChange: scoreChangeObject)
        
        // then
        XCTAssertEqual(sut.players.first?.scoreChanges.first, scoreChangeObject)
    }
    
    func test_Game_WhenEditPlayerScoreCalled_ShouldAppendScoreChangeGameHistorySegmentWithPlayerAndScoreChangeAndPlayer() {
        // given
        let totalScore = Int.random(in: 1...1000)
        let player = PlayerMock(score: totalScore)
        var sut = Game(basicGameWithPlayers: [player])
        
        let pointChange = Int.random(in: (-1000...1000))
        
        let scoreChangeObject = ScoreChange(player: player, scoreChange: pointChange)
        
        // when
        sut.editScore(scoreChange: scoreChangeObject)
        
        // then
        guard case .scoreChange(let scoreChange, let playerFromSegment) = sut.historySegments.first else {
            XCTFail("Didn't add a history segment")
            return
        }
        
        XCTAssertEqual(scoreChange.scoreChange, pointChange)
        XCTAssertEqual(scoreChange.playerID, player.id)
        XCTAssertEqual(playerFromSegment.id, player.id)
    }
    
    
    // MARK: - EndRound
    
    func test_Game_WhenEndRoundCalled_ShouldIncrementTheCurrentRound() {
        // given
        var sut = Game(basicGameWithPlayers: [])
        let currentRound = Int.random(in: 1...10)
        sut.currentRound = currentRound
        
        // when
        sut.endRound(EndRound.getBlankEndRound())
        
        // then
        XCTAssertEqual(sut.currentRound, currentRound + 1)
    }
    
    func test_Game_WhenEndRoundCalled_ShouldAppendScoreChangeObjectsToPlayers() {
        // given
        let player1 = Player.getBasicPlayer()
        let player2 = Player.getBasicPlayer()
        let player3 = Player.getBasicPlayer()
        let players = [player1, player2, player3]
        
        var sut = Game(basicGameWithPlayers: players)
        
        let scoreChange1 = Int.random(in: 1...10)
        let scoreChange2 = Int.random(in: 1...10)
        let scoreChange3 = Int.random(in: 1...10)
        
        let scoreChangeArray = [
            ScoreChange(player: player1, scoreChange: scoreChange1),
            ScoreChange(player: player2, scoreChange: scoreChange2),
            ScoreChange(player: player3, scoreChange: scoreChange3)
        ]
        
        let endRound = EndRound(roundNumber: 0, scoreChangeArray: scoreChangeArray)
        
        // when
        sut.endRound(endRound)
        
        // then
        XCTAssertEqual(sut.players[0].scoreChanges.first, scoreChangeArray[0])
        XCTAssertEqual(sut.players[1].scoreChanges.first, scoreChangeArray[1])
        XCTAssertEqual(sut.players[2].scoreChanges.first, scoreChangeArray[2])
 
    }
    
    func test_Game_WhenEndRoundCalled_ShouldAppendEndRoundGameHistorySegmentWithCurrentRoundBeforeIncrementingPlayerAndPlayers() {
        // given
        
        
        let player1 = PlayerMock()
        let player2 = PlayerMock()
        let player3 = PlayerMock()
        let players = [player1, player2, player3]
        
        var sut = Game(basicGameWithPlayers: players)
        
        let currentRound = Int.random(in: 1...10)
        sut.currentRound = currentRound
        
        let scoreChange1 = Int.random(in: 1...10)
        let scoreChange2 = Int.random(in: 1...10)
        let scoreChange3 = Int.random(in: 1...10)
        let scores = [scoreChange1, scoreChange2, scoreChange3]
        
        let scoreChangeArray = [
            ScoreChange(player: player1, scoreChange: scoreChange1),
            ScoreChange(player: player2, scoreChange: scoreChange2),
            ScoreChange(player: player3, scoreChange: scoreChange3)
        ]
        
        let endRound = EndRound(roundNumber: currentRound, scoreChangeArray: scoreChangeArray)
        
        // when
        sut.endRound(endRound)
        
        // then
        guard case .endRound(let endRound, let playersFromSegment) = sut.historySegments.first else {
            XCTFail("Didn't add a history segment")
            return
        }
        
        XCTAssertEqual(currentRound, endRound.roundNumber)
        XCTAssertEqual(endRound.scoreChangeArray.count, 3)
        endRound.scoreChangeArray.enumerated().forEach { (index, scoreChange) in
            XCTAssertEqual(players[index].id, scoreChange.playerID)
            XCTAssertEqual(scores[index], scoreChange.scoreChange)
        }
        
        XCTAssertEqual(playersFromSegment[0].id, player1.id)
        XCTAssertEqual(playersFromSegment[1].id, player2.id)
        XCTAssertEqual(playersFromSegment[2].id, player3.id)
        
    }
    
    
    // MARK: - IsEndOfGame
    
    func test_Game_WhenIsEndOfGameCalledNoneEndGameType_ShouldReturnFalse() {
        // given
        let sut = Game(gameType: .basic, gameEndType: .none, numberOfPlayers: 0)
        
        // when
        let isEndOfGame = sut.isEndOfGame()
        
        // then
        XCTAssertFalse(isEndOfGame)
    }
    
    func test_Game_WhenIsEndOfGameCalledRoundEndGameTypeCurrentRoundLessThanNumberOfRounds_ShouldReturnFalse() {
        // given
        var sut = Game(gameType: .round, gameEndType: .round, numberOfPlayers: 0)
        sut.currentRound = 0
        sut.numberOfRounds = 4
        
        // when
        let isEndOfGame = sut.isEndOfGame()
        
        // then
        XCTAssertFalse(isEndOfGame)
    }
    
    func test_Game_WhenIsEndOfGameCalledRoundEndGameTypeCurrentRoundEqualToNumberOfRounds_ShouldReturnFalse() {
        // given
        var sut = Game(gameType: .round, gameEndType: .round, numberOfPlayers: 0)
        sut.currentRound = 4
        sut.numberOfRounds = 4
        
        // when
        let isEndOfGame = sut.isEndOfGame()
        
        // then
        XCTAssertFalse(isEndOfGame)
    }
    
    func test_Game_WhenIsEndOfGameCalledRoundEndGameTypeCurrentRoundMoreThanNumberOfRounds_ShouldReturnTrue() {
        // given
        var sut = Game(gameType: .round, gameEndType: .round, numberOfPlayers: 0)
        sut.currentRound = 5
        sut.numberOfRounds = 4
        
        // when
        let isEndOfGame = sut.isEndOfGame()
        
        // then
        XCTAssertTrue(isEndOfGame)
    }
    
    func test_Game_WhenIsEndOfGameCalledScoreEndGameTypePlayersDontHaveEqualOrMoreThanEndingScore_ShouldReturnFalse() {
        // given
        var sut = Game(gameType: .round, gameEndType: .score, numberOfPlayers: 0)
//        sut.players = [Player(name: "", position: 0, score: 10)]
        sut.players = [Player(name: "", position: 0)]
        sut.endingScore = 100
        
        // when
        let isEndOfGame = sut.isEndOfGame()
        
        // then
        XCTAssertFalse(isEndOfGame)
    }
    
    func test_Game_WhenIsEndOfGameCalledScoreEndGameTypePlayersDontHaveEqualOrMoreThanWinningScore_ShouldReturnTrue() {
        // given
        var sut = Game(gameType: .round, gameEndType: .score, numberOfPlayers: 0)
        sut.players = [PlayerMock(score: 100)]
        sut.endingScore = 100
        
        // when
        let isEndOfGame = sut.isEndOfGame()
        
        // then
        XCTAssertTrue(isEndOfGame)
    }
    
    
    // MARK: - DeleteHistorySegmentAt
    
    func test_Game_WhenDeleteHistorySegmentAtCalled_ShouldDeleteHistorySegmentAtIndex() {
        // given
        var sut = Game(basicGameWithPlayers: [])
        
        let historySegmentCount = Int.random(in: 5...10)
        
        var historySegments: [GameHistorySegment] = []
        
        for _ in 0..<historySegmentCount {
            historySegments.append(GameHistorySegment.scoreChange(ScoreChange.getBlankScoreChange(), PlayerMock()))
        }
        
        sut.historySegments = historySegments
        
        let indexToDelete = Int.random(in: 0..<historySegmentCount)
        
        // when
        sut.deleteHistorySegmentAt(index: indexToDelete)
        
        // then
        historySegments.remove(at: indexToDelete)
        XCTAssertEqual(sut.historySegments, historySegments)
    }
    
    func test_Game_WhenDeleteHistorySegmentAtCalledScoreChange_ShouldDeleteScoreChangeFromAppropriatePlayer() {
        // given
        let player = PlayerMock()
        var sut = Game(basicGameWithPlayers: [player])
        
        let scoreChange = ScoreChange(player: player, scoreChange: 0)
        player.scoreChanges = [scoreChange]
        
        let scoreChangeHistorySegment = GameHistorySegment.scoreChange(scoreChange, player)
        
        sut.historySegments = [scoreChangeHistorySegment]
        
        // when
        sut.deleteHistorySegmentAt(index: 0)
        
        // then
        XCTAssertTrue(player.scoreChanges.isEmpty)
    }
    
    func test_Game_WhenDeleteHistorySegmentAtCalledEndRound_ShouldDeleteScoreChangesFromAllAppropriatePlayers() {
        // given
        let players = [
            PlayerMock(),
            PlayerMock(),
            PlayerMock()
        ]
        
        var sut = Game(basicGameWithPlayers: players)
        
        let scoreChanges = [
            ScoreChange(player: players[0], scoreChange: 0),
            ScoreChange(player: players[1], scoreChange: 0)
        ]
        
        players[0].scoreChanges = [scoreChanges[0]]
        players[1].scoreChanges = [scoreChanges[1]]
        players[2].scoreChanges = [ScoreChange.getBlankScoreChange()]
        
        let endRound = EndRound(roundNumber: 0, scoreChangeArray: scoreChanges)
        let endRoundHistorySegment = GameHistorySegment.endRound(endRound, [players[0], players[1]])
        sut.historySegments = [endRoundHistorySegment]
        
        // when
        sut.deleteHistorySegmentAt(index: 0)
        
        // then
        XCTAssertTrue(players[0].scoreChanges.isEmpty)
        XCTAssertTrue(players[1].scoreChanges.isEmpty)
        XCTAssertEqual(players[2].scoreChanges.count, 1)
    }
    
    func test_Game_WhenDeleteHistorySegmentCalledEndRound_ShouldAdjustOtherEndRoundRoundNumbers() {
        // given
        var sut = Game(basicGameWithPlayers: [])
        
        let endRoundGameHistorySegmentArray = [
            GameHistorySegment.endRound(EndRound.init(roundNumber: 1, scoreChangeArray: []), []),
            GameHistorySegment.endRound(EndRound.init(roundNumber: 2, scoreChangeArray: []), []),
            GameHistorySegment.endRound(EndRound.init(roundNumber: 3, scoreChangeArray: []), [])
        ]
        
        sut.historySegments = endRoundGameHistorySegmentArray
        
        // when
        sut.deleteHistorySegmentAt(index: 0)
        
        // then
        guard case .endRound(let endRound1, _) = sut.historySegments[0],
              case .endRound(let endRound2, _) = sut.historySegments[1]
        else {
            XCTFail("Should be endRound")
            return
        }
        
        XCTAssertEqual(endRound1.roundNumber, 1)
        XCTAssertEqual(endRound2.roundNumber, 2)
    }
    
    func test_Game_WhenDeleteHistorySegmentCalledEndRound_ShouldGameCurrentRoundToOneAboveNumberOfCompletedRounds() {
        // given
        var sut = Game(basicGameWithPlayers: [])
        
        let endRoundGameHistorySegmentArray = [
            GameHistorySegment.endRound(EndRound.init(roundNumber: 1, scoreChangeArray: []), []),
            GameHistorySegment.endRound(EndRound.init(roundNumber: 2, scoreChangeArray: []), []),
            GameHistorySegment.endRound(EndRound.init(roundNumber: 3, scoreChangeArray: []), [])
        ]
        
        sut.historySegments = endRoundGameHistorySegmentArray
        
        // when
        sut.deleteHistorySegmentAt(index: 0)
        
        // then
        XCTAssertEqual(sut.currentRound, 3)
    }
    
    
    // MARK: - ResetGame
    
    func test_Game_WhenResetGameCalled_ShouldSetPlayersScoreChangesToEmptyArray() {
        // given
        let scoreChange = ScoreChange.getBlankScoreChange()
        let player1 = PlayerMock(scoreChanges: [scoreChange])
        let player2 = PlayerMock(scoreChanges: [scoreChange])
        
        var sut = Game(basicGameWithPlayers: [player1, player2])
        
        // when
        sut.resetGame()
        
        // then
        XCTAssertEqual(sut.players[0].scoreChanges.count, 0)
        XCTAssertEqual(sut.players[1].scoreChanges.count, 0)
    }
    
    func test_Game_WhenResetGameCalled_ShouldSetCurrentRoundTo1() {
        // given
        var sut = Game(basicGameWithPlayers: [])
        sut.currentRound = 5
        
        // when
        sut.resetGame()
        
        // then
        XCTAssertEqual(sut.currentRound, 1)
    }
    
    func test_Game_WhenResetGameCalled_ShouldWipeGameHistory() {
        // given
        var sut = Game(basicGameWithPlayers: [])
        sut.historySegments.append(.scoreChange(ScoreChange(player: Player.getBasicPlayer(), scoreChange: 0), PlayerMock()))
        
        // when
        sut.resetGame()
        
        // then
        XCTAssertTrue(sut.historySegments.isEmpty)
    }
    
    
    // MARK: - EditScoreChange
    
    func test_Game_WhenEditScoreChangeCalled_ShouldEditPlayerScoreChangeToNewValue() {
        // given
        let player1 = Player.getBasicPlayer()
        let scoreChangeOriginalChange = Int.random(in: 0...1000)
        
        var scoreChangeObject = ScoreChange(player: player1, scoreChange: scoreChangeOriginalChange)
        
        player1.scoreChanges = [scoreChangeObject]
        
        var sut = Game(basicGameWithPlayers: [player1])
        
        let gameHistorySegmentScoreChange = GameHistorySegment.scoreChange(scoreChangeObject, player1)
        sut.historySegments = [gameHistorySegmentScoreChange]
        
        let scoreChangeAfterChange = Int.random(in: 0...1000)
        scoreChangeObject.scoreChange = scoreChangeAfterChange
        
        // when
        sut.editScoreChange(scoreChangeObject)
        
        // then
        XCTAssertEqual(sut.players.first?.scoreChanges.first?.scoreChange, scoreChangeAfterChange)
    }
    
    func test_Game_WhenEditScoreChangeCalled_ShouldEditHistorySegmentScoreChange() {
        // given
        let player1 = Player.getBasicPlayer()
        let player2 = Player.getBasicPlayer()
        let players = [player1, player2]
        
        var sut = Game(basicGameWithPlayers: players)
        sut.players = [player1, player2]
        
        let indexOfPlayer = Int.random(in: 0...1)
        var scoreChangeObject = ScoreChange(player: players[indexOfPlayer], scoreChange: 0)
        players[indexOfPlayer].scoreChanges = [scoreChangeObject]
        let gameHistorySegmentScoreChange = GameHistorySegment.scoreChange(scoreChangeObject, players[indexOfPlayer])
        sut.historySegments = [gameHistorySegmentScoreChange]
        
        let scoreChangeAfterChange = Int.random(in: 0...1000)
        scoreChangeObject.scoreChange = scoreChangeAfterChange
        
        // when
        sut.editScoreChange(scoreChangeObject)
        
        // then
        guard case GameHistorySegment.scoreChange(let newScoreChange, _) = sut.historySegments.first! else {
            XCTFail("The history segment should be a score change")
            return
        }
        
        XCTAssertEqual(newScoreChange.scoreChange, scoreChangeAfterChange)
    }
    
    func test_Game_WhenEditScoreChangeCalled_ShouldSetScoreChangeHistorySegmentPlayerToPlayer() {
        // given
        let player = PlayerMock()
        
        var sut = Game(basicGameWithPlayers: [player])
        let scoreChange = ScoreChange(player: player, scoreChange: 0)
        player.scoreChanges = [scoreChange]
        sut.historySegments = [GameHistorySegment.scoreChange(scoreChange, player)]
        
        // when
        sut.editScoreChange(scoreChange)
        
        // then
        guard case GameHistorySegment.scoreChange(_, let playerFromSegment) = sut.historySegments.first! else {
            XCTFail("The history segment should be a score change")
            return
        }
        
        XCTAssertEqual(player.id, playerFromSegment.id)
    }
    
    
    // MARK: - EditEndRound
    
    func test_Game_WhenEditEndRoundCalled_ShouldEditPlayersScoreChanges() {
        // given
        let player1 = Player.getBasicPlayer()
        let player2 = Player.getBasicPlayer()
        let players = [player1, player2]
        
        var sut = Game(basicGameWithPlayers: players)
        
        var scoreChangeObjects = [
            ScoreChange(player: player1, scoreChange: 0),
            ScoreChange(player: player2, scoreChange: 0)
        ]
        
        player1.scoreChanges = [scoreChangeObjects[0]]
        player2.scoreChanges = [scoreChangeObjects[1]]
        
        var endRound = EndRound(roundNumber: 0, scoreChangeArray: scoreChangeObjects)
        let gameHistorySegment = GameHistorySegment.endRound(endRound, [])
        sut.historySegments = [gameHistorySegment]
        
        let scoreChangePointAfters = [
            Int.random(in: 1...1000),
            Int.random(in: 1...1000)
        ]
        
        scoreChangeObjects[0].scoreChange = scoreChangePointAfters[0]
        scoreChangeObjects[1].scoreChange = scoreChangePointAfters[1]
        
        endRound.scoreChangeArray = scoreChangeObjects
        
        // when
        sut.editEndRound(endRound)
        
        // then
        XCTAssertEqual(sut.players[0].scoreChanges.first?.scoreChange, scoreChangePointAfters[0])
        XCTAssertEqual(sut.players[1].score, scoreChangePointAfters[1])
    }
    
    func test_Game_WhenEditEndRoundCalled_ShouldSetEndRoundGameHistoryObjectScoreChanges() {
        // given
        let player1 = Player.getBasicPlayer()
        var sut = Game(basicGameWithPlayers: [player1])
        
        var endRound = EndRound(roundNumber: 0, scoreChangeArray: [])
        let endRoundHistoryObject = GameHistorySegment.endRound(endRound, [])
        sut.historySegments = [endRoundHistoryObject]
        
        let scoreChangeInt = Int.random(in: 1...1000)
        var scoreChangeObject = ScoreChange(player: player1, scoreChange: 0)
        player1.scoreChanges = [scoreChangeObject]
        
        scoreChangeObject.scoreChange = scoreChangeInt
        
        endRound.scoreChangeArray = [scoreChangeObject]
        
        // when
        sut.editEndRound(endRound)
        
        // then
        guard case .endRound(let newEndRound, _) = sut.historySegments[0] else {
            XCTFail("History Segment not present")
            return
        }
        
        XCTAssertEqual(newEndRound.scoreChangeArray, [scoreChangeObject])
    }
    
    func test_Game_WhenEditEndRoundCalled_ShouldSetEndRoundHistorySegmentPlayersToPlayersInScoreChange() {
        // given
        let player1 = PlayerMock()
        let player2 = PlayerMock()
        
        var sut = Game(basicGameWithPlayers: [player1, player2])
        
        let scoreChange1 = ScoreChange(player: player1, scoreChange: 0)
        player1.scoreChanges = [scoreChange1]
        
        let scoreChange2 = ScoreChange(player: player2, scoreChange: 0)
        player2.scoreChanges = [scoreChange2]
        
        let endRound = EndRound(roundNumber: 0, scoreChangeArray: [scoreChange1, scoreChange2])
        let endRoundHistorySegment = GameHistorySegment.endRound(endRound, [])
        
        sut.historySegments = [
            endRoundHistorySegment
        ]
        
        // when
        sut.editEndRound(endRound)
        
        // then
        guard case .endRound(_, let playersFromSegment) = sut.historySegments[0] else {
            XCTFail("History Segment not present")
            return
        }
        XCTAssertEqual(playersFromSegment[0].id, player1.id)
        XCTAssertEqual(playersFromSegment[1].id, player2.id)
    }
    
    
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
    convenience init(players: [PlayerProtocol]) {
        self.init()
        self.players = players
    }
    
    var id: UUID = UUID()
    var gameType: GameType = .basic
    var gameEndType: GameEndType = .none
    var numberOfRounds: Int = 2
    var endingScore: Int = 10
    var numberOfPlayers: Int = 0
    var currentRound: Int = 0
    var players: [PlayerProtocol] = []
    var winningPlayers: [PlayerProtocol] = []
    var historySegments: [GameHistorySegment] = []
    
    var playerNameChangedCalledCount = 0
    var playerNameChangedIndex: Int?
    var playerNameChangedName: String?
    func playerNameChanged(withIndex index: Int, toName name: String) {
        self.playerNameChangedCalledCount += 1
        self.playerNameChangedIndex = index
        self.playerNameChangedName = name
    }
    
    var movePlayerAtCalledCount = 0
    var movePlayerAtSourceRowIndex: Int?
    var movePlayerAtDestinationRowIndex: Int?
    func movePlayerAt(_ sourceRowIndex: Int, to destinationRowIndex: Int) {
        movePlayerAtCalledCount += 1
        movePlayerAtSourceRowIndex = sourceRowIndex
        movePlayerAtDestinationRowIndex = destinationRowIndex
    }
    
    var addPlayerCalledCount = 0
    func addPlayer() {
        addPlayerCalledCount += 1
    }
    
    var randomizePlayersCalledCount = 0
    func randomizePlayers() {
        randomizePlayersCalledCount += 1
    }
    
    var deletePlayerAtCalledCount = 0
    func deletePlayerAt(_ index: Int) {
        deletePlayerAtCalledCount += 1
    }
    
    var editScoreScoreChange: ScoreChange?
    var editScoreForPlayerID: UUID?
    var editScoreForPlayerName: String?
    var editScoreForChange: Int?
    var editScoreForCalledCount = 0
    func editScore(scoreChange: ScoreChange) {
        editScoreForPlayerID = scoreChange.playerID
        editScoreForPlayerName = scoreChange.playerName
        editScoreForChange = scoreChange.scoreChange
        editScoreScoreChange = scoreChange
        editScoreForCalledCount += 1
    }
    
    var endRoundEndRound: EndRound?
    var endRoundCalledCount = 0
    func endRound(_ endRound: EndRound) {
        endRoundEndRound = endRound
        endRoundCalledCount += 1
    }
    
    var resetGameCalledCount = 0
    func resetGame() {
        resetGameCalledCount += 1
    }
    
    var editScoreChangeScoreChange: ScoreChange?
    var editScoreChangeCalledCount = 0
    func editScoreChange(_ scoreChange: ScoreChange) {
        editScoreChangeScoreChange = scoreChange
        editScoreChangeCalledCount += 1
    }
    
    var editEndRoundCalledCount = 0
    var editEndRoundEndRound: EndRound?
    func editEndRound(_ newEndRound: EndRound) {
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
