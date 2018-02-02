//
//  BundleImage.swift
//  PickupRide
//
//  Created by Niko Mikulicic on 01/02/2018.
//  Copyright © 2018 Niko Mikulicic. All rights reserved.
//

import UIKit

enum BundleImage: String {
    
    case profile = "icProfile"
    case pin = "icPin"
    case list = "icList"
    
    case stopOver = "icPause"
    case startRide = "icCar"
    case continueRide = "icPlay"
    case passengers = "icPeople"
    case endRide = "icCheckmark"
    
    case avatar = "avatar"
    
    static func image(for type: RideActionType) -> BundleImage {
        switch type {
        case .stopOver:
            return .stopOver
        case .startRide:
            return .startRide
        case .continueRide:
            return .continueRide
        case .passengerPickedUp:
            return .passengers
        case .endRide:
            return .endRide
        }
    }
}

extension UIImage {
    
    convenience init(from bundleImage: BundleImage) {
        self.init(named: bundleImage.rawValue)!
    }
}
