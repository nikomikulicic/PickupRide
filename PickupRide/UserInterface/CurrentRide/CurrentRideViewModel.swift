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
    private var registerGPSDataSubscription: Disposable?
    
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
        
        subscribeToActions()
    }
    
    private func subscribeToActions() {
        let tappedAction = actionTapped
            .withLatestFrom(actions) { (index, actions) in actions[index] }
            .share(replay: 1)
        
        let startRideTapped = tappedAction.filter { $0 == .startRide }
        let endRideTapped = tappedAction.filter { $0 == .endRide }
        let otherActionTapped = tappedAction.filter { $0 != .startRide && $0 != .endRide }

        let location = locationController.location.share(replay: 1)

        startRideTapped
            .withLatestFrom(location) { ($0, $1) }
            .withLatestFrom(bookingInput) { (action: $0.0, location: $0.1, bookingInput: $1) }
            .subscribe(onNext: { [weak self] (action, location, bookingInput) in
                self?.startRegisteringGPSData()
                self?.activateBooking(for: bookingInput)
                self?.registerAction(action, at: location)
                self?.ride.moveToNextState(afterAction: action)
            }).disposed(by: disposeBag)
        
        endRideTapped
            .withLatestFrom(location) { (action: $0, location: $1) }
            .subscribe(onNext: { [weak self] (action, location) in
                self?.stopRegisteringGPSData()
                self?.registerAction(action, at: location)
                self?.ride.moveToNextState(afterAction: action)
            }).disposed(by: disposeBag)
        
        otherActionTapped
            .withLatestFrom(location) { (action: $0, location: $1) }
            .subscribe(onNext: { [weak self] (action, location) in
                self?.registerAction(action, at: location)
                self?.ride.moveToNextState(afterAction: action)
            }).disposed(by: disposeBag)
    }
    
    private func activateBooking(for bookingInput: BookingInput) {
        guard let passengers = Int(bookingInput.passengers) else { return }
        let booking = store.createBooking(addressFrom: bookingInput.addressFrom, addressTo: bookingInput.addressTo,
                                          date: Date(), numberOfPassengers: passengers)
        ride.activeBooking = booking
    }
    
    private func registerAction(_ action: RideActionType, at location: CLLocation) {
        guard let activeBooking = ride.activeBooking else { return }
        let location = Location(location: location)
        _ = store.createRideAction(for: activeBooking, location: location, date: Date(), type: action)
        print("Registered action '\(action)' at: \(location.latitude,location.longitude)")
    }
    
    private func registerGPSData(at location: CLLocation) {
        guard let activeBooking = ride.activeBooking else { return }
        let location = Location(location: location)
        _ = store.createGPSData(for: activeBooking, location: location, date: Date())
        print("Registered GPSData at: \(location.latitude,location.longitude)")
    }
    
    private func startRegisteringGPSData() {
        let locationUpdateInterval = 5.0
        let location = locationController.location.throttle(locationUpdateInterval, scheduler: MainScheduler.instance)
        registerGPSDataSubscription = location.subscribe(onNext: { [weak self] location in
            self?.registerGPSData(at: location)
        })
    }
    
    private func stopRegisteringGPSData() {
        registerGPSDataSubscription?.dispose()
    }
}
