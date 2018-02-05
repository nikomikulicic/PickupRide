//
//  Store.swift
//  PickupRide
//
//  Created by Niko Mikulicic on 03/02/2018.
//  Copyright © 2018 Niko Mikulicic. All rights reserved.
//

import Foundation

class Store {
    
    private let stack: CoreDataStack
    
    init(stack: CoreDataStack) {
        self.stack = stack
    }
    
    func createBooking(addressFrom: String, addressTo: String, locationFrom: Location, locationTo: Location,
                       date: Date, numberOfPassengers: Int) -> Booking {
        let booking: Booking = stack.mainContext.insertObject()
        booking.addressFrom = addressFrom
        booking.addressTo = addressTo
        booking.locationFrom = locationFrom
        booking.locationTo = locationTo
        booking.date = date
        booking.numberOfPassengers = Int32(numberOfPassengers)
        
        save()
        
        return booking
    }

    func createGPSData(for booking: Booking, location: Location, date: Date) -> GPSData {
        let gpsData: GPSData = stack.mainContext.insertObject()
        gpsData.location = location
        gpsData.date = date
        gpsData.booking = booking
        
        save()
        
        return gpsData
    }
    
    func createRideAction(for booking: Booking, location: Location, date: Date, type: RideActionType) -> RideAction {
        let action: RideAction = stack.mainContext.insertObject()
        action.location = location
        action.date = date
        action.type = type
        action.booking = booking
        
        save()
        
        return action
    }
    
    private func save() {
        let _ = stack.mainContext.saveOrRollback()
    }
}
