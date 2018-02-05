//
//  Location.swift
//  PickupRide
//
//  Created by Niko Mikulicic on 02/02/2018.
//  Copyright © 2018 Niko Mikulicic. All rights reserved.
//

import Foundation
import CoreLocation

private enum PropertyKey: String {
    case latitude
    case longitude
}

class Location: NSObject, NSCoding {
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees

    init(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        self.latitude = latitude
        self.longitude = longitude
        super.init()
    }
    
    convenience init(location: CLLocation) {
        self.init(latitude: location.coordinate.latitude,
                  longitude: location.coordinate.longitude)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard
            let latitude = aDecoder.decodeObject(forKey: PropertyKey.latitude.rawValue) as? Double,
            let longitude = aDecoder.decodeObject(forKey: PropertyKey.longitude.rawValue) as? Double
        else { return nil }
        self.init(latitude: latitude, longitude: longitude)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(latitude, forKey: PropertyKey.latitude.rawValue)
        aCoder.encode(longitude, forKey: PropertyKey.longitude.rawValue)
    }

}
