//
//  EndGameViewControllerTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 3/1/24.
//

import XCTest
@testable import Whats_The_Score

final class EndGameViewControllerTests: XCTestCase {

    // MARK: - Setup
    
    var viewController: EndGameViewController!
    var views: [UIView]?

    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "EndGameViewController") as? EndGameViewController else {
            fatalError("EndGameViewController wasn't found")
        }
        self.viewController = viewController
    }
    
    override func tearDown() {
        viewController = nil
    }
    
    
    // MARK: - Initialization
    
    func test_EndGameViewController_WhenViewLoaded_ShouldHaveNonNilOutlets() {
        // given
        let sut = viewController!
        
        // when
        sut.loadView()
        
        // then
        XCTAssertNotNil(sut.tableView)
    }
    
    
    // MARK: - ViewDidLoad
    
    func test_EndGameViewController_WhenViewDidLoadCalled_ShouldSetTableViewDelegateDatasourceToEndGamePlayerTableViewDelegate() {
        // given
        let sut = viewController!
        sut.loadView()
        sut.viewModel = EndGameViewModelMock()
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertTrue(sut.tableView.delegate is EndGamePlayerTableViewDelegate)
        XCTAssertTrue(sut.tableView.dataSource is EndGamePlayerTableViewDelegate)
    }
    
    func test_EndGameViewController_WhenViewDidLoadCalled_ShouldSetTableViewDelegateViewModelAsViewModel() {
        // given
        let sut = viewController!
        let viewModelMock = EndGameViewModelMock()
        sut.viewModel = viewModelMock
        sut.loadView()
        
        // when
        sut.viewDidLoad()
        
        // then
        let tableViewDelegate = sut.tableView.delegate as? EndGamePlayerTableViewDelegate
        XCTAssertTrue((tableViewDelegate?.viewModel as? EndGameViewModelMock) === viewModelMock)
    }
}
