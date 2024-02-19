//
//  EndRoundPopoverPlayerStackView.swift
//  Whats The Score
//
//  Created by Curt McCune on 2/19/24.
//

import UIKit

class EndRoundPopoverPlayerStackView: UIStackView {

    init(player: Player, textField: UITextField, textFieldDelegate: UITextFieldDelegate) {
        self.player = player
        self.textField = textField
        self.textFieldDelegate = textFieldDelegate
        textField.delegate = textFieldDelegate
        super.init(frame: CGRectZero)
    }
    
    required init(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    var player: Player
    var textField: UITextField
    var textFieldDelegate: UITextFieldDelegate
    

    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
