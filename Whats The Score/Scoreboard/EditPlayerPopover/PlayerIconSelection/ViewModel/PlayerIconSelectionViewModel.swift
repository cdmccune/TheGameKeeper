//
//  PlayerIconSelectionViewModel.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/18/24.
//

import Foundation

class PlayerIconSelectionViewModel: PlayerIconSelectionViewModelProtocol {
    var icons = PlayerIcon.allCases
    weak var delegate: PlayerIconSelectionDelegate?
    var shouldDismiss: Observable<Bool> = Observable(nil)
    
    func iconSelectAt(row: Int) {
        guard row < icons.count else { return }
        let selectedIcon = icons[row]
        delegate?.newIconSelected(icon: selectedIcon)
        
        shouldDismiss.value = true
    }
}
