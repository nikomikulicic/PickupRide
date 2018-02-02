//
//  NavigationService.swift
//  PickupRide
//
//  Created by Niko Mikulicic on 01/02/2018.
//  Copyright © 2018 Niko Mikulicic. All rights reserved.
//

import UIKit
import RxSwift

class NavigationService {
    
    private let disposeBag = DisposeBag()
    private let window: UIWindow
    private let navigationController = NavigationController()
    private let userInfo = UserInfo(name: "Niko Mikuličić", age: 26, plateNumber: "ZG1303HR", profileImage: .avatar)
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func displayInitialViewController() {
        let viewModel = CurrentRideViewModel()
        let viewController = CurrentRideViewController(viewModel: viewModel)
        
        viewController.profileTapped.asObservable().subscribe(onNext: { [weak self] in
            self?.pushProfileViewController()
        }).disposed(by: disposeBag)
        
        navigationController.viewControllers = [viewController]
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func pushProfileViewController() {
        let viewModel = ProfileViewModel(userInfo: userInfo)
        let viewController = ProfileViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
