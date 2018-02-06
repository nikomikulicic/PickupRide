//
//  LocationController.swift
//  PickupRide
//
//  Created by Niko Mikulicic on 05/02/2018.
//  Copyright © 2018 Niko Mikulicic. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift

class LocationController: NSObject {
    
    private let locationManager: CLLocationManager
    private let disposeBag = DisposeBag()
    private let delegate = LocationManagerDelegate()
    
    private var hasAlwaysPermission: Bool {
        return CLLocationManager.authorizationStatus() == .authorizedAlways
    }
    
    var location: CLLocation? {
        return locationManager.location
    }
    
    var locationUpdated: Observable<Void> {
        return delegate.locationUpdated.asObservable()
    }

    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
        super.init()
        
        locationManager.delegate = delegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
    }
    
    func startUpdatingLocationIfAllowed() {
        if hasAlwaysPermission {
            locationManager.startUpdatingLocation()
        }
    }
    
    func requestPermissionsIfNeeded() {
        if !hasAlwaysPermission {
            locationManager.requestAlwaysAuthorization()
        }
    }
}

class LocationManagerDelegate: NSObject, CLLocationManagerDelegate {
    
    let locationUpdated = PublishSubject<Void>()

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            manager.startUpdatingLocation()
        default:
            manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationUpdated.onNext(())
    }
}
