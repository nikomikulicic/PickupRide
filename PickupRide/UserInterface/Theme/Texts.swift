//
//  Texts.swift
//  PickupRide
//
//  Created by Niko Mikulicic on 01/02/2018.
//  Copyright © 2018 Niko Mikulicic. All rights reserved.
//

import Foundation

class Texts {
 
    static func actionTitle(for type: RideActionType) -> String {
        switch type {
        case .startRide:
            return "Start ride"
        case .continueRide:
            return "Continue driving"
        case .endRide:
            return "End ride"
        case .stopOver:
            return "Stop over"
        case .passengerPickedUp:
            return "Passenger picked up"
        }
    }
}
