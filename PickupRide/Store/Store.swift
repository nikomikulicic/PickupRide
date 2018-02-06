//
//  Store.swift
//  PickupRide
//
//  Created by Niko Mikulicic on 03/02/2018.
//  Copyright © 2018 Niko Mikulicic. All rights reserved.
//

import Foundation
import CoreLocation

class Store {
    
    private let stack: CoreDataStack
    
    init(stack: CoreDataStack) {
        self.stack = stack
    }
    
    func bookings() throws -> [Booking] {
        let bookings: [Booking] = try stack.mainContext.fetch(Booking.sortedFetchRequest)
        return bookings
    }
    
    func createBooking(addressFrom: String, addressTo: String, date: Date, numberOfPassengers: Int) throws -> Booking {
        let numberOfBookings = try stack.mainContext.count(for: Booking.sortedFetchRequest)
        
        let booking: Booking = stack.mainContext.insertObject()
        booking.addressFrom = addressFrom
        booking.addressTo = addressTo
        booking.date = date
        booking.numberOfPassengers = Int32(numberOfPassengers)
        booking.id = Int32(numberOfBookings)
        
        save()
        
        return booking
    }

    func createGPSData(for booking: Booking, location: CLLocationCoordinate2D, date: Date) -> GPSData {
        let gpsData: GPSData = stack.mainContext.insertObject()
        gpsData.location = location
        gpsData.date = date
        gpsData.booking = booking
        
        save()
        
        return gpsData
    }
    
    func createRideAction(for booking: Booking, location: CLLocationCoordinate2D, date: Date, type: RideActionType) -> RideAction {
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
