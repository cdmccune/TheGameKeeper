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
    
    
    // MARK: - SaveButtonTapped
    
    func test_EditPlayerPopoverViewController_WhenSaveButtonTapped_ShouldCallDelegateFinishedEditingWithNewPlayerAndTextAsName() {
        // given
        let sut = viewController!
        let player = Player(name: UUID().uuidString, position: 0)
        sut.player = player
        
        let delegateMock = EditPlayerPopoverDelegateMock()
        sut.delegate = delegateMock
        
        let textfield = UITextField()
        let name = UUID().uuidString
        textfield.text = name
        sut.playerNameTextField = textfield
        
        // when
        sut.saveButtonTapped(0)
        
        // then
        XCTAssertEqual(delegateMock.finishedEditingCalledCount, 1)
        XCTAssertEqual(delegateMock.finishedEditingPlayer?.id, player.id)
        XCTAssertEqual(delegateMock.finishedEditingName, name)
    }
    
    func test_EditPlayerPopoverViewController_WhenSaveButtonTapped_ShouldDismissView() {
        
        class EditPlayerPopoverViewControllerDismissMock: EditPlayerPopoverViewController {
            var dismissedCalledCount = 0
            override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
                dismissedCalledCount += 1
            }
        }
        
        // given
        let sut = EditPlayerPopoverViewControllerDismissMock()
        sut.player = Player(name: "", position: 0)
        
        // when
        sut.saveButtonTapped(0)
        
        // then
        XCTAssertEqual(sut.dismissedCalledCount, 1)
    }
    
    
    // MARK: - ExitButtonTapped
    
    func test_EditPlayerPopoverViewController_WhenExitButtonTappedCalled_ShouldDismissView() {
        
        class EditPlayerPopoverViewControllerDismissMock: EditPlayerPopoverViewController {
            var dismissedCalledCount = 0
            override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
                dismissedCalledCount += 1
            }
        }
        
        // given
        let sut = EditPlayerPopoverViewControllerDismissMock()
        
        // when
        sut.exitButtonTapped(0)
        
        // then
        XCTAssertEqual(sut.dismissedCalledCount, 1)
    }
    
    
    // MARK: - Classes
    
    class EditPlayerPopoverDelegateMock: EditPlayerPopoverDelegateProtocol {
        var finishedEditingCalledCount = 0
        var finishedEditingPlayer: PlayerProtocol?
        var finishedEditingName: String?
        func finishedEditing(_ player: PlayerProtocol, toNewName name: String) {
            finishedEditingCalledCount += 1
            finishedEditingPlayer = player
            finishedEditingName = name
        }
    }
}
