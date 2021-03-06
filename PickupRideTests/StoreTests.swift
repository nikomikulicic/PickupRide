//
//  StoreTests.swift
//  PickupRideTests
//
//  Created by Niko Mikulicic on 03/02/2018.
//  Copyright © 2018 Niko Mikulicic. All rights reserved.
//

import Foundation
import XCTest
import CoreData
import CoreLocation
@testable import PickupRide

class StoreTests: XCTestCase {
    
    private let fileManager = FileManager.default
    private var fileSystem: FileSystem!
    
    private var testStoreURL: URL {
        return fileManager.urls(for: .libraryDirectory, in: .userDomainMask)[0].appendingPathComponent("test.sqlite")
    }
    
    override func setUp() {
        fileSystem = FileSystem(fileManager: fileManager)
            
        try? fileManager.removeItem(at: testStoreURL)
    }
    
    func testThatDatabaseIsCreated() {
        let stack = try! CoreDataStack(bundle: Bundle.main, storeURL: testStoreURL, storeType: NSSQLiteStoreType)
        let databaseIsCreated = fileManager.fileExists(atPath: testStoreURL.path)
        XCTAssertTrue(databaseIsCreated)
    }
    
    func testThatBookingCanBeCreated() {
        let stack = createInMemoryStack()
        let store = Store(stack: stack)
        let booking = try! store.createBooking(addressFrom: "A", addressTo: "B", date: Date(), numberOfPassengers: 2)

        let bookings: [Booking] = try! stack.mainContext.fetch()
        XCTAssertEqual(bookings.count, 1)
        XCTAssertEqual(bookings[0].addressFrom, booking.addressFrom)
        XCTAssertEqual(bookings[0].addressTo, booking.addressTo)
        XCTAssertEqual(bookings[0].date, booking.date)
        XCTAssertEqual(bookings[0].numberOfPassengers, booking.numberOfPassengers)
    }
    
    func testThatGPSDataCanBeAddedToBooking() {
        let stack = createInMemoryStack()
        let store = Store(stack: stack)
        let booking = try! store.createBooking(addressFrom: "A", addressTo: "B", date: Date(), numberOfPassengers: 2)
        let gpsData = store.createGPSData(for: booking, location: CLLocationCoordinate2D(latitude: 1, longitude: 1), date: Date())
        
        let bookings: [Booking] = try! stack.mainContext.fetch()
        XCTAssertEqual(bookings[0].route.count, 1)
        XCTAssertEqual(bookings[0].route.first!.location.latitude, gpsData.location.longitude)
        XCTAssertEqual(bookings[0].route.first!.location.longitude, gpsData.location.longitude)
        XCTAssertEqual(bookings[0].route.first!.date, gpsData.date)
    }
    
    func testThatRideActionCanBeAddedToBooking() {
        let stack = createInMemoryStack()
        let store = Store(stack: stack)
        let booking = try! store.createBooking(addressFrom: "A", addressTo: "B", date: Date(), numberOfPassengers: 2)
        let action = store.createRideAction(for: booking, location: CLLocationCoordinate2D(latitude: 1, longitude: 1), date: Date(), type: .startRide)
        
        let bookings: [Booking] = try! stack.mainContext.fetch()
        XCTAssertEqual(bookings[0].actions.count, 1)
        XCTAssertEqual(bookings[0].actions.first!.location.latitude, action.location.longitude)
        XCTAssertEqual(bookings[0].actions.first!.location.longitude, action.location.longitude)
        XCTAssertEqual(bookings[0].actions.first!.date, action.date)
        XCTAssertEqual(bookings[0].actions.first!.type, action.type)
    }
    
    private func createInMemoryStack() -> CoreDataStack {
        let url = URL(fileURLWithPath: "")
        let stack = try! CoreDataStack(bundle: Bundle.main, storeURL: url, storeType: NSInMemoryStoreType)
        return stack
    }
}
