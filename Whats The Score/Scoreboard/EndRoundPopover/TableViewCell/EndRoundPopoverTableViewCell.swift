//
//  EndRoundPopoverTableViewCell.swift
//  Whats The Score
//
//  Created by Curt McCune on 2/16/24.
//

import UIKit

class EndRoundPopoverTableViewCell: UITableViewCell {
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var scoreTextField: UITextField!
    
    
    // MARK: - Properties
    
    var textFieldDidChangeHandler: ((Int) -> Void)?
    
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        scoreTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    // MARK: - Functions
    
    func setupViewProperties(for player: Player) {
        playerNameLabel.text = player.name
    }
    
    func setupErrorCell() {
        playerNameLabel.text = "Error"
    }
    
    @objc func textFieldDidChange(_ textfield: UITextField) {
        let number = Int(scoreTextField.text ?? "0") ?? 0
        textFieldDidChangeHandler?(number)
    }
    
    // MARK: - IBActions
    
    
}
