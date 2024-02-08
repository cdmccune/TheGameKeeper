//
//  EditPlayerPopoverViewController.swift
//  Whats The Score
//
//  Created by Curt McCune on 2/8/24.
//

import UIKit

protocol EditPlayerPopoverDelegateProtocol {
    func finishedEditing(_ player: Player)
}

class EditPlayerPopoverViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var playerNameTextField: UITextField!
    @IBOutlet weak var colorCollectionView: UICollectionView!
    @IBOutlet weak var saveButton: UIButton!
    
    
    // MARK: - Properties
    
    var player: Player?
    var delegate: EditPlayerPopoverDelegateProtocol?
    lazy var textFieldDelegate = DismissingTextFieldDelegate()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setDelegates()
        setupViews()
    }
    
    
    // MARK: - Private Functions
    
    private func setDelegates() {
        playerNameTextField.delegate = textFieldDelegate
    }
    
    private func setupViews() {
        self.playerNameTextField.text = player?.name
    }
    

    // MARK: - IBActions
    
    @IBAction func playerNameTextFieldEditingDidEnd(_ sender: Any) {
        player?.name = playerNameTextField.text ?? ""
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let player else { return }
        delegate?.finishedEditing(player)
        self.dismiss(animated: true)
    }
    
}
