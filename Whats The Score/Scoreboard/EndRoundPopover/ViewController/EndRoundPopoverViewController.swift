//
//  EndRoundPopoverViewController.swift
//  Whats The Score
//
//  Created by Curt McCune on 2/16/24.
//

import UIKit

protocol EndRoundPopoverDelegateProtocol {
    func endRound(_ endRound: EndRoundSettings)
}

class EndRoundPopoverViewController: UIViewController, Storyboarded, DismissingPopoverViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var playerScrollView: UIScrollView!
    @IBOutlet weak var playerStackView: UIStackView!
    @IBOutlet weak var endRoundButton: UIButton!
    
    
    // MARK: - Properties
    
    var dismissingDelegate: PopoverDimissingDelegate?
    var delegate: EndRoundPopoverDelegateProtocol?
    var endRound: EndRoundSettings?
    var playerViewHeight: Int?
    var playerSeparatorHeight: Int?
    var textFields: [UITextField] = []
    
    
    // MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupPlayerStackView()
        plugInEndRoundValues()
    }
    
    
    // MARK: - Private Functions
    
    private func setupPlayerStackView() {
        guard let endRound else { return }
        for i in endRound.scoreChangeSettingsArray.indices {
            let textField = EndRoundPopoverTextField(delegate: self,
                                                     isLast: i == endRound.scoreChangeSettingsArray.count - 1,
                                                     index: i)
            let textFieldDelegate = StackViewTextFieldDelegate(delegate: self)
            textField.tag = i
            textFields.append(textField)
            
            let singlePlayerStackView = EndRoundPopoverPlayerStackView(playerName: endRound.scoreChangeSettingsArray[i].player.name, playerID: endRound.scoreChangeSettingsArray[i].player.id, textField: textField, textFieldDelegate: textFieldDelegate)
            
            singlePlayerStackView.heightAnchor.constraint(equalToConstant: CGFloat(playerViewHeight ?? 0)).isActive = true
            
            self.playerStackView.addArrangedSubview(singlePlayerStackView)
        }
        
        playerStackView.spacing = CGFloat(playerSeparatorHeight ?? 0)
    }
    
    private func setupViews() {
        
        if let round = endRound?.roundNumber {
            roundLabel.text = "Round \(round)"
        } else {
            roundLabel.text = "Round ???"
        }
    }
    
    private func plugInEndRoundValues() {
        guard let endRound else { return }
        
        for index in 0..<textFields.count {
            let scoreChange = endRound.scoreChangeSettingsArray[index].scoreChange
            
            if scoreChange == 0 {
                textFields[index].text = ""
            } else {
                textFields[index].text = String(scoreChange)
            }
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func endRoundButtonTapped(_ sender: Any) {
        guard let endRound else {
            return
        }
        
        delegate?.endRound(endRound)
        dismissPopover()
    }
    
    @IBAction func exitButtonTapped(_ sender: Any) {
        dismissPopover()
    }
    
}

extension EndRoundPopoverViewController: StackViewTextFieldDelegateDelegateProtocol {
    func textFieldValueChanged(forIndex index: Int, to newValue: String?) {
        guard endRound?.scoreChangeSettingsArray.indices.contains(index) ?? false else { return }
        endRound?.scoreChangeSettingsArray[index].scoreChange = Int(newValue ?? "0") ?? 0
    }
    
    func textFieldShouldReturn(for index: Int) {
        guard textFields.indices.contains(index) else { return }
        
        if textFields.indices.contains(index + 1) {
            textFields[index + 1].becomeFirstResponder()
        } else {
            textFields[index].endEditing(true)
        }
    }
    
    func textFieldEditingBegan(index: Int) {
        let textFieldIndex = index
        let completePlayerHeight = (playerViewHeight ?? 0) + (playerSeparatorHeight ?? 0)
        let textfieldY = completePlayerHeight * textFieldIndex
        let bottomOfScrollView = playerScrollView.contentOffset.y + playerScrollView.frame.height
        
        if !(Int(textfieldY) < Int(bottomOfScrollView)) {
            let yCoordinate = Int(textfieldY) - Int(playerScrollView.frame.height) + completePlayerHeight
            let point = CGPoint(x: 0, y: yCoordinate)
            playerScrollView.contentOffset = point
        }
    }
}
