//
//  CoreDataStoreProtocol.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/5/24.
//

import Foundation
import CoreData

protocol CoreDataStoreProtocol: AnyObject {
    var persistentContainer: NSPersistentContainer { get set }
    
    func saveContext()
    func makeFetchRequest<T:NSFetchRequestResult>(with fetchRequest: NSFetchRequest<T>) throws -> [T]
}
