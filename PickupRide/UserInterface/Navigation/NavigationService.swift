//
//  NavigationService.swift
//  PickupRide
//
//  Created by Niko Mikulicic on 01/02/2018.
//  Copyright © 2018 Niko Mikulicic. All rights reserved.
//

import UIKit

class NavigationService {
    
    let window: UIWindow
    let navigationController = NavigationController()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func displayInitialViewController() {
        let viewController = CurrentRideViewController()
        navigationController.viewControllers = [viewController]
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
