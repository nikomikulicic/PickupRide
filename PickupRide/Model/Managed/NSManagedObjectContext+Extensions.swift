//
//  NSManagedObjectContext+Extensions.swift
//  PickupRide
//
//  Created by Niko Mikulicic on 03/02/2018.
//  Copyright © 2018 Niko Mikulicic. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    
    func insertObject<A: NSManagedObject>() -> A where A: Managed {
        let obj = NSEntityDescription.insertNewObject(forEntityName: A.entityName, into: self) as! A
        return obj
    }
    
    func fetch<A: NSManagedObject>(configurationBlock: (NSFetchRequest<A>) -> () = { _ in }) throws -> [A] where A: Managed {
        let request = NSFetchRequest<A>(entityName: A.entityName)
        configurationBlock(request)
        return try fetch(request)
    }
    
    func saveOrRollback() -> Bool {
        do {
            try save()
            return true
        } catch {
            rollback()
            return false
        }
    }
    
    func performChanges(block: @escaping () -> ()) {
        perform {
            block()
            _ = self.saveOrRollback()
        }
    }
}
