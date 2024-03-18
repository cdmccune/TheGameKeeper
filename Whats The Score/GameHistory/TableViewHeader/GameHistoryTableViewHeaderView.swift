//
//  GameHistoryTableViewHeaderView.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/18/24.
//

import UIKit

class GameHistoryTableViewHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var roundStackView: UIStackView!
    

    func setupViews(isRoundBasedGame: Bool) {
        roundStackView.isHidden = !isRoundBasedGame
    }

}
