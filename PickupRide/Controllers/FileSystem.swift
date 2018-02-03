//
//  FileSystem.swift
//  PickupRide
//
//  Created by Niko Mikulicic on 03/02/2018.
//  Copyright © 2018 Niko Mikulicic. All rights reserved.
//

import Foundation

class FileSystem {
    
    private let fileManager: FileManager
    
    init(fileManager: FileManager) {
        self.fileManager = fileManager
    }
    
    var storeName: String {
        return "pickup_ride.sqlite"
    }
    
    var storeURL: URL {
        return applicationSupportDirectoryURL.appendingPathComponent(storeName)
    }
    
    var applicationSupportDirectoryURL: URL {
        return fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
    }
    
    func createApplicationSupportDirectoryIfMissing() throws {
        try fileManager.createDirectory(at: applicationSupportDirectoryURL, withIntermediateDirectories: true, attributes: nil)
    }
}
