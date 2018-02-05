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
    private var locationUpdateSubscription: Disposable?
    private let locationUpdateInterval = 5.0
    
    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
        super.init()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    }
    
    private var hasAlwaysPermission: Bool {
        return CLLocationManager.authorizationStatus() == .authorizedAlways
    }
    
    func requestPermissionsIfNeeded() {
        if !hasAlwaysPermission {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func startUpdatingLocation() -> Observable<CLLocation> {
        let delegate = LocationManagerDelegate()
        locationManager.delegate = delegate
        
       return Observable
            .just(())
            .do { [weak self] in self?.startRequestingLocation() }
            .flatMap { delegate.location.asObservable() }
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
        locationUpdateSubscription?.dispose()
    }
    
    private func startRequestingLocation() {
        locationManager.requestLocation()

        guard hasAlwaysPermission else { return }
        locationUpdateSubscription = Observable<Int>
            .interval(locationUpdateInterval, scheduler: MainScheduler.instance)
            .map { _ in () }
            .startWith(())
            .subscribe(onNext: { [weak self] _ in
                self?.locationManager.requestLocation()
            })
    }
}

class LocationManagerDelegate: NSObject, CLLocationManagerDelegate {
    
    let location = PublishSubject<CLLocation>()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.last else { return }
        location.onNext(latestLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error in location")
    }
}
