//
//  MyGamesViewControllerTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 4/11/24.
//

import XCTest
@testable import Whats_The_Score

final class MyGamesViewControllerTests: XCTestCase {

    // MARK: - Setup
    
    var viewController: MyGamesViewController!

    override func setUp() {
        self.viewController = MyGamesViewController.instantiate()
    }
    
    override func tearDown() {
        viewController = nil
    }
    
    // MARK: - Outlets
    
    func test_MyGamesViewController_WhenViewLoaded_ShouldHaveNonNilOutlets() {
        // given
        let sut = viewController!
        
        // when
        sut.loadView()
        
        // then
        XCTAssertNotNil(sut.tableView)
    }
}
