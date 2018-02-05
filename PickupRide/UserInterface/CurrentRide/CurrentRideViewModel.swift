//
//  CurrentRideViewModel.swift
//  PickupRide
//
//  Created by Niko Mikulicic on 01/02/2018.
//  Copyright © 2018 Niko Mikulicic. All rights reserved.
//

import Foundation
import RxSwift
import CoreLocation

struct BookingInput {
    let addressFrom: String
    let addressTo: String
    let passengers: String
    
    var isValid: Bool {
        let areAllFieldsPopulated = addressFrom.count > 0 && addressTo.count > 0 && passengers.count > 0
        guard areAllFieldsPopulated else { return false }
        guard let numberOfPassengers = Int(passengers) else { return false }
        return numberOfPassengers > 0
    }
}

class CurrentRideViewModel {
    
    private let store: Store
    private let locationController: LocationController
    private let ride: Ride
    private let disposeBag = DisposeBag()
    
    let addressFrom = PublishSubject<String>()
    let addressTo = PublishSubject<String>()
    let passengers = PublishSubject<String>()
    let actionTapped = PublishSubject<Int>()
    
    var actions: Observable<[RideActionType]> {
        return ride.state.asObservable().map { $0.actions }
    }
    
    var actionsEnabled: Observable<Bool> {
        return bookingInput
            .map { $0.isValid }
            .startWith(false)
    }
    
    var inputEnabled: Observable<Bool> {
        return ride.state.asObservable().map { $0 == .idle }
    }
    
    private var bookingInput: Observable<BookingInput> {
        return Observable.combineLatest(addressFrom, addressTo, passengers) {
            BookingInput(addressFrom: $0, addressTo: $1, passengers: $2)
        }
    }
    
    init(store: Store, locationController: LocationController, ride: Ride) {
        self.store = store
        self.locationController = locationController
        self.ride = ride
        
        let tappedAction = actionTapped.withLatestFrom(actions) { (index, actions) in actions[index] }
        tappedAction
            .withLatestFrom(bookingInput) { (action: $0, input: $1) }
            .subscribe(onNext: { [weak self] data in
                self?.handleActionTapped(action: data.action, bookingInput: data.input)
            }).disposed(by: disposeBag)
    }
    
    private func handleActionTapped(action: RideActionType, bookingInput: BookingInput) {
        if action == .startRide {
            startRecordingRide(bookingInput: bookingInput)
        }
        recordAction(action)
        ride.moveToNextState(afterAction: action)
    }
    
    private func startRecordingRide(bookingInput: BookingInput) {
        guard let passengers = Int(bookingInput.passengers) else { return }
        let locationFrom = Location(latitude: 0, longitude: 0) // TODO: fetch from geocoder
        let locationTo = Location(latitude: 0, longitude: 0)
        let currentLocation = Location(latitude: 1, longitude: 1) // TODO: fetch from location services
        let booking = store.createBooking(addressFrom: bookingInput.addressFrom, addressTo: bookingInput.addressTo,
                                          locationFrom: locationFrom, locationTo: locationTo,
                                          date: Date(), numberOfPassengers: passengers)
        ride.activeBooking = booking
    }
    
    private func recordAction(_ action: RideActionType) {
        guard let activeBooking = ride.activeBooking else { return }
        let location = Location(latitude: 1, longitude: 1) // TODO: fetch from location services
        _ = store.createRideAction(for: activeBooking, location: location, date: Date(), type: action)
    }
}
