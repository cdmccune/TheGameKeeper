//
//  PlayerSetupPlayerTableViewCell.swift
//  What's The Score
//
//  Created by Curt McCune on 1/9/24.
//

import UIKit

class PlayerSetupPlayerTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        playerTextField.delegate = textFieldDelegate
    }
    
    lazy var textFieldDelegate = PlayerSetupNameTextFieldDelegate()
    var playerNameChanged: ((String) -> Void )?
    
    @IBOutlet weak var playerTextField: UITextField!

    @IBAction func playerTextFieldEditingDidEnd(_ sender: Any) {
        playerNameChanged?(playerTextField.text ?? "")
    }
    
    
}
