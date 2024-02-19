//
//  HighlightNextCellInTableViewTextFieldDelegate.swift
//  Whats The Score
//
//  Created by Curt McCune on 2/18/24.
//

import Foundation
import UIKit

class HighlightNextCellInTableViewTextFieldDelegate: NSObject, UITextFieldDelegate {
    init(tableView: UITableView) {
        self.tableView = tableView
    }
    
    var tableView: UITableView
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tableView.viewWithTag(textField.tag + 1)?.becomeFirstResponder()
        return false
    }
}
