//
//  RideAction.swift
//  PickupRide
//
//  Created by Niko Mikulicic on 02/02/2018.
//  Copyright © 2018 Niko Mikulicic. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

enum RideActionType: String {
    case startRide
    case passengerPickedUp
    case stopOver
    case continueRide
    case endRide
}

class RideAction: NSManagedObject {
    @NSManaged var date: Date
    @NSManaged private var latitude: Double
    @NSManaged private var longitude: Double
    @NSManaged private var typeId: String
    @NSManaged var booking: Booking

    var type: RideActionType {
        get { return RideActionType(rawValue: typeId)! }
        set { typeId = String(describing: newValue) }
    }
    
    var location: CLLocationCoordinate2D {
        get { return CLLocationCoordinate2D(latitude: latitude, longitude: longitude) }
        set {
            latitude = newValue.latitude
            longitude = newValue.longitude
        }
    }
}

extension RideAction: Managed {
    
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(date), ascending: true)]
    }
}
