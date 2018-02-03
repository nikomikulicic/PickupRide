//
//  RideAction.swift
//  PickupRide
//
//  Created by Niko Mikulicic on 02/02/2018.
//  Copyright © 2018 Niko Mikulicic. All rights reserved.
//

import Foundation
import CoreData

enum RideActionType: String {
    case startRide
    case passengerPickedUp
    case stopOver
    case continueRide
    case endRide
}

private extension RideActionType {
    var id: String {
        return String(describing: self)
    }
    
    init?(id: String) {
        self = RideActionType(rawValue: id)!
    }
}

class RideAction: NSManagedObject {
    @NSManaged var date: Date
    @NSManaged private var typeId: String
    
    var type: RideActionType {
        get { return RideActionType(id: typeId)! }
        set { typeId = newValue.id }
    }
}
