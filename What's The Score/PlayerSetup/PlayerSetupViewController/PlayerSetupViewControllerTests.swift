//
//  PlayerSetupViewControllerTests.swift
//  What's The Score Tests
//
//  Created by Curt McCune on 1/2/24.
//

import XCTest
@testable import What_s_The_Score

final class PlayerSetupViewControllerTests: XCTestCase {
    
    var viewController: PlayerSetupViewController!
    
    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "PlayerSetupViewController") as! PlayerSetupViewController
        viewController = VC
    }
    
    override func tearDown() {
        viewController = nil
    }
    
    
    //MARK: - Tests
    
    
    func test_PlayerSetupViewController_WhenLoaded_ShouldHaveNonNilOutlets() {
        //given
        let sut = viewController!
        
        //when
        viewController.loadView()
        
        //then
        XCTAssertNotNil(sut.titleLabel)
        XCTAssertNotNil(sut.randomizeButton)
        XCTAssertNotNil(sut.playerTableView)
        XCTAssertNotNil(sut.positionTableView)
    }

//    func test_PlayerSetupViewController_WhenGameSettings_Should<#assertion#>() {
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
