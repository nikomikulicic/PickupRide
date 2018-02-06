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
        
        locationController.requestPermissionsIfNeeded()
        locationController.startUpdatingLocationIfAllowed()
    }
    
    func displayInitialViewController() {
        let ride = Ride(initialState: .idle)
        let viewModel = CurrentRideViewModel(store: store, locationController: locationController, ride: ride)
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
        print("Previous rides")
    }
    
    private func openAppSettings() {
        guard let settingsURL = URL(string:UIApplicationOpenSettingsURLString) else { return }
        UIApplication.shared.open(settingsURL)
    }
}
