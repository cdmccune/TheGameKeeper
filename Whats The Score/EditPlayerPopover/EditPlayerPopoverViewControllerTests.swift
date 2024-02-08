//
//  EditPlayerPopoverViewControllerTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 2/8/24.
//

import XCTest
@testable import Whats_The_Score

final class EditPlayerPopoverViewControllerTests: XCTestCase {

    // MARK: - Setup
    
    var viewController: EditPlayerPopoverViewController?
    
    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "EditPlayerPopoverViewController") as? EditPlayerPopoverViewController
        
        self.viewController = viewController
    }
    
    override func tearDown() {
        viewController = nil
    }
    
    
    // MARK: - Setup Tests
    
    func test_EditPlayerPopoverViewController_WhenViewLoaded_ShouldHaveNonNilOutlets() {
        // given
        let sut = viewController!
        
        // when
        sut.loadView()
        
        // then
        XCTAssertNotNil(sut.playerNameTextField)
        XCTAssertNotNil(sut.colorCollectionView)
        XCTAssertNotNil(sut.saveButton)
    }
    
    
    // MARK: - ViewDidLoad
    
    func test_EditPlayerPopoverViewController_WhenViewDidLoadCalledWithPlayer_ShouldSetPlayerNameTextFieldTextToPlayerName() {
        // given
        let sut = viewController!
        let playerName = UUID().uuidString
        let player = Player(name: playerName, position: 0)
        sut.player = player
        
        // when
        sut.loadView()
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(sut.playerNameTextField.text, playerName)
    }
    
    func test_EditPlayerPopoverViewController_WhenViewDidLoadCalled_ShouldSetPlayerNameTextFieldDelegateToDismissingTextField() {
        // given
        let sut = viewController!
        
        // when
        sut.loadView()
        sut.viewDidLoad()
        
        // then
        XCTAssertTrue(sut.playerNameTextField.delegate is DismissingTextFieldDelegate)
    }
    
    
    // MARK: - PlayerNameTextFieldEditingDidEnd
    
    func test_EditPlayerPopoverViewController_WhenPlayerNameTextFieldEditingDidEnd_ShouldSetPlayerNameToTextFieldText() {
        // given
        let sut = viewController!
        sut.player = Player(name: "", position: 0)
        
        let playerNameText = UUID().uuidString
        
        // when
        sut.loadView()
        sut.playerNameTextField.text = playerNameText
        sut.playerNameTextFieldEditingDidEnd(0)
        
        // then
        XCTAssertEqual(playerNameText, sut.player?.name)
    }
    
    
    // MARK: - SaveButtonTapped
    
    func test_EditPlayerPopoverViewController_WhenSaveButtonTapped_ShouldCallDelegateFinishedEditingWithNewPlayer() {
        // given
        let sut = viewController!
        let player = Player(name: UUID().uuidString, position: 0)
        sut.player = player
        
        let delegateMock = EditPlayerPopoverDelegateMock()
        sut.delegate = delegateMock
        
        // when
        sut.saveButtonTapped(0)
        
        // then
        XCTAssertEqual(delegateMock.finishedEditingCalledCount, 1)
        XCTAssertEqual(delegateMock.finishedEditingPlayer, player)
    }
    
    
    // MARK: - Classes
    
    class EditPlayerPopoverDelegateMock: EditPlayerPopoverDelegateProtocol {
        var finishedEditingCalledCount = 0
        var finishedEditingPlayer: Player?
        func finishedEditing(_ player: Whats_The_Score.Player) {
            finishedEditingCalledCount += 1
            finishedEditingPlayer = player
        }
    }
}
