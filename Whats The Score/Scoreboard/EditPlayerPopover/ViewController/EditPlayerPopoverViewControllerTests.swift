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
        let player = PlayerSettings.getStub(name: playerName)
        sut.player = player
        
        // when
        sut.loadView()
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(sut.playerNameTextField.text, playerName)
    }
    
    func test_EditPlayerPopoverViewController_WhenViewDidLoadCalled_ShouldSetVisualPropertiesOnPlayerIconButton() {
        // given
        let sut = viewController!
        sut.loadView()
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(sut.playerIconButton.imageView?.contentMode, .scaleAspectFit)
        XCTAssertEqual(sut.playerIconButton.imageView?.layer.cornerRadius, 25)
        XCTAssertTrue(sut.playerIconButton.imageView?.clipsToBounds ?? false)
        XCTAssertEqual(sut.playerIconButton.imageView?.layer.borderWidth, 2)
    }
    
    func test_EditPlayerPopoverViewController_WhenViewDidLoadCalled_ShouldCallSetupPlayerButtonViewsForWithPlayerIcon() {
        class EditPlayerPopoverViewControllerSetupPlayerIconButtonForMock: EditPlayerPopoverViewController {
            var setupPlayerIconButtonForCalledCount = 0
            var setupPlayerIconButtonForIcon: PlayerIcon?
            override func setupPlayerIconButtonFor(icon: PlayerIcon) {
                setupPlayerIconButtonForCalledCount += 1
                setupPlayerIconButtonForIcon = icon
            }
        }
        
        // given
        let sut = EditPlayerPopoverViewControllerSetupPlayerIconButtonForMock()
        let textField = UITextField()
        sut.playerNameTextField = textField
        let button = UIButton()
        sut.saveButton = button
        sut.playerIconButton = button
        
        let icon = PlayerIcon.allCases.randomElement()!
        let playerSettings = PlayerSettings.getStub(icon: icon)
        sut.player = playerSettings
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(sut.setupPlayerIconButtonForCalledCount, 1)
        XCTAssertEqual(sut.setupPlayerIconButtonForIcon, icon)
    }
    
    func test_EditPlayerPopoverViewController_WhenViewDidLoadCalled_ShouldCallUnderlineButtonForButtonStatesWithStringAndSizeOnPlayerIconButton() {
        // given
        let sut = viewController!
        sut.loadView()
        
        let button = UIButtonUnderlineButtonForButtonStatesMock()
        sut.playerIconButton = button
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(button.underlineButtonForButtonStatesCalledCount, 1)
        XCTAssertEqual(button.underlineButtonForButtonStatesTextSize, 10)
        XCTAssertEqual(button.underlineButtonForButtonStatesTitle, "Change")
    }
    
    func test_EditPlayerPopoverViewController_WhenViewDidLoadCalled_ShouldCallUnderlineButtonForButtonStatesWithStringAndSizeOnSaveButton() {
        // given
        let sut = viewController!
        sut.loadView()
        
        let button = UIButtonUnderlineButtonForButtonStatesMock()
        sut.saveButton = button
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(button.underlineButtonForButtonStatesCalledCount, 1)
        XCTAssertEqual(button.underlineButtonForButtonStatesTextSize, 22)
        XCTAssertEqual(button.underlineButtonForButtonStatesTitle, "Save")
    }
    
    func test_EditPlayerPopoverViewController_WhenViewDidLoadCalled_ShouldSetTextFieldDelegateEqualToTextFieldDelegateOnPlayerNameTextField() {
        // given
        let sut = viewController!
        sut.loadView()
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertIdentical(sut.playerNameTextField.delegate, sut.textFieldDelegate)
    }
    
    func test_EditPlayerPopoverViewController_WhenViewDidLoadCalled_ShouldAddTargetToNameTextFieldForEditingDidChange() {
        // given
        let sut = viewController!
        sut.loadView()
        
        // when
        sut.viewDidLoad()
        
        // then
        let targets = sut.playerNameTextField.allTargets
        XCTAssertTrue(targets.contains(sut))
    }
    
    
    // MARK: - TextFieldDidChange
    
    func test_EditPlayerPopoverViewController_WhenPlayerNameTextFieldValueBlankEditingChanged_ShouldMakeSaveButtonDisabled() {
        // given
        let sut = viewController!
        sut.loadView()
        sut.viewDidLoad()
        
        sut.saveButton.isEnabled = true
        sut.playerNameTextField.text = ""
        
        // when
        sut.playerNameTextField.sendActions(for: .editingChanged)
        
        // then
        XCTAssertFalse(sut.saveButton.isEnabled)
    }
    
    func test_EditPlayerPopoverViewController_WhenPlayerNameTextFieldValueNotBlankEditingChanged_ShouldMakeSaveButtonEnabled() {
        // given
        let sut = viewController!
        sut.loadView()
        sut.viewDidLoad()
        
        sut.saveButton.isEnabled = false
        sut.playerNameTextField.text = "d"
        
        // when
        sut.playerNameTextField.sendActions(for: .editingChanged)
        
        // then
        XCTAssertTrue(sut.saveButton.isEnabled)
    }
    
    
    // MARK: - SetupPlayerIconButtonFor
    
    func test_EditPlayerPopoverViewController_WhenSetupPlayerIconButtonForCalled_ShouldSetPlayerIconButtonImageToIconImageAndBorderColorToColor() {
        // given
        let sut = viewController!
        sut.loadView()
        
        let playerIcon = PlayerIcon.allCases.randomElement()!
        
        // when
        sut.setupPlayerIconButtonFor(icon: playerIcon)
        
        // then
        XCTAssertEqual(sut.playerIconButton.image(for: .normal), playerIcon.image)
        XCTAssertTrue(sut.playerIconButton.imageView?.layer.borderColor?.same(as: playerIcon.color.cgColor) ?? false)
    }
    
    
    // MARK: - SaveButtonTapped
    
    func test_EditPlayerPopoverViewController_WhenSaveButtonTapped_ShouldCallDelegateFinishedEditingWithNewPlayerAndTextAsName() {
        // given
        let sut = viewController!
        let player = PlayerSettings.getStub(name: UUID().uuidString)
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
        XCTAssertEqual(delegateMock.finishedEditingPlayer?.name, name)
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
        sut.player = PlayerSettings.getStub(name: UUID().uuidString)
        let textField = UITextField()
        sut.playerNameTextField = textField
        
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
    
    
    // MARK: - PlayerIconButtonTapped
    
    class EditPlayerPopoverViewControllerPresentMock: EditPlayerPopoverViewController {
        var presentCalledCount = 0
        var presentViewController: UIViewController?
        override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
            self.presentViewController = viewControllerToPresent
            self.presentCalledCount += 1
        }
    }
    
    func test_EditPlayerPopoverViewController_WhenPlayerIconButtonTappedCalled_ShouldPresentPlayerIconSelectionViewController() {
        // given
        let sut = EditPlayerPopoverViewControllerPresentMock()
        
        // when
        sut.playerIconButtonTapped(0)
        
        // then
        XCTAssertEqual(sut.presentCalledCount, 1)
        XCTAssertTrue(sut.presentViewController is PlayerIconSelectionViewController)
    }
    
    func test_EditPlayerPopoverViewController_WhenPlayerIconButtonTappedCalled_ShouldSetSelfAsViewModelDelegate() {
        // given
        let sut = EditPlayerPopoverViewControllerPresentMock()
        
        // when
        sut.playerIconButtonTapped(0)
        
        // then
        let playerIconSelectionVC = sut.presentViewController as? PlayerIconSelectionViewController
        XCTAssertIdentical(playerIconSelectionVC?.viewModel?.delegate, sut)
    }
    
    func test_EditPlayerPopoverViewController_WhenPlayerIconButtonTappedCalled_ShouldSetPresentedVCViewModelAndPlayerIconSelectionCustomDetentHelperViewModelAsSame() {
        // given
        let sut = EditPlayerPopoverViewControllerPresentMock()
        
        // when
        sut.playerIconButtonTapped(0)
        
        // then
        let playerIconSelectionVC = sut.presentViewController as? PlayerIconSelectionViewController
        XCTAssertIdentical(sut.playerIconSelectionCustomDetentHelper.viewModel, playerIconSelectionVC?.viewModel)
    }
    
    func test_EditPlayerPopoverViewController_WhenPlayerIconButtonTappedCalled_ShouldCallPlayerIconSelectionDetentHelperGetCustomDetent() {
        // given
        let sut = viewController!
        
        let detentHelperMock = PlayerIconSelectionCustomDetentHelperMock()
        sut.playerIconSelectionCustomDetentHelper = detentHelperMock
        
        // when
        sut.playerIconButtonTapped(0)
        
        // then
        XCTAssertEqual(detentHelperMock.getCustomDetentForCalledCount, 1)
    }
    
    func test_EditPlayerPopoverViewController_WhenPlayerIconButtonTappedCalled_ShouldSetPlayerIconSelectionVCSheetPresentationControllerDetentToDetentReturnedFromHelper() {
        // given
        let sut = EditPlayerPopoverViewControllerPresentMock()
        
        let detentHelper = PlayerIconSelectionCustomDetentHelperMock()
        let detentToReturn: UISheetPresentationController.Detent = Bool.random() ? .medium() : .large()
        detentHelper.detentToReturn = detentToReturn
        sut.playerIconSelectionCustomDetentHelper = detentHelper

        // when
        sut.playerIconButtonTapped(0)
        
        // then
        let playerIconSelectionVC = sut.presentViewController as? PlayerIconSelectionViewController
        XCTAssertEqual(detentToReturn, playerIconSelectionVC?.sheetPresentationController?.detents[0])
    }
    
    
    // MARK: - NewIconSelected
    
    func test_EditPlayerPopoverViewController_WhenNewIconSelected_ShouldSetPlayerSettingsIconEqualToIconSent() {
        // given
        let sut = viewController!
        
        let originalIcon = PlayerIcon(rawValue: 0)!
        let playerSettings = PlayerSettings.getStub(icon: originalIcon)
        sut.player = playerSettings
        
        let randomNewIcon = PlayerIcon(rawValue: Int.random(in: 1..<PlayerIcon.allCases.count))!
        
        // when
        sut.newIconSelected(icon: randomNewIcon)
        
        // then
        XCTAssertEqual(sut.player?.icon, randomNewIcon)
    }
    
    func test_EditPlayerPopoverViewController_WhenNewIconSelectedCalled_ShouldCallSetupPlayerIconButtonForWithPlayerIcon() {
        class EditPlayerPopoverViewControllerSetupPlayerIconButtonForMock: EditPlayerPopoverViewController {
            var setupPlayerIconButtonForCalledCount = 0
            var setupPlayerIconButtonForIcon: PlayerIcon?
            override func setupPlayerIconButtonFor(icon: PlayerIcon) {
                setupPlayerIconButtonForCalledCount += 1
                setupPlayerIconButtonForIcon = icon
            }
        }
        
        // given
        let sut = EditPlayerPopoverViewControllerSetupPlayerIconButtonForMock()
        let icon = PlayerIcon.allCases.randomElement()!
        
        // whenName
        sut.newIconSelected(icon: icon)
        
        // then
        XCTAssertEqual(sut.setupPlayerIconButtonForCalledCount, 1)
        XCTAssertEqual(sut.setupPlayerIconButtonForIcon, icon)
    }
    
    
    // MARK: - Classes
    
    class EditPlayerPopoverDelegateMock: EditPlayerPopoverDelegateProtocol {
        var finishedEditingCalledCount = 0
        var finishedEditingPlayer: PlayerSettings?
        func finishedEditing(_ player: PlayerSettings) {
            finishedEditingCalledCount += 1
            finishedEditingPlayer = player
        }
    }
}
