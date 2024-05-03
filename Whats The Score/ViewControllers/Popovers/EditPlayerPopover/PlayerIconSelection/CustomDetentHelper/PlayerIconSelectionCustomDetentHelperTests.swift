//
//  PlayerIconSelectionCustomDetentHelperTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 4/19/24.
//

import XCTest
@testable import Whats_The_Score

final class PlayerIconSelectionCustomDetentHelperTests: XCTestCase {

    // MARK: - GetCustomDetentFor
    
    func test_PlayerIconSelectionCustomDetentHelper_WhenGetCustomDetentForCalledViewModel_ShouldReturnCalculatedValue() {
        // given
        let sut = PlayerIconSelectionCustomDetentHelper()
        
        let viewModel = PlayerIconSelectionViewModelMock()
        let iconCount = Int.random(in: 1...1000)
        let icons = Array(repeating: PlayerIcon.allCases.randomElement()!, count: iconCount)
        viewModel.icons = icons
        
        sut.viewModel = viewModel
        
        let screenWidth = CGFloat.random(in: 300...1000)
        
        // when
        _ = sut.getCustomDetentFor(forScreenSize: CGSize(width: screenWidth, height: 0.0))
        
        // then
        let labelAndSpacingHeight: CGFloat = 40
        let iconHeightAndWidth: CGFloat = 50
        let totalIconWidth: CGFloat = iconHeightAndWidth * CGFloat(iconCount) + CGFloat(10) * CGFloat(iconCount - 1)
        let numberOfRows: CGFloat = ceil(totalIconWidth / (screenWidth - CGFloat(20)))
        
        
        let expectedCollectionViewHeight = (numberOfRows*iconHeightAndWidth) + (CGFloat(10)*(numberOfRows - 1)) + labelAndSpacingHeight
        
        XCTAssertEqual(expectedCollectionViewHeight, sut.returnedHeight)
    }

}
