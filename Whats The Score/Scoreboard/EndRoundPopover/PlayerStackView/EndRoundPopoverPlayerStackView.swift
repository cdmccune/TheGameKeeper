//
//  EndRoundPopoverPlayerStackView.swift
//  Whats The Score
//
//  Created by Curt McCune on 2/19/24.
//

import UIKit

class EndRoundPopoverPlayerStackView: UIStackView {

    init(playerName: String, playerID: UUID, textField: UITextField, textFieldDelegate: UITextFieldDelegate) {
        self.playerID = playerID
        self.playerName = playerName
        self.textField = textField
        self.textFieldDelegate = textFieldDelegate
        textField.delegate = textFieldDelegate
        super.init(frame: CGRectZero)
        
        setupViews()
        addViewsAndConstraints()
        
    }
    
    required init(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    var playerID: UUID
    var playerName: String
    var textField: UITextField
    var textFieldDelegate: UITextFieldDelegate
    
    private func setupViews() {
        self.axis = .horizontal
        self.spacing = 5
        self.alignment = .center
    }
    
    private func addViewsAndConstraints() {
        let label = UILabel()
        label.font = UIFont(name: "Press Start 2P Regular", size: 15)
        label.textColor = .textColor
        label.text = playerName
        self.addArrangedSubview(label)
        
        let view = UIView()
        self.addArrangedSubview(view)
        
        textField.borderStyle = .roundedRect
        textField.placeholder = "0"
        textField.keyboardType = .numberPad
        self.addArrangedSubview(textField)
    }
}
