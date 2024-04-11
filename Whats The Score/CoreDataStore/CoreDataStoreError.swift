//
//  CoreDataStoreError.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/11/24.
//

import Foundation

enum CoreDataStoreError: Error {
    case fetchError(description: String)
    case saveError(description: String)
    case dataError(description: String)
    
    func getDescription() -> String {
        switch self {
        case .fetchError(let description):
            return description
        case .saveError(let description):
            return description
        case .dataError(let description):
            return description
        }
    }
}
