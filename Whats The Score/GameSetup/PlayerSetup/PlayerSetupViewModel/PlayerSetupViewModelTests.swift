//
//  PlayerSetupViewModelTests.swift
//  What's The Score Tests
//
//  Created by Curt McCune on 1/3/24.
//

import XCTest
@testable import Whats_The_Score

final class PlayerSetupViewModelTests: XCTestCase {
    
    func getViewModel(withPlayerCount playerCount: Int = 0) -> PlayerSetupViewModel {
        var players = [PlayerSettings]()
        for _ in 0..<playerCount {
            players.append(PlayerSettings.getStub())
        }
        let viewModel = PlayerSetupViewModel()
        viewModel.players = players
        return viewModel
    }

    // MARK: - DidSet
    
    func test_PlayerSetupViewModel_WhenDelegateChanged_ShouldCallDelegateBindViewToViewModel() {
        // given
        let sut = getViewModel()
        let delegateMock = PlayerSetupViewModelViewProtocolMock()
        
        // when
        sut.delegate = delegateMock
        
        // then
        XCTAssertEqual(delegateMock.bindViewToViewModelCallCount, 1)
    }
    
    
    // MARK: - Move Player At
    
    func test_PlayerSetupViewModel_WhenMovePlayerAtCalled_ShouldMovePlayerToNewIndex() {
        // given
        let sut = getViewModel(withPlayerCount: 11)
        
        let sourceRowIndex = Int.random(in: 0...10)
        let destinationRowIndex = Int.random(in: 0...10)
        
        let player = sut.players[sourceRowIndex]
        
        // when
        sut.movePlayerAt(sourceRowIndex, to: destinationRowIndex)
        
        // then
        XCTAssertEqual(player, sut.players[destinationRowIndex])
    }
 
    func test_PlayerSetupViewModel_WhenMovePlayerAtCalledInRange_ShouldCallViewDelegateBindViewModelToView() {
        // given
        let sut = getViewModel(withPlayerCount: 2)
        
        let viewDelegateMock = PlayerSetupViewModelViewProtocolMock()
        sut.delegate = viewDelegateMock
        let bindCount = viewDelegateMock.bindViewToViewModelCallCount
        
        // when
        sut.movePlayerAt(0, to: 1)
        
        // then
        XCTAssertEqual(viewDelegateMock.bindViewToViewModelCallCount, bindCount + 1)
    }
    
    
    // MARK: - Add Player
    
    func test_PlayerSetupViewModel_WhenAddPlayerCalled_ShouldCallCoordinatorShowAddPlayerPopoverWithSelfAsDelegate() {
        // given
        let sut = getViewModel()
        let coordinator = GameSetupCoordinatorMock()
        sut.coordinator = coordinator
        
        // when
        sut.addPlayer()
        
        // then
        XCTAssertEqual(coordinator.showAddPlayerPopoverCalledCount, 1)
        XCTAssertIdentical(coordinator.showAddPlayerPopoverDelegate, sut)
    }
    
    func test_PlayerSetupViewModel_WhenAddPlayerCalled_ShouldCallCoordinatorShowAddPlayerPopoverWithPlayerWithAssignUnusedIconIfAvailable() {
        // given
        let sut = getViewModel()
        let coordinator = GameSetupCoordinatorMock()
        sut.coordinator = coordinator
        
        var players = [PlayerSettings]()
        for icon in PlayerIcon.allCases {
            players.append(PlayerSettings.getStub(icon: icon))
        }
        
        let randomPlayer = players.randomElement()!
        players.removeAll { $0.icon == randomPlayer.icon }
        
        sut.players = players
        
        // when
        sut.addPlayer()
        
        // then
        XCTAssertEqual(coordinator.showAddPlayerPopoverPlayerSettings?.icon, randomPlayer.icon)
    }
    
    
    // MARK: - EditPlayerAt
    
