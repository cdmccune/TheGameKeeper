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
        
        setupViews()
        addViewsAndConstraints()
        
    }
    
    required init(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    var player: Player
    var textField: UITextField
    var textFieldDelegate: UITextFieldDelegate
    
    private func setupViews() {
        self.axis = .horizontal
        self.spacing = 5
    }
    
    private func addViewsAndConstraints() {
        let label = UILabel()
        label.text = player.name
        self.addArrangedSubview(label)
        
        textField.borderStyle = .roundedRect
        textField.placeholder = "0"
        textField.keyboardType = .numberPad
        self.addArrangedSubview(textField)
        
        textField.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
}
