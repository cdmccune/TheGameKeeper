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

class EditPlayerPopoverViewController: UIViewController, Storyboarded {
    
    // MARK: - Outlets
    
    @IBOutlet weak var playerNameTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var playerIconButton: UIButton!
    
    
    // MARK: - Properties
    
    var player: PlayerSettings?
    var delegate: EditPlayerPopoverDelegateProtocol?
    lazy var textFieldDelegate = DismissingTextFieldDelegate()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setDelegatesAndTargets()
    }
    
    
    // MARK: - Private Functions
    
    private func setupViews() {
        self.playerNameTextField.text = player?.name
        
        playerIconButton.imageView?.contentMode = .scaleAspectFit
        playerIconButton.imageView?.layer.cornerRadius = 25
        playerIconButton.imageView?.clipsToBounds = true
        playerIconButton.imageView?.layer.borderWidth = 2
        
        playerIconButton.underlineButtonForButtonStates(title: "Change", withTextSize: 10)
        saveButton.underlineButtonForButtonStates(title: "Save", withTextSize: 22)
        
        if let player {
            playerIconButton.imageView?.layer.borderColor = player.icon.color.cgColor
            playerIconButton.setImage(player.icon.image, for: .normal)
        }
    }
    
    private func setDelegatesAndTargets() {
        playerNameTextField.delegate = textFieldDelegate
        playerNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        saveButton.isEnabled = textField.text != ""
    }
    
    
    // MARK: - IBActions
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard var player,
              let name = playerNameTextField.text else { return }
        
        player.name = name
        
        delegate?.finishedEditing(player)
        self.dismiss(animated: true)
    }
    
    @IBAction func exitButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func playerIconButtonTapped(_ sender: Any) {
        let editPlayerPopoverVC = EditPlayerPopoverViewController.instantiate()
        present(editPlayerPopoverVC, animated: true)
    }
    
}