    func test_PlayerSetupViewModel_WhenEditPlayerAtCalled_ShouldCallCoordinatorShowAddPlayerPopoverWithPlayerAtIndexAndSelfAsDelegate() {
        // given
        let sut = getViewModel(withPlayerCount: 10)
        let coordinator = GameSetupCoordinatorMock()
        sut.coordinator = coordinator
        
        let randomPlayerIndex = Int.random(in: 0...9)
        
        // when
        sut.editPlayerAt(row: randomPlayerIndex)
        
        // then
        XCTAssertEqual(coordinator.showAddPlayerPopoverCalledCount, 1)
        XCTAssertEqual(coordinator.showAddPlayerPopoverPlayerSettings, sut.players[randomPlayerIndex])
        XCTAssertIdentical(coordinator.showAddPlayerPopoverDelegate, sut)
    }
    
    
    // MARK: - RandomizePlayers
    
    func test_PlayerSetupViewModel_WhenRandomizePlayersCalled_ShouldRandomizeArray() {
        
        // given
        let sut = getViewModel(withPlayerCount: 10)
        let preShuffledPlayers = sut.players
        
        // when
        sut.randomizePlayers()
        
        // then
        XCTAssertNotEqual(preShuffledPlayers, sut.players)
    }

    func test_PlayerSetupViewModel_WhenRandomizePlayersCalled_ShouldCallBindViewToViewModel() {
        // given
        let sut = getViewModel()
        let viewModelDelegate = PlayerSetupViewModelViewProtocolMock()
        sut.delegate = viewModelDelegate
        let callCount = viewModelDelegate.bindViewToViewModelCallCount
        
        // when
        sut.randomizePlayers()
        
        // then
        XCTAssertEqual(viewModelDelegate.bindViewToViewModelCallCount, callCount+1)
    }
    
    
    // MARK: - DeletePlayerAt
    
    func test_PlayerSetupViewModel_WhenDeletePlayerAtCalled_ShouldDeletePlayerAtIndex() {
        // given
        let sut = getViewModel(withPlayerCount: 11)
        
        var players = sut.players
        let index = Int.random(in: 0...10)
        
        // when

        sut.deletePlayerAt(index)
        
        // then
        players.remove(at: index)
        XCTAssertEqual(players as? [PlayerMock], sut.players as? [PlayerMock])
    }
    
    
    // MARK: - PlayersSetup
    
    func test_PlayerSetupViewModel_WhenPlayersSetupCalled_ShouldCallCoordinatorPlayersSetupWithPlayers() {
        // given
        let coordinatorMock = GameSetupCoordinatorMock()
        let sut = getViewModel(withPlayerCount: 5)
        sut.coordinator = coordinatorMock
        
        // when
        sut.playersSetup()
        
        // then
        XCTAssertEqual(coordinatorMock.playersSetupCalledCount, 1)
        XCTAssertEqual(coordinatorMock.playersSetupPlayers as? [PlayerMock], sut.players as? [PlayerMock])
    }
    
    
    // MARK: - FinishedEditing
    
    func test_PlayerSetupViewModel_WhenFinishedEditingCalledPlayerNotInPlayerArray_ShouldAppendPlayerSettingsToPlayersArray() {
        // given
        let sut = getViewModel()
        let playerSettings = PlayerSettings.getStub()
        
        // when
        sut.finishedEditing(playerSettings)
        
        // then
        XCTAssertEqual(sut.players.first, playerSettings)
    }
    
    func test_PlayerSetupViewModel_WhenFinishedEditingCalledPlayerInArray_ShouldSetThePlayerSettingsAtIndexToNewPlayerSettings() {
        // given
        let sut = getViewModel()
        var playerSettings = PlayerSettings.getStub()
        sut.players = [playerSettings]
        
        let newPlayerName = UUID().uuidString
        playerSettings.name = newPlayerName
        
        // when
        sut.finishedEditing(playerSettings)
        
        // then
        XCTAssertEqual(sut.players.count, 1)
        XCTAssertEqual(sut.players.first, playerSettings)
        XCTAssertEqual(sut.players.first?.name, newPlayerName)
    }
    
    func test_PlayerSetupViewModel_WhenFinishedEditingCalled_ShouldCallDelegateBindViewToViewModel() {
        // given
        let sut = getViewModel()
        let delegate = PlayerSetupViewModelViewProtocolMock()
        sut.delegate = delegate
        
        let calledCount = delegate.bindViewToViewModelCallCount
        
        // when
        sut.finishedEditing(PlayerSettings.getStub())
        
        // then
        XCTAssertEqual(delegate.bindViewToViewModelCallCount, calledCount + 1)
    }
}
