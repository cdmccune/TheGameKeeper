//
//  PlayerIconSelectionCollectionViewCell.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/18/24.
//

import Foundation
import UIKit

class PlayerIconSelectionCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    
    func setupCellForIcon(_ icon: PlayerIcon) {
        iconImageView.image = icon.image
        iconImageView.layer.borderWidth = 2
        iconImageView.layer.borderColor = icon.color.cgColor
        iconImageView.clipsToBounds = true
        iconImageView.layer.cornerRadius = 25
    }
}
