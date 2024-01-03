//
//  HomeViewControllerTests.swift
//  What's The Score
//
//  Created by Curt McCune on 12/30/23.
//

import XCTest
@testable import What_s_The_Score

final class HomeViewControllerTests: XCTestCase {
    
    var viewController: HomeViewController!
    
    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "Home View Controller") as! HomeViewController
        viewController = VC
    }

    func test_HomeViewController_WhenViewLoaded_ShouldHaveNotNilForOutlets() {
        //given
        let sut = viewController!
        
        //when
        sut.loadView()
        
        //then
        XCTAssertNotNil(sut.titleLabel)
        XCTAssertNotNil(sut.quickStartButton)
        XCTAssertNotNil(sut.setupGameButton)
        
    }
    
    func test_HomeViewController_WhenSetupGameButtonTapped_ShouldPushGameSetupViewController() {
        //given
        let sut = viewController!
        
        let navigationControllerMock = NavigationControllerPushMock()
        navigationControllerMock.viewControllers = [sut]
        
        //when
        sut.setupGameButtonTapped(4)
        
        //then
        XCTAssertEqual(navigationControllerMock.pushViewControllerCount, 1)
        XCTAssertTrue(navigationControllerMock.viewController is GameSetupViewController)
    }
    
//    func test_HomeViewController_When<#action#>_Should<#assertion#>() {
//        //given
//        let sut = <#System Under Test#>
//
//        //when
//        <#when#>
//
//        //then
//        <#then#>
//    }

}
