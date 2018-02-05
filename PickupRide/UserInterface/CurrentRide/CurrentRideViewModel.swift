//
//  CurrentRideViewModel.swift
//  PickupRide
//
//  Created by Niko Mikulicic on 01/02/2018.
//  Copyright © 2018 Niko Mikulicic. All rights reserved.
//

import Foundation
import RxSwift

struct RideActionData {
    let type: RideActionType
    let image: BundleImage
    let title: String
}

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
    
    let actions = Variable<[RideActionData]>([])
    let addressFrom = PublishSubject<String>()
    let addressTo = PublishSubject<String>()
    let passengers = PublishSubject<String>()
    
    var actionsEnabled: Observable<Bool> {
        return Observable
            .combineLatest(addressFrom, addressTo, passengers) { BookingInput(addressFrom: $0, addressTo: $1, passengers: $2) }
            .map { $0.isValid }
            .startWith(false)
    }
    
    var inputEnabled: Observable<Bool> {
        return actions.asObservable()
            .map { $0[0].type == .startRide }
            .startWith(true)
    }

    init() {
        let initialAction = createRideAction(ofType: .startRide)
        actions.value = [initialAction]
    }

    func actionTapped(at index: Int) {
        let tappedActionType = actions.value[index].type
        let nextActions = nextActionTypes(for: tappedActionType).map { createRideAction(ofType: $0) }
        actions.value = nextActions
    }
    
    private func nextActionTypes(for type: RideActionType) -> [RideActionType] {
        switch type {
        case .startRide:
            return [.passengerPickedUp]
        case .passengerPickedUp:
            return [.stopOver, .endRide]
        case .stopOver:
            return [.continueRide]
        case .continueRide:
            return [.stopOver, .endRide]
        case .endRide:
            return [.startRide]
        }
    }
    
    private func createRideAction(ofType type: RideActionType) -> RideActionData {
        return RideActionData(type: type,
                              image: BundleImage.image(for: type),
                              title: Texts.actionTitle(for: type))
    }
}
