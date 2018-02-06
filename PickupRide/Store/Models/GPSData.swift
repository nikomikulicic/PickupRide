//
//  GPSData.swift
//  PickupRide
//
//  Created by Niko Mikulicic on 02/02/2018.
//  Copyright © 2018 Niko Mikulicic. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

class GPSData: NSManagedObject {
    @NSManaged var date: Date
    @NSManaged private var latitude: Double
    @NSManaged private var longitude: Double
    @NSManaged var booking: Booking
    
    var location: CLLocationCoordinate2D {
        get { return CLLocationCoordinate2D(latitude: latitude, longitude: longitude) }
        set {
            latitude = newValue.latitude
            longitude = newValue.longitude
        }
    }
}

extension GPSData: Managed {
    
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(date), ascending: true)]
    }
}
