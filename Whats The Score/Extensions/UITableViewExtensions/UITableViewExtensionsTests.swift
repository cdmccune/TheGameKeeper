//
//  UITableViewExtensionsTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 1/18/24.
//

import XCTest

final class UITableViewExtensionsTests: XCTestCase {

    func test_UITableView_WhenInitialized_ShouldConformToDragAndDropDelegate() {
        // given
        let sut = UITableView()
        
        // then
        sut.dragDelegate = sut
        sut.dropDelegate = sut
    }
}
