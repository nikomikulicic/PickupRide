//
//  RideDetailsViewModel.swift
//  PickupRide
//
//  Created by Niko Mikulicic on 06/02/2018.
//  Copyright © 2018 Niko Mikulicic. All rights reserved.
//

import Foundation
import CoreLocation

struct ActionAnnotationData {
    let location: CLLocationCoordinate2D
    let text: String
}

class RideDetailsViewModel {
    
    let route: [CLLocationCoordinate2D]
    let actionData: [ActionAnnotationData]
    
    init(gpsData: [GPSData], actions: [RideAction]) {
        route = gpsData.map { $0.location }
        actionData = actions.map { ActionAnnotationData(location: $0.location, text: $0.type.rawValue) }
    }
}
