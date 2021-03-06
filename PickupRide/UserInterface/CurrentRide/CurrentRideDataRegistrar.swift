//
//  CurrentRideDataRegistrar.swift
//  PickupRide
//
//  Created by Niko Mikulicic on 06/02/2018.
//  Copyright © 2018 Niko Mikulicic. All rights reserved.
//

import Foundation
import RxSwift
import CoreLocation

class CurrentRideDataRegistrar {
    
    private let locationController: LocationController
    private let networkController: NetworkingController
    private let store: Store
    private let disposeBag = DisposeBag()

    private var activeBooking: Booking?
    private var registerGPSDataSubscription: Disposable?
    
    init(store: Store, locationController: LocationController, networkController: NetworkingController) {
        self.store = store
        self.locationController = locationController
        self.networkController = networkController
    }
    
    func registerAction(_ action: RideActionType, bookingInput: BookingInput) {
        if action == .startRide {
            activateBooking(for: bookingInput)
            startRegisteringGPSData()
        }
        
        if action == .endRide {
            stopRegisteringGPSData()
        }
        
        guard let location = locationController.location else { return }
        registerAction(action, at: location)
    }

    private func activateBooking(for bookingInput: BookingInput) {
        guard
            let passengers = Int(bookingInput.passengers),
            let booking = try? store.createBooking(addressFrom: bookingInput.addressFrom,
                                                   addressTo: bookingInput.addressTo,
                                                   date: Date(),
                                                   numberOfPassengers: passengers)
        else {
            return
        }
        
        networkController.send(booking: booking)
        activeBooking = booking
    }
    
    private func registerAction(_ action: RideActionType, at location: CLLocation) {
        guard let activeBooking = activeBooking else { return }
        let rideAction = store.createRideAction(for: activeBooking, location: location.coordinate, date: Date(), type: action)
        networkController.send(action: rideAction)
    }

    private func registerGPSData(at location: CLLocation) {
        guard let activeBooking = activeBooking else { return }
        let gpsData = store.createGPSData(for: activeBooking, location: location.coordinate, date: Date())
        networkController.send(gpsData: gpsData)
    }

    private func startRegisteringGPSData() {
        let gpsUpdateInterval = 5.0
        registerGPSDataSubscription = locationController.locationUpdated
            .throttle(gpsUpdateInterval, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] location in
                guard let location =  self?.locationController.location else { return }
                self?.registerGPSData(at: location)
            })
    }
    
    private func stopRegisteringGPSData() {
        registerGPSDataSubscription?.dispose()
    }
}
