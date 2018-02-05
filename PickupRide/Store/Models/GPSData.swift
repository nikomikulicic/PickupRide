//
//  GPSData.swift
//  PickupRide
//
//  Created by Niko Mikulicic on 02/02/2018.
//  Copyright © 2018 Niko Mikulicic. All rights reserved.
//

import Foundation
import CoreData

class GPSData: NSManagedObject {
    @NSManaged var date: Date
    @NSManaged var location: Location
    @NSManaged var booking: Booking
}

extension GPSData: Managed {
    
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(date), ascending: true)]
    }
}
