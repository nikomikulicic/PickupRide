//
//  CurrentRideViewModel.swift
//  PickupRide
//
//  Created by Niko Mikulicic on 01/02/2018.
//  Copyright © 2018 Niko Mikulicic. All rights reserved.
//

import Foundation
import RxSwift

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
    
    private let ride: Ride
    private let dataRegistrar: CurrentRideDataRegistrar
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
    
    init(ride: Ride, dataRegistrar: CurrentRideDataRegistrar) {
        self.ride = ride
        self.dataRegistrar = dataRegistrar
        
        let tappedAction = actionTapped.withLatestFrom(actions) { (index, actions) in actions[index] }
        tappedAction
            .withLatestFrom(bookingInput) { (action: $0, bookingInput: $1) }
            .subscribe(onNext: { [weak self] (action, bookingInput) in
                self?.dataRegistrar.registerAction(action, bookingInput: bookingInput)
                self?.ride.moveToNextState(afterAction: action)
            }).disposed(by: disposeBag)
    }
}
