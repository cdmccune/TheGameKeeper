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
    
    var errorToReturn: CoreDataStoreError?
    
    var saveContextCalledCount = 0
    func saveContext() {
        saveContextCalledCount += 1
    }
    
    var makeFetchRequestArrayToReturn = [Any]()
    var makeFetchRequestCalledCount = 0
    var makeFetchRequestRequest: Any?
    func makeFetchRequest<T>(with fetchRequest: NSFetchRequest<T>) throws -> [T] where T: NSFetchRequestResult {
        self.makeFetchRequestCalledCount += 1
        self.makeFetchRequestRequest = fetchRequest
        if let errorToReturn {
            throw errorToReturn
        } else {
            return makeFetchRequestArrayToReturn as! [T]
        }
    }
    
    var deleteObjectObject: NSManagedObject?
    var deleteObjectCalledCount = 0
    func deleteObject(_ object: NSManagedObject) {
        deleteObjectObject = object
        deleteObjectCalledCount += 1
    }
}
