//
//  NetworkingData.swift
//  PickupRide
//
//  Created by Niko Mikulicic on 06/02/2018.
//  Copyright © 2018 Niko Mikulicic. All rights reserved.
//

import Foundation

class GPSAPIData: Codable {
    
    enum CodingKeys: String, CodingKey {
        case bookingId = "bookingId"
        case latitude = "lat"
        case longitude = "lng"
        case date = "time"
    }
    
    let bookingId: Int32
    let latitude: Double
    let longitude: Double
    let date: String
    
    init(from data: GPSData) {
        bookingId = data.booking.id
        latitude = data.location.latitude
        longitude = data.location.longitude
        date = DateFormatter.dateTimeFormatter.string(from: data.date)
    }
}

extension RideActionType: Codable { }

class RideActionAPIData: Codable {
    
    enum CodingKeys: String, CodingKey {
        case bookingId = "bookingId"
        case latitude = "lat"
        case longitude = "lng"
        case date = "time"
        case type = "status"
    }
    
    let bookingId: Int32
    let latitude: Double
    let longitude: Double
    let date: String
    let type: RideActionType
    
    init(from data: RideAction) {
        bookingId = data.booking.id
        latitude = data.location.latitude
        longitude = data.location.longitude
        type = data.type
        date = DateFormatter.dateTimeFormatter.string(from: data.date)
    }
}

class BookingAPIData: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case addressFrom
        case addressTo
        case passengers
    }
    
    let id: Int32
    let addressFrom: String
    let addressTo: String
    let passengers: Int32
    
    init(from data: Booking) {
        id = data.id
        addressFrom = data.addressFrom
        addressTo = data.addressTo
        passengers = data.numberOfPassengers
    }
}
