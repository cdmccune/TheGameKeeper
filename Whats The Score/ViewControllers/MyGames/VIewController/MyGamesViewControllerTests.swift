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
    
    
    // MARK: - TableViewDelegate
    
    func test_MyGamesViewController_WhenTableViewDelegateSet_ShouldSetItWithViewModel() {
        // given
        let sut = viewController!
        let viewModel = MyGamesViewModelMock()
        sut.viewModel = viewModel
        
        // when
        sut.loadView()
        let tableViewDelegate = sut.tableViewDelegate
        
        // then
        XCTAssertIdentical(tableViewDelegate.viewModel as? MyGamesViewModelMock, viewModel)
    }
    
    
    // MARK: - ViewDidLoad
    
    func test_MyGameViewController_WhenViewDidLoadCalled_ShouldSetAttributesForStrokeAndForegroundColorOnTitleLabel() {
        // given
        let sut = viewController!
        sut.viewModel = MyGamesViewModelMock()
        sut.loadView()
        
        // when
        sut.viewDidLoad()
        
        // then
        let attributes = sut.titleLabel.attributedText?.attributes(at: 0, effectiveRange: nil)
        XCTAssertEqual(attributes?[.foregroundColor] as? UIColor, .white)
        XCTAssertEqual(attributes?[.strokeWidth] as? CGFloat, -4.0)
        XCTAssertEqual(attributes?[.strokeColor] as? UIColor, .black)
    }
    
    func test_MyGameViewController_WhenViewDidLoadCalled_ShouldSetTableViewDelegateToMyGamesTableViewDelegate() {
        // given
        let sut = viewController!
        sut.viewModel = MyGamesViewModelMock()
        
        // when
        sut.loadView()
        sut.viewDidLoad()
        
        // then
        XCTAssertTrue(sut.tableView.delegate is MyGamesTableViewDelegateDatasource)
        XCTAssertTrue(sut.tableView.dataSource is MyGamesTableViewDelegateDatasource)
    }
    
    func test_MyGameViewController_WhenViewDidLoadCalled_ShouldRegisterMyGamesTableViewCellWithTableView() {
        // given
        let sut = viewController!
        sut.viewModel = MyGamesViewModelMock()
        sut.loadView()
        
        let tableView = UITableViewRegisterMock()
        sut.tableView = tableView
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertTrue(tableView.registerCellReuseIdentifiers.contains("MyGamesTableViewCell"))
    }
    
    func test_MyGameViewController_WhenViewDidLoadCalled_ShouldTableViewCallforHeaderFooterViewReuseIdentifierForMyGamesTableViewHeader() {
        // given
        let sut = viewController!
        sut.viewModel = MyGamesViewModelMock()
        sut.loadView()
        
        let tableView = UITableViewRegisterMock()
        sut.tableView = tableView
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(tableView.registerHeaderFooterIdentifier, "MyGamesTableViewHeaderView")
    }
    
    func test_MyGameViewController_WhenViewDidLoad_ShouldSetValueChangedOfViewModelsShouldRefreshTableViewToRefreshTableViewIfTrue() {
        // given
        let sut = viewController!
        let viewModel = MyGamesViewModelMock()
        sut.viewModel = viewModel
        sut.loadView()
        
        let tableView = UITableViewReloadDataMock()
        sut.tableView = tableView
        
        // when
        sut.viewDidLoad()
        viewModel.shouldRefreshTableView.value = true
        
        // then
        XCTAssertEqual(tableView.reloadDataCalledCount, 1)
    }
}
