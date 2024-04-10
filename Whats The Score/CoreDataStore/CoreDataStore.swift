//
//  CoreDataStore.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/4/24.
//

import Foundation
import CoreData

enum StorageType {
    case persistent, inMemory
}

class CoreDataStore: CoreDataStoreProtocol {
    var persistentContainer: NSPersistentContainer
    
    init(_ storageType: StorageType = .persistent) {
        self.persistentContainer = NSPersistentContainer(name: "CoreDataModel")
        
        if storageType == .inMemory {
            let description = NSPersistentStoreDescription()
            description.url = URL(fileURLWithPath: "/dev/null")
            self.persistentContainer.persistentStoreDescriptions = [description]
            
        }
        
        self.persistentContainer.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func makeFetchRequest<T:NSFetchRequestResult>(with fetchRequest: NSFetchRequest<T>) throws -> [T] {
        return []
    }
}
