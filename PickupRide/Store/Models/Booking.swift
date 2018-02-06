//
//  Booking.swift
//  PickupRide
//
//  Created by Niko Mikulicic on 02/02/2018.
//  Copyright © 2018 Niko Mikulicic. All rights reserved.
//

import CoreData
import CoreLocation

class Booking: NSManagedObject {
    
    @NSManaged var id: Int32
    @NSManaged var addressFrom: String
    @NSManaged var addressTo: String
    @NSManaged var date: Date
    @NSManaged var numberOfPassengers: Int32
    @NSManaged var route: Set<GPSData>
    @NSManaged var actions: Set<RideAction>
}

extension Booking: Managed {
    
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(date), ascending: false)]
    }
}
