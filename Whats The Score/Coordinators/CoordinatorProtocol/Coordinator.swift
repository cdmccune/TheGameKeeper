//
//  Coordinator.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/20/24.
//

import Foundation

protocol Coordinator {
    func start()
    
    var childCoordinators: [Coordinator] { get set }
    var navigationController: RootNavigationController { get set }
}
