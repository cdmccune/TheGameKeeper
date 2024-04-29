//
//  EditPlayerPopoverViewController.swift
//  Whats The Score
//
//  Created by Curt McCune on 2/8/24.
//

import UIKit

protocol EditPlayerPopoverDelegateProtocol: AnyObject {
    func finishedEditing(_ player: PlayerSettings)
}

class EditPlayerPopoverViewController: UIViewController, Storyboarded, DismissingPopoverViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var playerNameTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var playerIconButton: UIButton!
    
    
    // MARK: - Properties
    
    var player: PlayerSettings?
    var delegate: EditPlayerPopoverDelegateProtocol?
    var dismissingDelegate: PopoverDimissingDelegate?
    var playerIconSelectionCustomDetentHelper: PlayerIconSelectionCustomDetentHelperProtocol = PlayerIconSelectionCustomDetentHelper()
    lazy var textFieldDelegate = DismissingTextFieldDelegate()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setDelegatesAndTargets()
    }
    
    
    // MARK: - Private Functions
    
    private func setupViews() {
        self.playerNameTextField.becomeFirstResponder()
        
        self.playerNameTextField.text = player?.name
        self.saveButton.isEnabled = (player?.name != "")
        
        playerIconButton.imageView?.contentMode = .scaleAspectFit
        playerIconButton.imageView?.layer.cornerRadius = 25
        playerIconButton.imageView?.clipsToBounds = true
        playerIconButton.imageView?.layer.borderWidth = 2
        
        if let player {
            setupPlayerIconButtonFor(icon: player.icon)
        }
    }
    
    private func setDelegatesAndTargets() {
        playerNameTextField.delegate = textFieldDelegate
        playerNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        saveButton.isEnabled = textField.text != ""
    }
    
    
    // MARK: - Functions
    
    func setupPlayerIconButtonFor(icon: PlayerIcon) {
        playerIconButton.imageView?.layer.borderColor = icon.color.cgColor
        playerIconButton.setImage(icon.image, for: .normal)
    }
    
    
    // MARK: - IBActions
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard var player,
              let name = playerNameTextField.text else { return }
        
        player.name = name
        
        delegate?.finishedEditing(player)
        dismissPopover()
    }
    
    @IBAction func exitButtonTapped(_ sender: Any) {
        dismissPopover()
    }
    
    @IBAction func playerIconButtonTapped(_ sender: Any) {
        let playerIconSelectionVC = PlayerIconSelectionViewController.instantiate()
        let viewModel = PlayerIconSelectionViewModel()
        viewModel.delegate = self
        playerIconSelectionVC.viewModel = viewModel
        
        playerIconSelectionCustomDetentHelper.viewModel = viewModel
        
        let detent = playerIconSelectionCustomDetentHelper.getCustomDetentFor(forScreenSize: UIScreen.main.bounds.size)
        
        if let sheetPresentationController = playerIconSelectionVC.sheetPresentationController {
            sheetPresentationController.detents = [detent]
        }
 
        present(playerIconSelectionVC, animated: true)
    }
}

extension EditPlayerPopoverViewController: PlayerIconSelectionDelegate {
    func newIconSelected(icon: PlayerIcon) {
        player?.icon = icon
        setupPlayerIconButtonFor(icon: icon)
    }
}
