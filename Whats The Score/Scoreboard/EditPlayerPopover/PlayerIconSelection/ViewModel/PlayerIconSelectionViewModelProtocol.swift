//
//  PlayerIconSelectionViewModelProtocol.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/18/24.
//

import Foundation

protocol PlayerIconSelectionViewModelProtocol: AnyObject {
    var icons: [PlayerIcon] { get }
    var delegate: PlayerIconSelectionDelegate? { get set }
    var shouldDismiss: Observable<Bool> {get}
    
    
    func iconSelectAt(row: Int)
}
