//
//  PreviousRidesViewModel.swift
//  PickupRide
//
//  Created by Niko Mikulicic on 06/02/2018.
//  Copyright © 2018 Niko Mikulicic. All rights reserved.
//

import Foundation
import RxSwift

class PreviousRidesViewModel {
    
    let previousRides: [Booking]
    let rideTapped = PublishSubject<Booking>()
    
    init(previousRides: [Booking]) {
        self.previousRides = previousRides
    }
    
    func itemTapped(at index: Int) {
        rideTapped.onNext(previousRides[index])
    }
}
