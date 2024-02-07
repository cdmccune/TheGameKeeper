//
//  ScoreboardPlayerEditScorePopoverViewController.swift
//  Whats The Score
//
//  Created by Curt McCune on 2/1/24.
//

import UIKit

protocol ScoreboardPlayerEditScorePopoverDelegate: AnyObject {
    func edit(player: Player, scoreBy change: Int)
}

class ScoreboardPlayerEditScorePopoverViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var pointsTextField: UITextField!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var subtractButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    
    // MARK: - Properties
    
    var player: Player?
    weak var delegate: ScoreboardPlayerEditScorePopoverDelegate?
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTargets()
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
    
    
    // MARK: - IBActions
    
    @IBAction func addButtonTapped(_ sender: Any) {
        guard let player,
              let pointsText = pointsTextField.text,
              let pointsInt = Int(pointsText),
              pointsInt > 0 else { return }
        
        delegate?.edit(player: player, scoreBy: pointsInt)
        self.dismiss(animated: true)
    }
    
    @IBAction func subtractButtonTapped(_ sender: Any) {
        guard let player,
              let pointsText = pointsTextField.text,
              let pointsInt = Int(pointsText),
              pointsInt > 0 else { return }
        
        delegate?.edit(player: player, scoreBy: (-1 * pointsInt))
        self.dismiss(animated: true)
    }
    

}
