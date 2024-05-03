//
//  PlayerIconSelectionCollectionViewCellTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 4/19/24.
//

import XCTest
@testable import Whats_The_Score

final class PlayerIconSelectionCollectionViewCellTests: XCTestCase {

    // MARK: - Setup
    
    var collectionViewCell: PlayerIconSelectionCollectionViewCell?
    
    override func setUp() {
        super.setUp()
        let nibs = Bundle.main.loadNibNamed("PlayerIconSelectionCollectionViewCell", owner: nil)
        collectionViewCell = nibs?.first(where: { $0 is PlayerIconSelectionCollectionViewCell}) as? PlayerIconSelectionCollectionViewCell
    }
    
    override func tearDown() {
        collectionViewCell = nil
        super.tearDown()
    }
    
    
    // MARK: - Outlets
    
    func test_PlayerIconSelectionCollectionViewCell_WhenNibLoaded_ShouldHaveNonNilOutlets() {
        // given
        // when
        let sut = collectionViewCell!
        
        // then
        XCTAssertNotNil(sut.iconImageView)
    }
    
    func test_PlayerIconSelectionCollectionViewCell_WhenSetupForIconCalled_ShouldCorrectlySetupImageAndBorderColor() {
        // given
        let sut = collectionViewCell!
        let icon = PlayerIcon.allCases.randomElement()!
        
        // when
        sut.setupCellForIcon(icon)
        
        // then
        XCTAssertEqual(sut.iconImageView.image, icon.image, "The icon image should match the specified icon's image.")
        XCTAssertEqual(sut.iconImageView.layer.borderColor, icon.color.cgColor, "The border color should match the specified icon's color.")
    }
    
    func test_PlayerIconSelectionCollectionViewCell_WhenSetupForIconCalled_ShouldSetClipsToBoundsAndCornerRadius() {
        // given
        let sut = collectionViewCell!
        let icon = PlayerIcon.alien
        
        // when
        sut.setupCellForIcon(icon)
        
        // then
        XCTAssertTrue(sut.iconImageView.clipsToBounds, "ImageView should clip its bounds.")
        XCTAssertEqual(sut.iconImageView.layer.cornerRadius, 25, "ImageView should have a corner radius of 25.")
    }
    
    func test_PlayerIconSelectionCollectionViewCell_WhenSetupForIconCalled_ShouldSetBorderWidth() {
        // given
        let sut = collectionViewCell!
        let icon = PlayerIcon.alien
        
        // when
        sut.setupCellForIcon(icon)
        
        // then
        XCTAssertEqual(sut.iconImageView.layer.borderWidth, 2, "Border width should be set to 2.")
    }
}
