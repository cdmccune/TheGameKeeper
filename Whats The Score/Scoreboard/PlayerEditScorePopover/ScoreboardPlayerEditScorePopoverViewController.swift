//
//  ScoreboardPlayerEditScorePopoverViewController.swift
//  Whats The Score
//
//  Created by Curt McCune on 2/1/24.
//

import UIKit

protocol ScoreboardPlayerEditScorePopoverDelegate: AnyObject {
    func editScore(_ scoreChange: ScoreChange)
}

class ScoreboardPlayerEditScorePopoverViewController: UIViewController {
    
    #warning("Need to edit popover to use scoreChangeObject instead of player and put score change value on text field. Also to send back object to delegate instead of making one. Also build functionality for GameHistoryViewModel to handle values being sent back. Also ")
    
    // MARK: - Outlets
    
    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var pointsTextField: UITextField!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var subtractButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    
    // MARK: - Properties
    
    var player: Player?
    var scoreChange: ScoreChange?
    weak var delegate: ScoreboardPlayerEditScorePopoverDelegate?
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTargets()
        setupViews()
        pointsTextField.becomeFirstResponder()
    }
    
    
    // MARK: - Private Funcs

    private func addTargets() {
        pointsTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let pointsText = pointsTextField.text,
            let pointsInt = Int(pointsText),
            pointsInt > 0 else {
                subtractButton.isEnabled = false
                addButton.isEnabled = false
            return
        }
        
        subtractButton.isEnabled = true
        addButton.isEnabled = true
    }
    
    private func setupViews() {
        playerLabel.text = player?.name
    }
    
    // MARK: - IBActions
    
    @IBAction func addButtonTapped(_ sender: Any) {
        guard let player,
              let pointsText = pointsTextField.text,
              let pointsInt = Int(pointsText),
              pointsInt > 0 else { return }
        
        let scoreChange = ScoreChange(player: player, scoreChange: pointsInt)
        delegate?.editScore(scoreChange)
        self.dismiss(animated: true)
    }
    
    @IBAction func subtractButtonTapped(_ sender: Any) {
        guard let player,
              let pointsText = pointsTextField.text,
              let pointsInt = Int(pointsText),
              pointsInt > 0 else { return }
        
        let scoreChange = ScoreChange(player: player, scoreChange: -1 * pointsInt)
        delegate?.editScore(scoreChange)
        self.dismiss(animated: true)
    }
    
    @IBAction func exitButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
