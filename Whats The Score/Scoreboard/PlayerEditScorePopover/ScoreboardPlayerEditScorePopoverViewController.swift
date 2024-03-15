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
    
    // MARK: - Outlets
    
    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var pointsTextField: UITextField!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var subtractButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    
    // MARK: - Properties
    
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
        playerLabel.text = scoreChange?.playerName
        
        if let scoreChange = scoreChange?.scoreChange,
           scoreChange != 0 {
            pointsTextField.text = String(abs(scoreChange))
        } else {
            pointsTextField.text = ""
        }
        
    }
    
    // MARK: - IBActions
    
    @IBAction func addButtonTapped(_ sender: Any) {
        guard var scoreChange,
              let pointsText = pointsTextField.text,
              let pointsInt = Int(pointsText),
              pointsInt > 0 else { return }
        
        scoreChange.scoreChange = pointsInt
        delegate?.editScore(scoreChange)
        self.dismiss(animated: true)
    }
    
    @IBAction func subtractButtonTapped(_ sender: Any) {
        guard var scoreChange,
              let pointsText = pointsTextField.text,
              let pointsInt = Int(pointsText),
              pointsInt > 0 else { return }
        
        scoreChange.scoreChange = -1 * pointsInt
        delegate?.editScore(scoreChange)
        self.dismiss(animated: true)
    }
    
    @IBAction func exitButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
