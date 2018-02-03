//
//  CoreDataStack.swift
//  PickupRide
//
//  Created by Niko Mikulicic on 03/02/2018.
//  Copyright © 2018 Niko Mikulicic. All rights reserved.
//

import Foundation
import CoreData

enum CoreDataError: Error {
    case modelCouldNotBeCreated
    case storeCouldNotBeCreated
}

class CoreDataStack {
    
    private let bundle: Bundle
    
    let mainContext: NSManagedObjectContext
    
    init(bundle: Bundle, storeURL: URL, storeType: String) throws {
        self.bundle = bundle
        
        guard
            let modelURL = self.bundle.url(forResource: "PickupRide", withExtension: "momd"),
            let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)
        else {
            throw CoreDataError.modelCouldNotBeCreated
        }
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        let options = [
            NSMigratePersistentStoresAutomaticallyOption: true,
            NSInferMappingModelAutomaticallyOption: true
        ]
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: storeType,
                                                              configurationName: nil,
                                                              at: storeType == NSSQLiteStoreType ? storeURL : nil,
                                                              options: options)
        } catch {
            throw CoreDataError.storeCouldNotBeCreated
        }
    }
}
