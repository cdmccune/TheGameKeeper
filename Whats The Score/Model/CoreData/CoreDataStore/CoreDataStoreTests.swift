//
//  CoreDataStoreTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 5/3/24.
//

import XCTest
@testable import Whats_The_Score
import CoreData

final class CoreDataStoreTests: XCTestCase {
    
    var sut: CoreDataStore!
    
    override func setUp() {
        super.setUp()
        // Initialize CoreDataStore with inMemory storage type
        sut = CoreDataStore(.inMemory)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func test_CoreDataStore_WhenInitializedWithInMemory_ShouldInitializeWithoutError() {
        // given
        // Initialization is done in setUp
        
        // when
        // Testing initialization

        // then
        XCTAssertNotNil(sut.persistentContainer, "Persistent container should not be nil")
        XCTAssertNoThrow(try sut.persistentContainer.viewContext.fetch(NSFetchRequest<NSFetchRequestResult>(entityName: "Game")), "Fetch should not throw an error")
    }
    
    func test_CoreDataStore_WhenSaveContextCalled_ShouldCallSaveOnContext() {
        // given
        class MockManagedObjectContext: NSManagedObjectContext {
            var saveCalledCount = 0
            override func save() throws {
                saveCalledCount += 1
            }
        }
        
        class PersistentContainerMock: NSPersistentContainer {
            var temporaryViewContext: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            override var viewContext: NSManagedObjectContext {
                temporaryViewContext
            }
        }
        
        let mockContainer = PersistentContainerMock(name: "test", managedObjectModel: NSManagedObjectModel())
        let mockContext = MockManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mockContext.persistentStoreCoordinator = sut.persistentContainer.persistentStoreCoordinator
        mockContainer.temporaryViewContext = mockContext
        sut.persistentContainer = mockContainer
        
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Game", into: mockContext)
        entity.setValue(UUID(), forKey: "id")
        
        // when
        sut.saveContext()
        
        // then
        XCTAssertEqual(mockContext.saveCalledCount, 1, "Save should be called on the context")
    }
    
    func test_CoreDataStore_WhenMakeFetchRequestCalled_ShouldReturnExpectedResults() throws {
        // given
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "Game")
        let testObject = NSEntityDescription.insertNewObject(forEntityName: "Game", into: sut.persistentContainer.viewContext)
        testObject.setValue(UUID(), forKey: "id")
        try sut.persistentContainer.viewContext.save()
        
        // when
        let results = try sut.makeFetchRequest(with: fetchRequest)
        
        // then
        XCTAssertEqual(results.count, 1, "Should fetch exactly one object")
        XCTAssertEqual(results.first, testObject, "Fetched object should match the saved object")
    }
    
    func test_CoreDataStore_WhenDeleteObjectCalled_ShouldRemoveObjectFromContext() throws {
        // given
        let testObject = NSEntityDescription.insertNewObject(forEntityName: "Game", into: sut.persistentContainer.viewContext)
        testObject.setValue(UUID(), forKey: "id")
        try sut.persistentContainer.viewContext.save()
        
        // when
        sut.deleteObject(testObject)
        
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "Game")
        let results = try sut.persistentContainer.viewContext.fetch(fetchRequest)
        
        // then
        XCTAssertTrue(results.isEmpty, "There should be no objects after deletion")
    }
}
