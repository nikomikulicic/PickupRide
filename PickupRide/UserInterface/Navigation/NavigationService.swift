//
//  NavigationService.swift
//  PickupRide
//
//  Created by Niko Mikulicic on 01/02/2018.
//  Copyright © 2018 Niko Mikulicic. All rights reserved.
//

import UIKit
import RxSwift
import CoreData
import CoreLocation

class NavigationService {
    
    private let disposeBag = DisposeBag()
    private let window: UIWindow
    private let navigationController = NavigationController()
    
    private let userInfo = UserInfo(name: "Niko Mikuličić", age: 26, plateNumber: "ZG1303HR", profileImage: .avatar)
    private let fileSystem = FileSystem(fileManager: FileManager.default)
    private let bundle = Bundle.main
    private let store: Store
    private let locationController: LocationController
    private let networkController: NetworkingController
    
    init(window: UIWindow) {
        self.window = window
        
        guard let _ = try? fileSystem.createApplicationSupportDirectoryIfMissing() else {
            fatalError("Could not create application support directory")
        }
        guard let coreDataStack = try? CoreDataStack(bundle: bundle, storeURL: fileSystem.storeURL, storeType: NSSQLiteStoreType) else {
            fatalError("Could not create core data stack")
        }
        
        store = Store(stack: coreDataStack)
        locationController = LocationController(locationManager: CLLocationManager())
        networkController = NetworkingController(session: URLSession.shared)
        
        locationController.requestPermissionsIfNeeded()
        locationController.startUpdatingLocationIfAllowed()
    }
    
    func displayInitialViewController() {
        let ride = Ride(initialState: .idle)
        let registrar = CurrentRideDataRegistrar(store: store, locationController: locationController, networkController: networkController)
        let viewModel = CurrentRideViewModel(ride: ride, dataRegistrar: registrar)
        let viewController = CurrentRideViewController(viewModel: viewModel)
        
        viewController.profileTapped.asObservable().subscribe(onNext: { [weak self] in
            self?.pushProfileViewController()
        }).disposed(by: disposeBag)
        
        navigationController.viewControllers = [viewController]
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    private func pushProfileViewController() {
        let viewModel = ProfileViewModel(userInfo: userInfo)
        let viewController = ProfileViewController(viewModel: viewModel)
        
        viewModel.optionTapped.subscribe(onNext: { [weak self] option in
            switch option {
            case .locationSettings:
                self?.openAppSettings()
            case .previousRides:
                self?.pushPreviousRidesViewController()
            }
        }).disposed(by: disposeBag)
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func pushPreviousRidesViewController() {
        let bookings = (try? store.bookings()) ?? []
        let viewModel = PreviousRidesViewModel(previousRides: bookings)
        let viewController = PreviousRidesViewController(viewModel: viewModel)
        
        viewModel.rideTapped.subscribe(onNext: { [weak self] booking in
            self?.pushRideDetailsViewController(booking: booking)
        }).disposed(by: disposeBag)
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func pushRideDetailsViewController(booking: Booking) {
        print("Push ride details")
    }
    
    private func openAppSettings() {
        guard let settingsURL = URL(string:UIApplicationOpenSettingsURLString) else { return }
        UIApplication.shared.open(settingsURL)
    }
}
