//
//  EndRoundPopoverViewController.swift
//  Whats The Score
//
//  Created by Curt McCune on 2/16/24.
//

import UIKit

class EndRoundPopoverViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var playerScrollView: UIScrollView!
    @IBOutlet weak var playerStackView: UIStackView!
    
//    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Properties
    
    var players: [Player]?
    var round: Int?
    var playerCellHeight = 45
    var playerSeparator = 3
    var textFields: [UITextField] = []
    var playerScoreChanges: [Int] = []
    
    
    // MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupPlayerStackView()
        playerScoreChanges = Array(repeating: 0, count: players?.count ?? 0)
    }
    
    
    // MARK: - Private Functions
    
    private func setupPlayerStackView() {
        guard let players = players else { return }
        for i in players.indices {
            let textField = UITextField()
            let textFieldDelegate = StackViewTextFieldDelegate(delegate: self)
            textField.tag = i
            playerStackView.addArrangedSubview(EndRoundPopoverPlayerStackView(player: players[i], textField: textField, textFieldDelegate: textFieldDelegate))
        }
    }
    
    private func setupViews() {
        if let round {
            roundLabel.text = "Round \(round)"
        } else {
            roundLabel.text = "Round ???"
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension EndRoundPopoverViewController: StackViewTextFieldDelegateDelegate {
    func textFieldValueChanged(forIndex index: Int, to newValue: Int) {
        guard playerScoreChanges.indices.contains(index) else { return }
        playerScoreChanges[index] = newValue
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
        let textfieldY = 48 * textFieldIndex
        let bottomOfScrollView = playerScrollView.contentOffset.y + playerScrollView.frame.height
        
        if !(Int(textfieldY) < Int(bottomOfScrollView)) {
            let yCoordinate = Int(textfieldY) - Int(playerScrollView.frame.height) + 48
            let point = CGPoint(x: 0, y: yCoordinate)
            playerScrollView.contentOffset = point
        }
    }
}
