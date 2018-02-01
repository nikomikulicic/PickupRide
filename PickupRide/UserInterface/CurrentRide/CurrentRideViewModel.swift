//
//  CurrentRideViewModel.swift
//  PickupRide
//
//  Created by Niko Mikulicic on 01/02/2018.
//  Copyright © 2018 Niko Mikulicic. All rights reserved.
//

import Foundation
import RxSwift

enum RideActionType {
    case startRide
    case passengerPickedUp
    case stopOver
    case continueRide
    case endRide
}

struct RideAction {
    let type: RideActionType
    let image: BundleImage
}

class CurrentRideViewModel {
    
    let actions = Variable<[RideAction]>([])

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
    
    private func createRideAction(ofType type: RideActionType) -> RideAction {
        return RideAction(type: type, image: BundleImage.image(for: type))
    }
}
