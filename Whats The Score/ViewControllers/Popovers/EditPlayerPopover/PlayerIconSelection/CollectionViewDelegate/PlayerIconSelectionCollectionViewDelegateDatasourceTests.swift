//
//  PlayerIconSelectionCollectionViewDelegateDatasourceTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 4/18/24.
//

import XCTest
@testable import Whats_The_Score

final class PlayerIconSelectionCollectionViewDelegateDatasourceTests: XCTestCase {

    // MARK: - Setup Functions

    var collectionView: UICollectionView?
    
    override func setUp() {
        let collectionViewLayout = UICollectionViewLayout()
        collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: collectionViewLayout)
        collectionView?.register(PlayerIconSelectionCollectionViewCellMock.self, forCellWithReuseIdentifier: "PlayerIconSelectionCollectionViewCell")
    }
    
    override func tearDown() {
        collectionView = nil
    }
    
    func getSutAndCollectionView(withIconCount iconCount: Int) -> (PlayerIconSelectionCollectionViewDelegateDatasource, UICollectionView) {
        let icons = Array(repeating: PlayerIcon.alien, count: iconCount) // Mocking a fixed number of icons
        let viewModelMock = PlayerIconSelectionViewModelMock()
        viewModelMock.icons = icons
        
        let sut = PlayerIconSelectionCollectionViewDelegateDatasource()
        sut.viewModel = viewModelMock
        
        let collectionView = self.collectionView!
        collectionView.delegate = sut
        collectionView.dataSource = sut
        
        return (sut, collectionView)
    }
    
    
    // MARK: - NumberOfItemsInSection
    
    func test_PlayerIconCollectionViewDelegate_WhenNumberOfItemsInSectionCalled_ShouldReturnCorrectNumberOfIcons() {
        // given
        let iconCount = Int.random(in: 2...10)
        let (sut, collectionView) = getSutAndCollectionView(withIconCount: iconCount)
        
        // when
        let count = sut.collectionView(collectionView, numberOfItemsInSection: 0)
        
        // then
        XCTAssertEqual(count, iconCount)
    }
    
    
    // MARK: - CellForItemAt

    func test_PlayerIconCollectionViewDelegate_WhenCellForItemAtCalled_ShouldConfigureCell() {
        // given
        let iconCount = 5
        let (sut, collectionView) = getSutAndCollectionView(withIconCount: iconCount)
        collectionView.register(PlayerIconSelectionCollectionViewCellMock.self, forCellWithReuseIdentifier: "PlayerIconSelectionCollectionViewCell")
        
        // when
        let indexPath = IndexPath(item: 0, section: 0)
        let cell = sut.collectionView(collectionView, cellForItemAt: indexPath) as! PlayerIconSelectionCollectionViewCellMock
        
        // then
        XCTAssertEqual(cell.setupCellForIconCalledCount, 1)
        XCTAssertEqual(cell.setupCellForIconIcon, PlayerIcon.alien)
    }
    
    
    // MARK: - DidSelectItemAt
    
    func test_PlayerIconCollectionViewDelegate_WhenDidSelectItemAtCalled_ShouldCallViewModelsIconSelectedAt() {
        // given
        let iconCount = 3
        let (sut, collectionView) = getSutAndCollectionView(withIconCount: iconCount)
        
        let selectedIndex = Int.random(in: 0...2)
        let viewModelMock = PlayerIconSelectionViewModelMock()
        sut.viewModel = viewModelMock
        
        // when
        let indexPath = IndexPath(item: selectedIndex, section: 0)
        sut.collectionView(collectionView, didSelectItemAt: indexPath)
        
        // then
        XCTAssertEqual(viewModelMock.iconSelectedAtRow, selectedIndex)
        XCTAssertEqual(viewModelMock.iconSelectedAtCalledCount, 1)
    }

}

class PlayerIconSelectionCollectionViewCellMock: PlayerIconSelectionCollectionViewCell {
    
    var setupCellForIconCalledCount = 0
    var setupCellForIconIcon: PlayerIcon?
    override func setupCellForIcon(_ icon: PlayerIcon) {
        setupCellForIconCalledCount += 1
        setupCellForIconIcon = icon
    }
}
