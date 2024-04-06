//
//  CoreDataStoreMock.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 4/5/24.
//

import Foundation
import CoreData
@testable import Whats_The_Score

class CoreDataStoreMock: CoreDataStoreProtocol {
    init() {
        self.persistentContainer = NSPersistentContainer(name: "CoreDataModel")
        
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        self.persistentContainer.persistentStoreDescriptions = [description]
        
        self.persistentContainer.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
        
    var persistentContainer: NSPersistentContainer
}
