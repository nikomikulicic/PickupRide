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

enum LocationError: Error {
    case permissionDenied
    case locationUpdateFailed
    case other
}

class LocationController: NSObject {
    
    private let locationManager: CLLocationManager
    private let disposeBag = DisposeBag()
    private let delegate = LocationManagerDelegate()
    
    private var hasAlwaysPermission: Bool {
        return CLLocationManager.authorizationStatus() == .authorizedAlways
    }
    
    var location: Observable<CLLocation> {
        return delegate.location.asObservable()
    }

    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
        super.init()
        
        locationManager.delegate = delegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
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
    
    let location = PublishSubject<CLLocation>()
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            manager.startUpdatingLocation()
        default:
            manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.last else { return }
        location.onNext(latestLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let error = error as? CLError else {
            location.onError(LocationError.other)
            return
        }
        
        switch error.code {
        case CLError.denied:
            location.onError(LocationError.permissionDenied)
        default:
            location.onError(LocationError.locationUpdateFailed)
        }
    }
}
