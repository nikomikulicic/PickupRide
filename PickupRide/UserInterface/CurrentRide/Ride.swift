//
//  Ride.swift
//  PickupRide
//
//  Created by Niko Mikulicic on 05/02/2018.
//  Copyright © 2018 Niko Mikulicic. All rights reserved.
//

import Foundation
import RxSwift

enum RideState {
    case idle
    case drivingPassengers
    case drivingToPickupLocation
    case stopped

    var actions: [RideActionType] {
        switch self {
        case .idle:
            return [.startRide]
        case .drivingToPickupLocation:
            return [.passengerPickedUp]
        case .drivingPassengers:
            return [.stopOver, .endRide]
        case .stopped:
            return [.continueRide]
        }
    }
    
    func next(after action: RideActionType) -> RideState? {
        assert(actions.contains(action), "Action \(action) not defined for state \(self)")
        switch self {
        case .idle:
            return .drivingToPickupLocation
        case .drivingToPickupLocation:
            return .drivingPassengers
        case .drivingPassengers:
            switch action {
            case .stopOver:
                return .stopped
            case .endRide:
                return .idle
            default:
                assertionFailure("Unhandled action \(action) in state \(self)")
            }
        case .stopped:
            return .drivingPassengers
        }
        
        return nil
    }
}

class Ride {
    
    private(set) var state = Variable<RideState>(.idle)
    var activeBooking: Booking?
    
    init(initialState: RideState) {
        state.value = initialState
    }

    func moveToNextState(afterAction action: RideActionType) {
        guard let nextState = state.value.next(after: action) else { return }
        state.value = nextState
    }
}
