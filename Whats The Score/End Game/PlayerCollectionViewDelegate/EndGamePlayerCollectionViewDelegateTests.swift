//
//  EndGamePlayerCollectionViewDelegateTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 3/8/24.
//

import XCTest
@testable import Whats_The_Score

final class EndGamePlayerCollectionViewDelegateTests: XCTestCase {

    // MARK: - Setup Functions

    var collectionViewMock: UICollectionView?
    
    override func setUp() {
        let collectionViewLayout = UICollectionViewLayout()
        collectionViewMock = UICollectionView(frame: CGRectZero, collectionViewLayout: collectionViewLayout)
        collectionViewMock?.register(EndGamePlayerCollectionViewCellMock.self, forCellWithReuseIdentifier: "EndGamePlayerCollectionViewCell")
    }
    
    override func tearDown() {
        collectionViewMock = nil
    }
    
    func getSutAndCollectionView(withPlayerCount playerCount: Int) -> (EndGamePlayerCollectionViewDelegate, UICollectionView) {
        
        var players = [Player]()
        for _ in 0..<playerCount {
            players.append(Player(name: "", position: 0))
        }
        
        let viewModelMock = EndGameViewModelMock()
        let game = GameMock(players: [])
        game.winningPlayers = players
        viewModelMock.game = game
        
        let sut = EndGamePlayerCollectionViewDelegate(viewModel: viewModelMock)
        let collectionView = collectionViewMock!
        collectionView.delegate = sut
        collectionView.dataSource = sut
        
        return (sut, collectionView)
    }
    
    
    // MARK: - NumberOfItemsInSection
    
    func test_EndGamePlayerCollectionViewDelegate_WhenNumberOfItemsInSectionCalled_ShouldReturnViewModelGameWinningPlayers() {
        // given
        let playerCount = Int.random(in: 2...10)
        let (sut, collectionView) = getSutAndCollectionView(withPlayerCount: playerCount)
        
        // when
        let count = sut.collectionView(collectionView, numberOfItemsInSection: 0)
        
        // then
        XCTAssertEqual(playerCount, count)
    }
    
    func test_EndGamePlayerCollectionViewDelegate_WhenNumberOfItemsInSectionCalledViewModelNoWinningPlayers_ShouldReturn1() {
        // given
        let (sut, collectionView) = getSutAndCollectionView(withPlayerCount: 0)
        
        // when
        let count = sut.collectionView(collectionView, numberOfItemsInSection: 0)
        
        // then
        XCTAssertEqual(1, count)
    }
    
    
    // MARK: - CellForItemAt
    
    func test_EndGamePlayerCollectionViewDelegate_WhenCellForItemAtCalled_ShouldReturnEndGamePlayerCollectionViewCell() {
        // given
        let (sut, collectionView) = getSutAndCollectionView(withPlayerCount: 0)
        
        // when
        let cell = sut.collectionView(collectionView, cellForItemAt: IndexPath(item: 0, section: 0))
        
        // then
        XCTAssertTrue(cell is EndGamePlayerCollectionViewCell)
    }
    
    func test_EndGamePlayerCollectionViewDelegate_WhenCellForItemAtOutOfRangeOfViewModelWinningPlayers_ShouldCallCellsSetupErrorCell() {
        // given
        let (sut, collectionView) = getSutAndCollectionView(withPlayerCount: 0)
        
        // when
        let cell = sut.collectionView(collectionView, cellForItemAt: IndexPath(item: 0, section: 0)) as? EndGamePlayerCollectionViewCellMock
        
        // then
        XCTAssertEqual(cell?.setupErrorCellCalledCount, 1)
    }
    
    func test_EndGamePlayerCollectionViewDelegate_WhenCellForItemAtInRangeCalled_ShouldCallSetupViewForWithPlayer() {
        // given
        let (sut, collectionView) = getSutAndCollectionView(withPlayerCount: 2)
        let playerIndex = 1
        let player = sut.viewModel.game.winningPlayers[playerIndex]
        
        // when
        let cell = sut.collectionView(collectionView, cellForItemAt: IndexPath(item: playerIndex, section: 0)) as? EndGamePlayerCollectionViewCellMock
        
        // then
        XCTAssertEqual(cell?.setupViewForPlayer, player)
        XCTAssertEqual(cell?.setupViewForCalledCount, 1)
    }

}

class EndGamePlayerCollectionViewCellMock: EndGamePlayerCollectionViewCell {
    var setupErrorCellCalledCount = 0
    override func setupErrorCell() {
        setupErrorCellCalledCount += 1
    }
    
    var setupViewForPlayer: Player?
    var setupViewForCalledCount = 0
    override func setupViewFor(_ player: Player) {
        setupViewForCalledCount += 1
        setupViewForPlayer = player
    }
}
