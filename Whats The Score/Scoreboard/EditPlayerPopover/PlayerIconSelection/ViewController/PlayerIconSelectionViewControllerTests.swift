//
//  PlayerIconSelectionViewControllerTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 4/18/24.
//

import XCTest
@testable import Whats_The_Score

final class PlayerIconSelectionViewControllerTests: XCTestCase {
    
    // MARK: - Setup
    
    var viewController: PlayerIconSelectionViewController!

    override func setUp() {
        self.viewController = PlayerIconSelectionViewController.instantiate()
    }
    
    override func tearDown() {
        viewController = nil
    }
    
    
    // MARK: - Init

    func test_PlayerIconSelectionViewController_WhenInitialized_ShouldSetViewModelAsCollectionViewDelegateViewModel() {
        // given
        let sut = viewController!
        let viewModel = PlayerIconSelectionViewModel()
        sut.viewModel = viewModel
        sut.loadView()
        
        // when
        let collectionViewDelegate = sut.collectionViewDelegate
        
        // then
        XCTAssertIdentical(collectionViewDelegate.viewModel, viewModel)
    }
    
    func test_PlayerIconSelectionViewController_WhenViewDidLoadCalled_ShouldSetCollectionViewDelegateAndDatasourceToCollectionViewDelegateDatasource() {
        // given
        let sut = viewController!
        sut.loadView()
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertIdentical(sut.collectionView.delegate, sut.collectionViewDelegate)
        XCTAssertIdentical(sut.collectionView.dataSource, sut.collectionViewDelegate)
    }
    
    func test_PlayerIconSelectionViewController_WhenViewDidLoadCalled_ShouldRegisterEndGamePlayerIconSelectionCollectionViewCellInCollectionView() {
        // given
        let sut = viewController!
        
        // when
        sut.loadView()
        sut.viewDidLoad()
        
        // then
        let cell = sut.collectionView.dequeueReusableCell(withReuseIdentifier: "PlayerIconSelectionCollectionViewCell", for: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(cell is PlayerIconSelectionCollectionViewCell)
    }

}
