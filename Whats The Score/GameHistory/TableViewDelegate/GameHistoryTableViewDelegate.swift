//
//  GameHistoryTableViewDelegate.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/11/24.
//

import Foundation
import UIKit

class GameHistoryTableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Init
    
    init(viewModel: GameHistoryViewModelProtocol) {
        self.viewModel = viewModel
    }
    
    
    // MARK: - Properties
    
    var viewModel: GameHistoryViewModelProtocol
    
    
    // MARK: - Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
