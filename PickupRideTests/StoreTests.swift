//
//  StoreTests.swift
//  PickupRideTests
//
//  Created by Niko Mikulicic on 03/02/2018.
//  Copyright © 2018 Niko Mikulicic. All rights reserved.
//

import Foundation
import XCTest
import CoreData
@testable import PickupRide

class StoreTests: XCTestCase {
    
    private let fileManager = FileManager.default
    private var fileSystem: FileSystem!
    
    private var testStoreURL: URL {
        return fileManager.urls(for: .libraryDirectory, in: .userDomainMask)[0].appendingPathComponent("test.sqlite")
    }
    
    override func setUp() {
        fileSystem = FileSystem(fileManager: fileManager)
            
        try? fileManager.removeItem(at: testStoreURL)
    }
    
    func testThatDatabaseIsCreated() {
        let stack = try! CoreDataStack(bundle: Bundle.main, storeURL: testStoreURL, storeType: NSSQLiteStoreType)
        let databaseIsCreated = fileManager.fileExists(atPath: testStoreURL.path)
        XCTAssertTrue(databaseIsCreated)
    }
}
