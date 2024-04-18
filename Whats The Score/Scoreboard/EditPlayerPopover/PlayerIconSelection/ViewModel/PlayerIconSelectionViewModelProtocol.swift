//
//  PlayerIconSelectionViewModelProtocol.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/18/24.
//

import Foundation

protocol PlayerIconSelectionViewModelProtocol: AnyObject {
    var icons: [PlayerIcon] { get }
    func iconSelectAt(row: Int)
}
